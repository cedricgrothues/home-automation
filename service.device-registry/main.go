package main

import (
	"database/sql"
	"log"
	"net/http"

	"github.com/cedricgrothues/home-automation/libraries/go/errors"
	"github.com/cedricgrothues/home-automation/service.device-registry/routes"
	"github.com/julienschmidt/httprouter"
	_ "github.com/mattn/go-sqlite3"
)

func main() {

	database, err := sql.Open("sqlite3", "./database/device-registry.sqlite")

	if err != nil {
		log.Fatal(err)
	}

	defer database.Close()

	database.Exec(`CREATE TABLE IF NOT EXISTS devices (id TEXT PRIMARY KEY, name TEXT NOT NULL, type TEXT NOT NULL, controller TEXT NOT NULL, address TEXT NOT NULL, room_id TEXT NOT NULL, FOREIGN KEY (room_id) REFERENCES rooms (id) ON UPDATE CASCADE ON DELETE SET NULL);`)
	database.Exec("CREATE TABLE IF NOT EXISTS rooms (id TEXT PRIMARY KEY, name TEXT NOT NULL, FOREIGN KEY (id) REFERENCES devices (room_id) ON UPDATE CASCADE ON DELETE SET NULL);")

	routes.Database = database

	router := httprouter.New()
	router.NotFound = http.HandlerFunc(errors.NotFound)
	router.MethodNotAllowed = http.HandlerFunc(errors.NotAllowed)
	router.PanicHandler = errors.PanicHandler

	router.GET("/devices", routes.AllDevices)
	router.POST("/devices", routes.AddDevice)

	router.GET("/devices/:id", routes.GetDevice)
	router.DELETE("/devices/:id", routes.DeleteDevice)

	router.GET("/rooms", routes.AllRooms)
	router.POST("/rooms", routes.AddRoom)

	router.GET("/rooms/:id", routes.GetRoom)
	router.DELETE("/rooms/:id", routes.DeleteRoom)

	errors.Log("service.device-registry", "Failed to start with error:", http.ListenAndServe(":4000", router))
}
