package routes

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"net/http"
	"regexp"

	"github.com/cedricgrothues/home-automation/libraries/go/errors"
	"github.com/julienschmidt/httprouter"
)

// Database defines a new shared sqlite3 shared instance, that is defined in main package's main() method
var Database *sql.DB

// Room has an id, name and devices
type Room struct {
	ID      string   `json:"id"`
	Name    string   `json:"name"`
	Devices []Device `json:"devices,omitempty"`
}

// AllRooms handles all GET /rooms and handles them accordingly
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

		deviceRows, err := Database.Query(`SELECT id, name, type, controller, address FROM devices WHERE room_id=?`, room.ID)

		defer deviceRows.Close()

		if err != nil {
			panic(err)
		}

		for deviceRows.Next() {
			var d Device

			deviceRows.Scan(&d.ID, &d.Name, &d.Type, &d.Controller, &d.Address)
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

// AddRoom trys to inserts a new room to the database instance defined in the Database variable
func AddRoom(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	r.ParseForm()

	// Check if all params are present, if not abort with 400 error
	if !(len(r.Form["id"]) > 0 && len(r.Form["name"]) > 0) {
		errors.MissingParams(w)
		return
	}

	// Match the id agains regex pattern to ensure it´s valid
	if match, _ := regexp.MatchString(`^\w+$`, r.Form["id"][0]); !match {
		w.Header().Add("Content-Type", "application/json; charset=utf-8")
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte(`{"message":"ID contains invalid characters, refer to the documentation for more information."}`))
		return
	}

	// Insert all the data in the database
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

// GetRoom handles all GET requests to /rooms/<id> and either returns a json structure describing the room or a `Not Found` error, if the room can't be found in the database
func GetRoom(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	var room Room

	err := Database.QueryRow(`SELECT id, name FROM rooms WHERE id=?`, p[0].Value).Scan(&room.ID, &room.Name)

	if err != nil {
		if err != sql.ErrNoRows {
			panic(err)
		} else {
			w.Header().Add("Content-Type", "application/json; charset=utf-8")
			w.WriteHeader(http.StatusNotFound)
			w.Write([]byte(fmt.Sprintf(`{"message":"Room with ID '%s' not found."}`, p[0].Value)))
			return
		}
	}

	rows, err := Database.Query(`SELECT id, name, type, controller, address FROM devices WHERE room_id=?`, p[0].Value)

	defer rows.Close()

	if err != nil {
		panic(err)
	}

	for rows.Next() {
		var d Device

		rows.Scan(&d.ID, &d.Name, &d.Type, &d.Controller, &d.Address)
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

// DeleteRoom handles all DELETE requests to /rooms/<id> and return either a `404 NOT FOUND` if the room does not exist or a 204 response if it's been deleted successfully
func DeleteRoom(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	var id string

	err := Database.QueryRow("SELECT id FROM rooms WHERE id=?", p[0].Value).Scan(&id)

	if err != nil {
		if err != sql.ErrNoRows {
			panic(err)
		} else {
			w.Header().Add("Content-Type", "application/json; charset=utf-8")
			w.WriteHeader(http.StatusNotFound)
			w.Write([]byte(fmt.Sprintf(`{"message":"Room with ID '%s' not found."}`, p[0].Value)))
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
