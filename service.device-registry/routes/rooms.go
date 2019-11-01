package routes

import (
	"database/sql"
	"encoding/json"
	"log"
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
	Devices []device `json:"devices"`
}

type device struct {
	ID         string `json:"id"`
	Name       string `json:"name"`
	Type       string `json:"type"`
	Controller string `json:"controller"`
}

// AllRooms handles GET /rooms and returns a 200 status code with all rooms and their according devices
func AllRooms(w http.ResponseWriter, r *http.Request, p httprouter.Params) {

	rows, err := Database.Query("SELECT * FROM rooms")

	if err != nil {
		log.Fatal(err)
	}

	defer rows.Close()

	var rooms []Room

	for rows.Next() {
		var id string
		var name string
		var devices []device

		err = rows.Scan(&id, &name)

		if err != nil {
			log.Fatal(err)
		}

		rows, err = Database.Query("SELECT id, name, type, controller FROM devices WHERE room_id=?", id)

		defer rows.Close()

		for rows.Next() {
			var device device
			err = rows.Scan(&device.ID, &device.Name, &device.Type, &device.Controller)

			if err != nil {
				log.Fatal(err)
			}

			devices = append(devices, device)
		}

		err = rows.Err()
		if err != nil {
			log.Fatal(err)
		}

		rooms = append(rooms, Room{id, name, devices})
	}

	err = rows.Err()
	if err != nil {
		log.Fatal(err)
	}

	w.Header().Add("Content-Type", "application/json; charset=utf-8")
	w.WriteHeader(http.StatusOK)

	bytes, err := json.Marshal(rooms)

	if err != nil {
		log.Fatal("A problem occured while converting JSON: " + err.Error())
	}

	w.Write(bytes)
}

// AddRoom Adds a device
func AddRoom(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	r.ParseForm()

	if !(len(r.Form["id"]) > 0 && len(r.Form["name"]) > 0) {
		w.Header().Add("Content-Type", "application/json; charset=utf-8")
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte(`{"message":"Missing parameter(s), refer to the documentation for more information."}`))
		return
	}

	if match, _ := regexp.MatchString(`^\w+$`, r.Form["id"][0]); !match {
		w.Header().Add("Content-Type", "application/json; charset=utf-8")
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte(`{"message":"ID contains invalid characters, refer to the documentation for more information."}`))
		return
	}

	rows, err := Database.Query("SELECT id FROM rooms WHERE id=?", r.Form["id"][0])

	if rows.Next() {
		w.Header().Add("Content-Type", "application/json; charset=utf-8")
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte(`{"message":"A room with this ID already exists."}`))
		return
	}

	defer rows.Close()

	_, err = Database.Exec("INSERT INTO rooms(id, name) values(?,?)", r.Form["id"][0], r.Form["name"][0])

	if err != nil {
		panic(err)
	}

	var room Room

	Database.QueryRow(`SELECT r.id, r.name, GROUP_CONCAT(d.id, d.name, device.type, device.controller) FROM rooms r INNER JOIN devices d ON d.room_id = r.id WHERE r.id=?`, r.Form["id"][0]).Scan(&room.ID, &room.Name, &room.Devices)

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

	rows, err := Database.Query("SELECT id, name FROM rooms WHERE id=?", p[0].Value)
	defer rows.Close()

	if err != nil {
		log.Fatal(err)
	}

	room := Room{}

	if rows.Next() {
		err = rows.Scan(&room.ID, &room.Name)

		rows, err := Database.Query("SELECT id, name, type, controller FROM devices WHERE room_id=?", room.ID)
		defer rows.Close()

		if err != nil {
			log.Fatal(err)
		}

		for rows.Next() {
			var (
				id         string
				name       string
				dtype      string
				controller string
			)
			err = rows.Scan(&id, &name, &dtype, &controller)

			if err != nil {
				log.Fatal(err)
			}

			room.Devices = append(room.Devices, device{id, name, dtype, controller})
		}

	} else {
		w.Header().Add("Content-Type", "application/json; charset=utf-8")
		w.WriteHeader(http.StatusNotFound)
		w.Write([]byte(`{"message":"Room with ID '` + p[0].Value + `' not found."}`))
		return
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

	rows, err := Database.Query("SELECT id, name FROM rooms WHERE id=?", p[0].Value)

	if err != nil {
		panic(err)
	}

	defer rows.Close()

	if !rows.Next() {
		w.Header().Add("Content-Type", "application/json; charset=utf-8")
		w.WriteHeader(http.StatusNotFound)
		w.Write([]byte(`{"message":"Room with ID '` + p[0].Value + `' not found."}`))
		return
	}

	_, err = Database.Exec("DELETE FROM rooms WHERE id=?", p[0].Value)

	if err != nil {
		panic(err)
	}

	w.WriteHeader(http.StatusNoContent)
}
