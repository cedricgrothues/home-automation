package handler

import (
	"encoding/json"
	"net/http"
	"strconv"

	"github.com/cedricgrothues/home-automation/modules/scene/domain"
	"github.com/cedricgrothues/httprouter"
)

// ListScenes returns all stored scenes
func ListScenes(w http.ResponseWriter, r *http.Request, p httprouter.Params) {

	var scenes []domain.Scene

	rows, err := Database.Query(`SELECT id, name, owner FROM scenes`)

	defer rows.Close()

	if err != nil {
		panic(err)
	}

	for rows.Next() {
		var scene domain.Scene

		rows.Scan(&scene.ID, &scene.Name, &scene.Owner)

		rows, err := Database.Query(`SELECT controller, device, property, value, type FROM actions WHERE scene_id=$1`, scene.ID)

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

		scenes = append(scenes, scene)
	}

	w.Header().Add("Content-Type", "application/json; charset=utf-8")
	w.WriteHeader(http.StatusOK)

	bytes, err := json.Marshal(scenes)

	if err != nil {
		panic("A problem occured while converting JSON: " + err.Error())
	}

	w.Write(bytes)
}
