package routes

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"regexp"

	"github.com/julienschmidt/httprouter"
)

// Device : instance of a device
type Device struct {
	ID         string `json:"id"`
	Name       string `json:"name"`
	Type       string `json:"type"`
	Controller string `json:"controller"`
	Room       room   `json:"room"`
}

type room struct {
	ID   string `json:"id"`
	Name string `json:"name"`
}

// AllDevices Lists all devices
func AllDevices(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	rows, err := Database.Query("SELECT d.id, d.name, d.type, d.controller, r.id, r.name FROM devices d INNER JOIN rooms r ON d.room_id = r.id")

	if err != nil {
		panic(err)
	}

	var devices []Device

	for rows.Next() {
		var ID string
		var Name string
		var Type string
		var Controller string

		var room room

		err = rows.Scan(&ID, &Name, &Type, &Controller, &room.ID, &room.Name)
		devices = append(devices, Device{ID, Name, Type, Controller, room})
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

	if !(len(r.Form["id"]) > 0 && len(r.Form["name"]) > 0 && len(r.Form["type"]) > 0 && len(r.Form["controller"]) > 0 && len(r.Form["room_id"]) > 0) {
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

	stmt, err := Database.Prepare("INSERT INTO devices(id, name, type, controller, room_id) values(?,?,?,?,?)")

	if err != nil {
		panic(err)
	}

	res, err := stmt.Exec(r.Form["id"][0], r.Form["name"][0], r.Form["type"][0], r.Form["controller"][0], r.Form["room_id"][0])

	if err != nil {
		panic("A problem occured while inserting object into database: " + err.Error())
	}

	fmt.Println(res)

	rows, err := Database.Query("SELECT d.id, d.name, d.type, d.controller, r.id, r.name FROM devices d INNER JOIN rooms r ON d.room_id = r.id WHERE d.id=?", r.Form["id"][0])

	device := Device{}

	if rows.Next() {
		err = rows.Scan(&device.ID, &device.Name, &device.Type, &device.Controller, &device.Room.ID, &device.Room.Name)
	}

	defer rows.Close()

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
	rows, err := Database.Query("SELECT d.id, d.name, d.type, d.controller, r.id, r.name FROM devices d INNER JOIN rooms r ON d.room_id = r.id WHERE d.id=?", p[0].Value)

	if err != nil {
		panic(err)
	}

	device := Device{}

	if rows.Next() {
		err = rows.Scan(&device.ID, &device.Name, &device.Type, &device.Controller, &device.Room.ID, &device.Room.Name)
	} else {
		w.Header().Add("Content-Type", "application/json; charset=utf-8")
		w.WriteHeader(http.StatusNotFound)
		w.Write([]byte(`{"message":"Device with ID '` + p[0].Value + `' not found."}`))
		return
	}

	defer rows.Close()

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
	rows, err := Database.Query("SELECT id FROM devices WHERE id=?", p[0].Value)

	if err != nil {
		log.Fatal(err)
	}

	defer rows.Close()

	if !rows.Next() {
		w.Header().Add("Content-Type", "application/json; charset=utf-8")
		w.WriteHeader(http.StatusNotFound)
		w.Write([]byte(`{"message":"Device with ID '` + p[0].Value + `' not found."}`))
		return
	}

	_, err = Database.Exec("DELETE FROM devices WHERE id=?", p[0].Value)

	if err != nil {
		log.Fatal(err)
	}

	w.WriteHeader(http.StatusNoContent)
}
