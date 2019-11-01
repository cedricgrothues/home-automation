package routes

import (
	"database/sql"
	"encoding/json"
	"net/http"
	"regexp"

	"github.com/julienschmidt/httprouter"
)

// Database : shared DB instance, initalized in package main
var Database *sql.DB

// Room : instance of a room
type Room struct {
	ID      string   `json:"id"`
	Name    string   `json:"name"`
	Devices []Device `json:"devices,omitempty"`
}

// AllRooms handles GET /rooms and returns a 200 status code with all rooms and their according devices
func AllRooms(w http.ResponseWriter, r *http.Request, p httprouter.Params) {

	var rooms []Room

	rows, err := Database.Query(`SELECT id, name FROM rooms`)

	defer rows.Close()

	if err != nil {
		panic(err)
	}

	for rows.Next() {
		var room Room

		rows.Scan(&room.ID, &room.Name)

		deviceRows, err := Database.Query(`SELECT id, name, type, controller FROM devices WHERE room_id=?`, room.ID)

		defer deviceRows.Close()

		if err != nil {
			panic(err)
		}

		for deviceRows.Next() {
			var d Device

			deviceRows.Scan(&d.ID, &d.Name, &d.Type, &d.Controller)
			room.Devices = append(room.Devices, d)
		}

		rooms = append(rooms, room)
	}

	w.Header().Add("Content-Type", "application/json; charset=utf-8")
	w.WriteHeader(http.StatusOK)

	bytes, err := json.Marshal(rooms)

	if err != nil {
		panic("A problem occured while converting JSON: " + err.Error())
	}

	w.Write(bytes)
}

// AddRoom Adds a device
func AddRoom(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	r.ParseForm()

	// Check if all params are present, if not abort with 400 error
	if !(len(r.Form["id"]) > 0 && len(r.Form["name"]) > 0) {
		w.Header().Add("Content-Type", "application/json; charset=utf-8")
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte(`{"message":"Missing parameter(s), refer to the documentation for more information."}`))
		return
	}

	// match id agains regex pattern to ensure it´s valid
	if match, _ := regexp.MatchString(`^\w+$`, r.Form["id"][0]); !match {
		w.Header().Add("Content-Type", "application/json; charset=utf-8")
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte(`{"message":"ID contains invalid characters, refer to the documentation for more information."}`))
		return
	}

	_, err := Database.Exec("INSERT INTO rooms(id, name) values(?,?)", r.Form["id"][0], r.Form["name"][0])

	if err != nil {
		panic(err)
	}

	var room Room

	err = Database.QueryRow("SELECT id, name FROM rooms WHERE id=?", r.Form["id"][0]).Scan(&room.ID, &room.Name)

	if err != nil {
		panic(err)
	}

	w.Header().Add("Content-Type", "application/json; charset=utf-8")
	w.WriteHeader(http.StatusCreated)

	bytes, err := json.Marshal(room)

	if err != nil {
		panic("A problem occured while converting JSON: " + err.Error())
	}

	w.Write(bytes)
}

// GetRoom Gets a specific device
func GetRoom(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	var room Room

	err := Database.QueryRow(`SELECT id, name FROM rooms WHERE id=?`, p[0].Value).Scan(&room.ID, &room.Name)

	if err != nil {
		if err != sql.ErrNoRows {
			panic(err)
		} else {
			w.Header().Add("Content-Type", "application/json; charset=utf-8")
			w.WriteHeader(http.StatusNotFound)
			w.Write([]byte(`{"message":"Room with ID '` + p[0].Value + `' not found."}`))
			return
		}
	}

	rows, err := Database.Query(`SELECT id, name, type, controller FROM devices WHERE room_id=?`, p[0].Value)

	defer rows.Close()

	if err != nil {
		panic(err)
	}

	for rows.Next() {
		var d Device

		rows.Scan(&d.ID, &d.Name, &d.Type, &d.Controller)
		room.Devices = append(room.Devices, d)
	}

	w.Header().Add("Content-Type", "application/json; charset=utf-8")
	w.WriteHeader(http.StatusOK)

	bytes, err := json.Marshal(room)

	if err != nil {
		panic("A problem occured while converting JSON: " + err.Error())
	}

	w.Write(bytes)
}

// DeleteRoom deletes a specified room
func DeleteRoom(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	var id string

	err := Database.QueryRow("SELECT id FROM rooms WHERE id=?", p[0].Value).Scan(&id)

	if err != nil {
		if err != sql.ErrNoRows {
			panic(err)
		} else {
			w.Header().Add("Content-Type", "application/json; charset=utf-8")
			w.WriteHeader(http.StatusNotFound)
			w.Write([]byte(`{"message":"Room with ID '` + p[0].Value + `' not found."}`))
			return
		}
	}

	statement, err := Database.Prepare("DELETE FROM rooms WHERE id=?")
	_, err = statement.Exec(p[0].Value)

	defer statement.Close()

	if err != nil {
		panic(err)
	}

	statement, err = Database.Prepare("DELETE FROM devices WHERE room_id=?")
	_, err = statement.Exec(p[0].Value)

	defer statement.Close()

	if err != nil {
		panic(err)
	}

	w.WriteHeader(http.StatusNoContent)
}
