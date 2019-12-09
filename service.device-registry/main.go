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
	host     = "service.device-registry.database"
	port     = 5432
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

	router := httprouter.New()

	router.GET("/", func(w http.ResponseWriter, r *http.Request, params httprouter.Params) {
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
