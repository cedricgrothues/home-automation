package main

import (
	"database/sql"
	"fmt"
	"log"
	"net/http"

	"github.com/cedricgrothues/home-automation/core/device-registry/routes"
	"github.com/cedricgrothues/home-automation/libraries/go/bootstrap"
	_ "github.com/lib/pq"
)

const (
	host     = "core.persistence"
	port     = 5432
	user     = "postgres"
	password = "zuhkiz-2honwu-semhoV"
	dbname   = "core.persistence"
)

func main() {
	var database *sql.DB

	database, err := sql.Open("postgres", fmt.Sprintf("host=%s port=%d user=%s password=%s dbname=%s sslmode=disable", host, port, user, password, dbname))

	if err != nil {
		log.Fatal(err)
	}

	defer database.Close()

	routes.Database = database

	router, err := bootstrap.New("core.device-registry")

	if err != nil {
		panic(err)
	}

	router.HandleFunc("/devices", routes.AllDevices).Methods(http.MethodGet)
	router.HandleFunc("/devices", routes.AddDevice).Methods(http.MethodPost)

	router.HandleFunc("/devices/{id}", routes.GetDevice).Methods(http.MethodGet)
	router.HandleFunc("/devices/{id}", routes.DeleteDevice).Methods(http.MethodDelete)

	router.HandleFunc("/rooms", routes.AllRooms).Methods(http.MethodGet)
	router.HandleFunc("/rooms", routes.AddRoom).Methods(http.MethodPost)

	router.HandleFunc("/rooms/{id}", routes.GetRoom).Methods(http.MethodGet)
	router.HandleFunc("/rooms/{id}", routes.DeleteRoom).Methods(http.MethodDelete)

	panic(bootstrap.Start(router, 4001))
}
