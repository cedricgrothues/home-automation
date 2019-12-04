package routes

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"net/http"
	"regexp"

	"github.com/cedricgrothues/home-automation/service.device-registry/models"
	"github.com/cedricgrothues/home-automation/service.device-registry/errors"
	"github.com/julienschmidt/httprouter"
)

// AllControllers handles GET requests to /controllers and returns a JSON structure describing all controllers in the database
func AllControllers(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	rows, err := Database.Query(`SELECT * FROM controllers`)

	if err != nil {
		panic(err)
	}

	var controllers []models.Controller

	for rows.Next() {
		var controller models.Controller

		err = rows.Scan(&controller.ID, &controller.Address, &controller.Port)

		if err != nil {
			panic(err)
		}

		controllers = append(controllers, controller)
	}

	defer rows.Close()

	w.Header().Add("Content-Type", "application/json; charset=utf-8")
	w.WriteHeader(http.StatusOK)

	bytes, err := json.Marshal(controllers)

	if err != nil {
		panic("A problem occured while converting JSON: " + err.Error())
	}

	w.Write(bytes)
}

// GetControllers handles GET requests to /controllers/:id and returns a JSON structure describing the controller
func GetControllers(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	controller := models.Controller{}

	err := Database.QueryRow("SELECT * FROM controllers WHERE id=$1", p[0].Value).Scan(&controller.ID, &controller.Address, &controller.Port)

	if err != nil {
		if err != sql.ErrNoRows {
			panic(err)
		} else {
			w.Header().Add("Content-Type", "application/json; charset=utf-8")
			w.WriteHeader(http.StatusNotFound)
			w.Write([]byte(fmt.Sprintf(`{"message":"Controller with ID '%s' not found."}`, p[0].Value)))
			return
		}
	}

	w.Header().Add("Content-Type", "application/json; charset=utf-8")
	w.WriteHeader(http.StatusOK)

	bytes, err := json.Marshal(controller)

	if err != nil {
		panic("A problem occured while converting JSON: " + err.Error())
	}

	w.Write(bytes)
}

// RegisterController handles POST requests to /controllers and returns a JSON structure describing the added device if it's successfully been inserted into the database
func RegisterController(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	controller := models.Controller{}

	err := json.NewDecoder(r.Body).Decode(&controller)

	if err != nil {
		w.Header().Add("Content-Type", "application/json; charset=utf-8")
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte(`{"message":"Bad JSON."}`))
		return
	}

	if !(controller.ID != "" && controller.Address != "" && controller.Port != 0) {
		errors.MissingParams(w)
		return
	}

	if match, _ := regexp.MatchString(`^service\.controller\.\w+$`, controller.ID); !match {
		w.Header().Add("Content-Type", "application/json; charset=utf-8")
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte(`{"message":"ID contains invalid characters, refer to the documentation for more information."}`))
		return
	}

	if match, _ := regexp.MatchString(`^(?:(?:^|\.)(?:2(?:5[0-5]|[0-4]\d)|1?\d?\d)){4}$`, controller.Address); !match {
		w.Header().Add("Content-Type", "application/json; charset=utf-8")
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte(`{"message":"Invalid IPv4 address format, refer to the documentation for more information."}`))
		return
	}

	err = Database.QueryRow("INSERT INTO controllers(id, address, port) values($1,$2,$3) ON CONFLICT (id) DO UPDATE SET id = excluded.id, address = excluded.address RETURNING id, address, port", controller.ID, controller.Address, controller.Port).Scan(&controller.ID, &controller.Address, &controller.Port)

	if err != nil {
		panic(err)
	}

	if err != nil {
		panic("A problem occured while inserting object into database: " + err.Error())
	}

	w.Header().Add("Content-Type", "application/json; charset=utf-8")
	w.WriteHeader(http.StatusCreated)

	bytes, err := json.Marshal(controller)

	if err != nil {
		panic("A problem occured while converting JSON: " + err.Error())
	}

	w.Write(bytes)
}

// UnregisterController handles all DELETE requests to /controllers/<id> and return either a `404 NOT FOUND` if the room does not exist or a 204 response if it's been deleted successfully
func UnregisterController(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	var id string

	err := Database.QueryRow("SELECT id FROM controllers WHERE id=$1", p[0].Value).Scan(&id)

	if err != nil {
		if err != sql.ErrNoRows {
			panic(err)
		} else {
			w.Header().Add("Content-Type", "application/json; charset=utf-8")
			w.WriteHeader(http.StatusNotFound)
			w.Write([]byte(fmt.Sprintf(`{"message":"Controller with ID '%s' not found."}`, p[0].Value)))
			return
		}
	}

	statement, err := Database.Prepare("DELETE FROM controllers WHERE id=$1")
	_, err = statement.Exec(p[0].Value)

	defer statement.Close()

	if err != nil {
		panic(err)
	}

	w.WriteHeader(http.StatusNoContent)
}
