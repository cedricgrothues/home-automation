package main

import (
	"database/sql"
	"fmt"
	"log"
	"net/http"

	"github.com/cedricgrothues/home-automation/service.device-registry/routes"
	"github.com/julienschmidt/httprouter"
	_ "github.com/mattn/go-sqlite3"
)

func main() {

	database, err := sql.Open("sqlite3", "./database/device-registry.db")

	if err != nil {
		log.Fatal(err)
	}

	defer database.Close()

	database.Exec(`CREATE TABLE IF NOT EXISTS devices (id TEXT PRIMARY KEY, name TEXT NOT NULL, type TEXT NOT NULL, controller TEXT NOT NULL, room_id TEXT NOT NULL, FOREIGN KEY (room_id) REFERENCES rooms (id) ON UPDATE CASCADE ON DELETE CASCADE);`)
	database.Exec("CREATE TABLE IF NOT EXISTS rooms (id TEXT PRIMARY KEY, name TEXT NOT NULL);")

	routes.Database = database

	router := httprouter.New()
	router.HandleMethodNotAllowed = true
	router.NotFound = http.HandlerFunc(NotFound)
	router.MethodNotAllowed = http.HandlerFunc(NotAllowed)
	router.PanicHandler = PanicHandler

	router.GET("/devices", routes.AllDevices)
	router.POST("/devices", routes.AddDevice)

	router.GET("/devices/:device", routes.GetDevice)
	router.DELETE("/devices/:device", routes.DeleteDevice)

	router.GET("/rooms", routes.AllRooms)
	router.POST("/rooms", routes.AddRoom)

	router.GET("/rooms/:room", routes.GetRoom)
	router.DELETE("/rooms/:room", routes.DeleteRoom)

	log.Fatalf("\n\x1b[31m[%v]\x1b[0m %s %v", "service.device-registry", "Failed to start with error:", http.ListenAndServe(":4000", router))
}

// NotFound handles errors if a route was not found
func NotFound(w http.ResponseWriter, r *http.Request) {
	w.Header().Add("Content-Type", "application/json; charset=utf-8")
	w.WriteHeader(http.StatusNotFound)
	w.Write([]byte(`{"message":"Page ` + r.URL.Path + ` not found"}`))
}

// NotAllowed handles errors if a method is not allowed
func NotAllowed(w http.ResponseWriter, r *http.Request) {
	w.Header().Add("Content-Type", "application/json; charset=utf-8")
	w.WriteHeader(http.StatusMethodNotAllowed)
	w.Write([]byte(`{"message":"Method ` + r.Method + ` not allowed"}`))
}

// PanicHandler handles internal server errors
func PanicHandler(w http.ResponseWriter, r *http.Request, p interface{}) {
	fmt.Print(p)
	w.Header().Add("Content-Type", "application/json; charset=utf-8")
	w.WriteHeader(http.StatusInternalServerError)
	w.Write([]byte(`{"message":"Internal server error"}`))
}

// HandleError logs and handles the passed error
func HandleError(e error) {
	if e != nil {
		log.Fatalf("\n\x1b[31m[%v]\x1b[0m %s %v", "service.device-registry", "An error occured:", e.Error())
	}
}
