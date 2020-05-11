package routes

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"net/http"
	"regexp"

	"github.com/cedricgrothues/home-automation/core/device-registry/models"
	"github.com/cedricgrothues/home-automation/libraries/go/errors"
	"github.com/gorilla/mux"
)

// Database defines a new shared postgres instance, that is defined in main package's main() method
var Database *sql.DB

// AllRooms handles all GET /rooms and handles them accordingly
func AllRooms(w http.ResponseWriter, r *http.Request) {

	var rooms []models.Room

	rows, err := Database.Query(`SELECT id, name FROM rooms`)

	defer rows.Close()

	if err != nil {
		panic(err)
	}

	for rows.Next() {
		var room models.Room

		rows.Scan(&room.ID, &room.Name)

		deviceRows, err := Database.Query(`SELECT id, name, type, controller, address, token FROM devices WHERE room_id=$1`, room.ID)

		defer deviceRows.Close()

		if err != nil {
			panic(err)
		}

		for deviceRows.Next() {
			var d models.Device

			deviceRows.Scan(&d.ID, &d.Name, &d.Type, &d.Controller, &d.Address, &d.Token)
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
func AddRoom(w http.ResponseWriter, r *http.Request) {
	params := models.Room{}

	err := json.NewDecoder(r.Body).Decode(&params)

	// Check if all params are present, if not abort with 400 error
	if !(params.ID != "" && params.Name != "") {
		errors.MissingParams(w)
		return
	}

	// Match the id agains regex pattern to ensure it´s valid
	if match, _ := regexp.MatchString(`^[a-z-_]+$`, params.ID); !match {
		w.Header().Add("Content-Type", "application/json; charset=utf-8")
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte(`{"message":"ID contains invalid characters, refer to the documentation for more information."}`))
		return
	}

	var room models.Room

	// Insert all the data in the database
	err = Database.QueryRow("INSERT INTO rooms(id, name) values($1,$2) RETURNING id, name", params.ID, params.Name).Scan(&room.ID, &room.Name)

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
func GetRoom(w http.ResponseWriter, r *http.Request) {
	var room models.Room
	vars := mux.Vars(r)

	err := Database.QueryRow(`SELECT id, name FROM rooms WHERE id=$1`, vars["id"]).Scan(&room.ID, &room.Name)

	if err != nil {
		if err != sql.ErrNoRows {
			panic(err)
		} else {
			w.Header().Add("Content-Type", "application/json; charset=utf-8")
			w.WriteHeader(http.StatusNotFound)
			w.Write([]byte(fmt.Sprintf(`{"message":"Room with ID '%s' not found."}`, vars["id"])))
			return
		}
	}

	rows, err := Database.Query(`SELECT id, name, type, controller, address, token FROM devices WHERE room_id=$1`, vars["id"])

	defer rows.Close()

	if err != nil {
		panic(err)
	}

	for rows.Next() {
		var d models.Device

		rows.Scan(&d.ID, &d.Name, &d.Type, &d.Controller, &d.Address, &d.Token)
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
func DeleteRoom(w http.ResponseWriter, r *http.Request) {
	var id string
	vars := mux.Vars(r)

	err := Database.QueryRow("SELECT id FROM rooms WHERE id=$1", vars["id"]).Scan(&id)

	if err != nil {
		if err != sql.ErrNoRows {
			panic(err)
		} else {
			w.Header().Add("Content-Type", "application/json; charset=utf-8")
			w.WriteHeader(http.StatusNotFound)
			w.Write([]byte(fmt.Sprintf(`{"message":"Room with ID '%s' not found."}`, vars["id"])))
			return
		}
	}

	statement, err := Database.Prepare("DELETE FROM devices WHERE room_id=$1")
	_, err = statement.Exec(vars["id"])

	defer statement.Close()

	if err != nil {
		panic(err)
	}

	statement, err = Database.Prepare("DELETE FROM rooms WHERE id=$1")
	_, err = statement.Exec(vars["id"])

	defer statement.Close()

	if err != nil {
		panic(err)
	}

	w.WriteHeader(http.StatusNoContent)
}
