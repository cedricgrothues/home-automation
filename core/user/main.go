package main

import (
	"database/sql"
	"fmt"
	"log"
	"net/http"

	"github.com/cedricgrothues/home-automation/core/user/handler"
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

	router.HandleFunc("/users", handler.ListUsers).Methods(http.MethodGet)
	router.HandleFunc("/users", handler.AddUser).Methods(http.MethodPost)

	router.HandleFunc("/users/{id}", handler.RemoveUser).Methods(http.MethodDelete)

	panic(bootstrap.Start(router, 4002))
}
