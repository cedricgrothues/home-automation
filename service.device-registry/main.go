package main

import (
	"database/sql"
	"fmt"
	"log"
	"net/http"

	"github.com/cedricgrothues/home-automation/libraries/go/errors"
	"github.com/cedricgrothues/home-automation/service.device-registry/routes"
	"github.com/julienschmidt/httprouter"
	_ "github.com/lib/pq"
)

const (
	host     = "localhost"
	port     = 54320
	user     = "postgres"
	password = "zuhkiz-2honwu-semhoV"
	dbname   = "service.device-registry.database"
)

func main() {

	database, err := sql.Open("postgres", fmt.Sprintf("host=%s port=%d user=%s password=%s dbname=%s sslmode=disable", host, port, user, password, dbname))

	if err != nil {
		log.Fatal(err)
	}

	defer database.Close()

	database.Exec("CREATE TABLE IF NOT EXISTS rooms (id varchar(20) PRIMARY KEY, name text NOT NULL);")
	database.Exec(`CREATE TABLE IF NOT EXISTS devices (id varchar(20) PRIMARY KEY, name text NOT NULL, type text NOT NULL, controller text NOT NULL, address text NOT NULL, room_id text NOT NULL, FOREIGN KEY (room_id) REFERENCES rooms (id) ON UPDATE CASCADE ON DELETE SET NULL);`)

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
