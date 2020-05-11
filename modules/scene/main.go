package main

import (
	"database/sql"
	"fmt"
	"log"
	"net/http"

	"github.com/cedricgrothues/home-automation/libraries/go/bootstrap"
	"github.com/cedricgrothues/home-automation/modules/scene/handler"
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

	handler.Database = database

	router, err := bootstrap.New("modules.scene")

	if err != nil {
		panic(err)
	}

	router.HandleFunc("/scenes", handler.ListScenes).Methods(http.MethodGet)
	router.HandleFunc("/scenes", handler.CreateScene).Methods(http.MethodPost)

	router.HandleFunc("/scenes/{id}", handler.ReadScene).Methods(http.MethodGet)
	router.HandleFunc("/scenes/{id}", handler.DeleteScene).Methods(http.MethodDelete)

	router.HandleFunc("/scenes/{id}/run", handler.ExecScene).Methods(http.MethodGet)

	panic(bootstrap.Start(router, 4006))
}
