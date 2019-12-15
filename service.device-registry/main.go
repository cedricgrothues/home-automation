package main

import (
	"database/sql"
	"fmt"
	"log"

	"github.com/cedricgrothues/home-automation/libraries/go/bootstrap"
	"github.com/cedricgrothues/home-automation/service.device-registry/routes"
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

	router, err := bootstrap.New("service.device-registry")

	if err != nil {
		panic(err)
	}

	router.GET("/devices", routes.AllDevices)
	router.POST("/devices", routes.AddDevice)

	router.GET("/devices/:id", routes.GetDevice)
	router.DELETE("/devices/:id", routes.DeleteDevice)

	router.GET("/rooms", routes.AllRooms)
	router.POST("/rooms", routes.AddRoom)

	router.GET("/rooms/:id", routes.GetRoom)
	router.DELETE("/rooms/:id", routes.DeleteRoom)

	panic(bootstrap.Start(router, 4001))
}
