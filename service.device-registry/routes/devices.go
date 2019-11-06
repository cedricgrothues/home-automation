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

// Device : instance of a device
type Device struct {
	ID         string `json:"id"`
	Name       string `json:"name"`
	Type       string `json:"type"`
	Controller string `json:"controller"`
	Address    string `json:"address"`
	Room       *Room  `json:"room,omitempty"`
}

// AllDevices Lists all devices
func AllDevices(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	params := r.URL.Query()

	rows, err := Database.Query("SELECT d.id, d.name, d.type, d.controller, d.address, r.id, r.name FROM devices d INNER JOIN rooms r ON d.room_id = r.id AND ($1 IS '' OR d.controller=$1)", params.Get("controller"))

	if err != nil {
		panic(err)
	}

	var devices []Device

	for rows.Next() {
		var device Device
		room := &Room{}

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

// AddDevice Adds a device
func AddDevice(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	r.ParseForm()

	if !(len(r.Form["id"]) > 0 && len(r.Form["name"]) > 0 && len(r.Form["type"]) > 0 && len(r.Form["controller"]) > 0 && len(r.Form["room_id"]) > 0 && len(r.Form["address"]) > 0) {
		errors.MissingParams(w)
		return
	}

	if match, _ := regexp.MatchString(`^\w+$`, r.Form["id"][0]); !match {
		w.Header().Add("Content-Type", "application/json; charset=utf-8")
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte(`{"message":"ID contains invalid characters, refer to the documentation for more information."}`))
		return
	}

	if match, _ := regexp.MatchString(`^(?:(?:^|\.)(?:2(?:5[0-5]|[0-4]\d)|1?\d?\d)){4}$`, r.Form["address"][0]); !match {
		w.Header().Add("Content-Type", "application/json; charset=utf-8")
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte(`{"message":"Invalid IPv4 address format, refer to the documentation for more information."}`))
		return
	}

	var id string
	err := Database.QueryRow("SELECT id FROM rooms WHERE id=?", r.Form["room_id"][0]).Scan(&id)

	if err != nil {
		if err != sql.ErrNoRows {
			panic(err)
		} else {
			w.Header().Add("Content-Type", "application/json; charset=utf-8")
			w.WriteHeader(http.StatusNotFound)
			w.Write([]byte(fmt.Sprintf(`{"message":"Room with ID '%s' not found."}`, r.Form["room_id"][0])))
			return
		}
	}

	stmt, err := Database.Prepare("INSERT INTO devices(id, name, type, controller, address, room_id) values(?,?,?,?,?,?)")
	defer stmt.Close()

	if err != nil {
		panic(err)
	}

	_, err = stmt.Exec(r.Form["id"][0], r.Form["name"][0], r.Form["type"][0], r.Form["controller"][0], r.Form["address"][0], r.Form["room_id"][0])

	if err != nil {
		panic("A problem occured while inserting object into database: " + err.Error())
	}

	var device Device
	room := &Room{}

	err = Database.QueryRow("SELECT d.id, d.name, d.type, d.controller, d.address, r.id, r.name FROM devices d INNER JOIN rooms r ON d.room_id = r.id AND d.id=?", r.Form["id"][0]).Scan(&device.ID, &device.Name, &device.Type, &device.Controller, &device.Address, &room.ID, &room.Name)

	device.Room = room

	w.Header().Add("Content-Type", "application/json; charset=utf-8")
	w.WriteHeader(http.StatusCreated)

	bytes, err := json.Marshal(device)

	if err != nil {
		panic("A problem occured while converting JSON: " + err.Error())
	}

	w.Write(bytes)
}

// GetDevice Gets a specific device
func GetDevice(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	params := r.URL.Query()

	var device Device
	room := &Room{}

	err := Database.QueryRow("SELECT d.id, d.name, d.type, d.controller, d.address, r.id, r.name FROM devices d INNER JOIN rooms r ON d.room_id = r.id AND d.id=$1 AND ($2 IS '' OR d.controller=$2)", p[0].Value, params.Get("controller")).Scan(&device.ID, &device.Name, &device.Type, &device.Controller, &device.Address, &room.ID, &room.Name)

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

// DeleteDevice deletes a specified device
func DeleteDevice(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	var id string

	err := Database.QueryRow("SELECT id FROM devices WHERE id=?", p[0].Value).Scan(&id)

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

	statement, err := Database.Prepare("DELETE FROM devices WHERE id=?")
	_, err = statement.Exec(p[0].Value)

	defer statement.Close()

	if err != nil {
		panic(err)
	}

	w.WriteHeader(http.StatusNoContent)
}
