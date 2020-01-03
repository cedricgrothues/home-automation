package routes

import (
	"encoding/json"
	"net/http"
	"regexp"

	"github.com/cedricgrothues/home-automation/libraries/go/errors"
	"github.com/cedricgrothues/home-automation/service.controller.aurora/dao"
	"github.com/cedricgrothues/httprouter"
)

// GetState combines service.device-registry data, with device state
func GetState(w http.ResponseWriter, r *http.Request, p httprouter.Params) {

	device, err := dao.GetDeviceInfo(p[0].Value)

	if err != nil {
		if match, _ := regexp.MatchString(`connection refused$`, err.Error()); !match {
			panic(err)
		} else {
			w.Header().Add("Content-Type", "application/json; charset=utf-8")
			w.WriteHeader(http.StatusFailedDependency)
			w.Write([]byte(`{"message":"Unable to contact the device-registry service."}`))
			return
		}
	}

	result, err := dao.GetState(device)

	if err != nil {
		panic(err)
	}

	w.Header().Add("Content-Type", "application/json; charset=utf-8")

	bytes, err := json.Marshal(result)

	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte(`{"message":"Failed to marshall JSON"}`))
	}

	w.WriteHeader(http.StatusOK)
	w.Write(bytes)
}

// PatchState updates a device state
func PatchState(w http.ResponseWriter, r *http.Request, p httprouter.Params) {

	var request struct {
		Power bool `json:"power"`
	}

	err := json.NewDecoder(r.Body).Decode(&request)

	// Check if all params are present, if not abort with 400 error
	if err != nil {
		errors.MissingParams(w)
		return
	}

	if err != nil {
		// undesirable solution, update in the near future
		if match, _ := regexp.MatchString(`connection refused$`, err.Error()); !match {
			panic(err)
		} else {
			w.Header().Add("Content-Type", "application/json; charset=utf-8")
			w.WriteHeader(http.StatusFailedDependency)
			w.Write([]byte(`{"message":"Unable to contact the device-registry service."}`))
			return
		}
	}

	w.Header().Add("Content-Type", "application/json; charset=utf-8")
	w.WriteHeader(http.StatusFailedDependency)
	w.Write([]byte(`{"message":"Unable to contact the device."}`))
}
