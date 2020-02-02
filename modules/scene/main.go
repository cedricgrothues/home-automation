package main

import (
	"database/sql"
	"fmt"
	"log"

	"github.com/cedricgrothues/home-automation/libraries/go/bootstrap"
	"github.com/cedricgrothues/home-automation/modules/scene/handler"
	_ "github.com/lib/pq"
)

const (
	host     = "core.persistence.database"
	port     = 5432
	user     = "postgres"
	password = "zuhkiz-2honwu-semhoV"
	dbname   = "core.persistence.database"
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

	router.GET("/scenes", handler.ListScenes)
	router.POST("/scenes", handler.CreateScene)

	router.GET("/scenes/:id", handler.ReadScene)
	router.DELETE("/scenes/:id", handler.DeleteScene)

	router.GET("/scenes/:id/run", handler.ExecScene)

	panic(bootstrap.Start(router, 4006))
}
