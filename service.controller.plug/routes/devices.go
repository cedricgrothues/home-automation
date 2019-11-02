package routes

import (
	"encoding/json"
	"net/http"
	"regexp"

	"github.com/julienschmidt/httprouter"
)

// GetState combines service.device-registry data, with device state
func GetState(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	resp, err := http.Get("http://localhost:4000/devices/" + p[0].Value + "?controller=service.controller.plug")

	if err != nil {
		if match, _ := regexp.MatchString(`connection refused$`, err.Error()); !match {
			panic(err)
		} else {
			w.Header().Add("Content-Type", "application/json; charset=utf-8")
			w.WriteHeader(http.StatusServiceUnavailable)
			w.Write([]byte(`{"message":"Unable to contact the device-registry service."}`))
			return
		}
	}

	defer resp.Body.Close()

	var result map[string]interface{}

	json.NewDecoder(resp.Body).Decode(&result)

	if resp.StatusCode != 200 {
		w.Header().Add("Content-Type", "application/json; charset=utf-8")
		w.WriteHeader(resp.StatusCode)

		res, err := json.Marshal(result)

		if err != nil {
			panic(err)
		}

		w.Write([]byte(res))
		return
	}

	w.WriteHeader(http.StatusNoContent)
}

// PatchState updates a device state
func PatchState(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	w.WriteHeader(http.StatusNoContent)
}
