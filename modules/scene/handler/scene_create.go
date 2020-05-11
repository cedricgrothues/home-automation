package handler

import (
	"database/sql"
	"encoding/json"
	"net/http"
	"reflect"
	"regexp"

	"github.com/cedricgrothues/home-automation/libraries/go/errors"
	"github.com/cedricgrothues/home-automation/modules/scene/domain"
)

// Database is a passed on database instance
var Database *sql.DB

// CreateScene add a new Scene to the database
func CreateScene(w http.ResponseWriter, r *http.Request) {
	scene := domain.Scene{}

	err := json.NewDecoder(r.Body).Decode(&scene)

	if err != nil {
		w.Header().Add("Content-Type", "application/json; charset=utf-8")
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte(`{"message":"Bad JSON."}`))
		return
	}

	if err := scene.Validate(); err != nil {
		errors.MissingParams(w)
		return
	}

	if match, _ := regexp.MatchString(`^[a-z-_]+$`, scene.ID); !match {
		w.Header().Add("Content-Type", "application/json; charset=utf-8")
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte(`{"message":"ID contains invalid characters, refer to the documentation for more information."}`))
		return
	}

	// Insert all the data in the database
	stmnt, err := Database.Prepare("INSERT INTO scenes(id, name, owner) values($1,$2,$3) RETURNING id, name, owner")
	defer stmnt.Close()

	if err != nil {
		panic(err)
	}

	_, err = stmnt.Exec(scene.ID, scene.Name, scene.Owner)

	if err != nil {
		panic(err)
	}

	for _, action := range scene.Actions {
		stmt, err := Database.Prepare("INSERT INTO actions(controller, device, property, value, type, scene_id) values($1,$2,$3,$4,$5,$6)")

		defer stmt.Close()

		if err != nil {
			panic(err)
		}

		_, err = stmt.Exec(action.Controller, action.Device, action.Property.Name, action.Property.Value, reflect.TypeOf(action.Property.Value).String(), scene.ID)

		if err != nil {
			panic("A problem occured while inserting object into database: " + err.Error())
		}
	}

	w.Header().Add("Content-Type", "application/json; charset=utf-8")
	w.WriteHeader(http.StatusCreated)

	bytes, err := json.Marshal(&scene)

	if err != nil {
		panic("A problem occured while converting JSON: " + err.Error())
	}

	w.Write(bytes)
}
