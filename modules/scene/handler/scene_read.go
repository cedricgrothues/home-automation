package handler

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"

	"github.com/cedricgrothues/home-automation/modules/scene/domain"
	"github.com/gorilla/mux"
)

// ReadScene return the requested scene
func ReadScene(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	scene := domain.Scene{}

	err := Database.QueryRow("SELECT id, name, owner FROM scenes WHERE id=$1", vars["id"]).Scan(&scene.ID, &scene.Name, &scene.Owner)

	if err != nil {
		if err != sql.ErrNoRows {
			panic(err)
		} else {
			w.Header().Add("Content-Type", "application/json; charset=utf-8")
			w.WriteHeader(http.StatusNotFound)
			w.Write([]byte(fmt.Sprintf(`{"message":"Scene with ID '%s' not found."}`, vars["id"])))
			return
		}
	}

	rows, err := Database.Query(`SELECT controller, device, property, value, type FROM actions WHERE scene_id=$1`, vars["id"])

	defer rows.Close()

	if err != nil {
		panic(err)
	}

	for rows.Next() {
		var a domain.Action
		var p domain.Property

		a.Property = &p

		var value, propertyType string

		rows.Scan(&a.Controller, &a.Device, &a.Property.Name, &value, &propertyType)

		switch propertyType {
		case "bool":
			if val, err := strconv.ParseBool(value); err == nil {
				a.Property.Value = val
			} else {
				a.Property.Value = value
			}
		case "float64":
			if val, err := strconv.ParseFloat(value, 64); err == nil {
				a.Property.Value = val
			} else {
				a.Property.Value = value
			}
		default:
			a.Property.Value = value
		}

		scene.Actions = append(scene.Actions, &a)
	}

	w.Header().Add("Content-Type", "application/json; charset=utf-8")
	w.WriteHeader(http.StatusOK)

	bytes, err := json.Marshal(scene)

	if err != nil {
		panic("A problem occured while converting JSON: " + err.Error())
	}

	w.Write(bytes)
}
