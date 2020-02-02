package main

import (
	"database/sql"
	"fmt"
	"log"

	"github.com/cedricgrothues/home-automation/core/user-registry/handler"
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

	database, err := sql.Open("postgres", fmt.Sprintf("host=%s port=%d user=%s password=%s dbname=%s sslmode=disable", host, port, user, password, dbname))

	if err != nil {
		log.Fatal(err)
	}

	defer database.Close()

	handler.Database = database

	router, err := bootstrap.New("core.user")

	if err != nil {
		panic(err)
	}

	router.GET("/users", handler.ListUsers)
	router.POST("/users", handler.AddUser)

	router.DELETE("/users/:id", handler.RemoveUser)

	panic(bootstrap.Start(router, 4002))
}
