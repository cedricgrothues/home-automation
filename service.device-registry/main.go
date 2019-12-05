package main

import (
	"database/sql"
	"fmt"
	"log"
	"net/http"

	"github.com/cedricgrothues/home-automation/service.device-registry/routes"
	"github.com/cedricgrothues/httprouter"
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
	var database *sql.DB

	database, err := sql.Open("postgres", fmt.Sprintf("host=%s port=%d user=%s password=%s dbname=%s sslmode=disable", host, port, user, password, dbname))

	if err != nil {
		log.Fatal(err)
	}

	defer database.Close()

	routes.Database = database

	database.Exec("CREATE TABLE IF NOT EXISTS rooms (id varchar(20) PRIMARY KEY, name text NOT NULL);")
	database.Exec("CREATE TABLE IF NOT EXISTS devices (id varchar(20) PRIMARY KEY, name text NOT NULL, type text NOT NULL, controller text NOT NULL REFERENCES controllers (id), address text NOT NULL, room_id text NOT NULL, FOREIGN KEY (room_id) REFERENCES rooms (id) ON UPDATE CASCADE ON DELETE SET NULL);")

	router := httprouter.New()

	router.GET("/",func(w http.ResponseWriter, r *http.Request, params httprouter.Params) {
		w.Header().Add("Content-Type", "application/json; charset=utf-8")
		w.WriteHeader(http.StatusOK)
		w.Write([]byte(`{"name":"service.device-registry"}`))
	})

	router.GET("/devices", routes.AllDevices)
	router.POST("/devices", routes.AddDevice)

	router.GET("/devices/:id", routes.GetDevice)
	router.DELETE("/devices/:id", routes.DeleteDevice)

	router.GET("/rooms", routes.AllRooms)
	router.POST("/rooms", routes.AddRoom)

	router.GET("/rooms/:id", routes.GetRoom)
	router.DELETE("/rooms/:id", routes.DeleteRoom)

	panic(http.ListenAndServe(":4001", router))
}
