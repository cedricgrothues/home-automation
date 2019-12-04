package routes

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"net/http"
	"regexp"

	"github.com/cedricgrothues/home-automation/service.device-registry/errors"
	"github.com/cedricgrothues/home-automation/service.device-registry/models"
	"github.com/julienschmidt/httprouter"
)

// AllDevices handles GET requests to /devices and returns a JSON structure describing all devices in the database
func AllDevices(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	params := r.URL.Query()

	rows, err := Database.Query(`SELECT d.id, d.name, d.type, d.controller, d.address, r.id, r.name FROM devices d INNER JOIN rooms r ON d.room_id = r.id AND (length(CAST($1 AS TEXT)) <= 0 OR d.controller=$1)`, params.Get("controller"))

	if err != nil {
		panic(err)
	}

	var devices []models.Device

	for rows.Next() {
		var device models.Device
		room := &models.Room{}

		err = rows.Scan(&device.ID, &device.Name, &device.Type, &device.Controller, &device.Address, &room.ID, &room.Name)

		device.Room = room

		if err != nil {
			panic(err)
		}

		devices = append(devices, device)
	}

	defer rows.Close()

	w.Header().Add("Content-Type", "application/json; charset=utf-8")
	w.WriteHeader(http.StatusOK)

	bytes, err := json.Marshal(devices)

	if err != nil {
		panic("A problem occured while converting JSON: " + err.Error())
	}

	w.Write(bytes)
}

// AddDevice handles POST requests to /devices and returns a JSON structure describing the added device if it's successfully been inserted into the database
func AddDevice(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	device := models.Device{}

	err := json.NewDecoder(r.Body).Decode(&device)

	if err != nil {
		w.Header().Add("Content-Type", "application/json; charset=utf-8")
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte(`{"message":"Bad JSON."}`))
		return
	}

	if !(device.ID != "" && device.Name != "" && device.Type != "" && device.Controller != "" && device.RoomID != "" && device.Address != "") {
		errors.MissingParams(w)
		return
	}

	if match, _ := regexp.MatchString(`^[a-z-_]+$`, device.ID); !match {
		w.Header().Add("Content-Type", "application/json; charset=utf-8")
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte(`{"message":"ID contains invalid characters, refer to the documentation for more information."}`))
		return
	}

	if match, _ := regexp.MatchString(`^(?:(?:^|\.)(?:2(?:5[0-5]|[0-4]\d)|1?\d?\d)){4}$`, device.Address); !match {
		w.Header().Add("Content-Type", "application/json; charset=utf-8")
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte(`{"message":"Invalid IPv4 address format, refer to the documentation for more information."}`))
		return
	}

	var id string
	err = Database.QueryRow("SELECT id FROM rooms WHERE id=$1", device.RoomID).Scan(&id)

	if err != nil {
		if err != sql.ErrNoRows {
			panic(err)
		} else {
			w.Header().Add("Content-Type", "application/json; charset=utf-8")
			w.WriteHeader(http.StatusNotFound)
			w.Write([]byte(fmt.Sprintf(`{"message":"Room with ID '%s' not found."}`, device.RoomID)))
			return
		}
	}

	stmt, err := Database.Prepare("INSERT INTO devices(id, name, type, controller, address, room_id) values($1,$2,$3,$4,$5,$6)")
	defer stmt.Close()

	if err != nil {
		panic(err)
	}

	_, err = stmt.Exec(device.ID, device.Name, device.Type, device.Controller, device.Address, device.RoomID)

	if err != nil {
		panic("A problem occured while inserting object into database: " + err.Error())
	}

	var room models.Room

	err = Database.QueryRow("SELECT d.id, d.name, d.type, d.controller, d.address, r.id, r.name FROM devices d INNER JOIN rooms r ON d.room_id = r.id AND d.id=$1", device.ID).Scan(&device.ID, &device.Name, &device.Type, &device.Controller, &device.Address, &room.ID, &room.Name)

	device.Room = &room
	device.RoomID = ""

	w.Header().Add("Content-Type", "application/json; charset=utf-8")
	w.WriteHeader(http.StatusCreated)

	bytes, err := json.Marshal(device)

	if err != nil {
		panic("A problem occured while converting JSON: " + err.Error())
	}

	w.Write(bytes)
}

// GetDevice handles GET requests to /devices/<id> and returns a JSON structure describing the requested device if it was found, else it returns a `404 NOT FOUND` error
func GetDevice(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	params := r.URL.Query()

	var device models.Device
	room := &models.Room{}

	err := Database.QueryRow(`SELECT d.id, d.name, d.type, d.controller, d.address, r.id, r.name FROM devices d INNER JOIN rooms r ON d.room_id = r.id AND d.id=$1 AND (length(CAST($2 AS TEXT)) <= 0 OR d.controller=$2)`, p[0].Value, params.Get("controller")).Scan(&device.ID, &device.Name, &device.Type, &device.Controller, &device.Address, &room.ID, &room.Name)

	if err != nil {
		if err != sql.ErrNoRows {
			panic(err)
		} else {
			w.Header().Add("Content-Type", "application/json; charset=utf-8")
			w.WriteHeader(http.StatusNotFound)
			w.Write([]byte(fmt.Sprintf(`{"message":"Device with ID '%s' not found."}`, p[0].Value)))
			return
		}
	}

	device.Room = room

	w.Header().Add("Content-Type", "application/json; charset=utf-8")
	w.WriteHeader(http.StatusOK)

	bytes, err := json.Marshal(device)

	if err != nil {
		panic("A problem occured while converting JSON: " + err.Error())
	}

	w.Write(bytes)
}

// DeleteDevice handles DELETE requests to /devices/<id> and returns a `204 NO CONTENT` response if it was removed successfully, else it returns a `404 NOT FOUND` error
func DeleteDevice(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	var id string

	err := Database.QueryRow("SELECT id FROM devices WHERE id=$1", p[0].Value).Scan(&id)

	if err != nil {
		if err != sql.ErrNoRows {
			panic(err)
		} else {
			w.Header().Add("Content-Type", "application/json; charset=utf-8")
			w.WriteHeader(http.StatusNotFound)
			w.Write([]byte(fmt.Sprintf(`{"message":"Device with ID '%s' not found."}`, p[0].Value)))
			return
		}
	}

	statement, err := Database.Prepare("DELETE FROM devices WHERE id=$1")
	_, err = statement.Exec(p[0].Value)

	defer statement.Close()

	if err != nil {
		panic(err)
	}

	w.WriteHeader(http.StatusNoContent)
}
