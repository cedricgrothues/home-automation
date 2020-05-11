package handler

import (
	"bytes"
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"

	"github.com/cedricgrothues/home-automation/modules/scene/domain"
	"github.com/gorilla/mux"
)

// ExecScene runs the scene asynchronously
func ExecScene(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)

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

		// run action

		go func() {
			body := map[string]interface{}{
				a.Property.Name: a.Property.Value,
			}

			b, err := json.Marshal(body)

			if err != nil {
				return
			}

			req, err := http.NewRequest(http.MethodPut, fmt.Sprintf("http://core.api-gateway:4000/%s/devices/%s", a.Controller, a.Device), bytes.NewReader(b))

			if err != nil {
				return
			}

			_, err = http.DefaultClient.Do(req)
		}()
	}

	w.WriteHeader(http.StatusNoContent)
}
