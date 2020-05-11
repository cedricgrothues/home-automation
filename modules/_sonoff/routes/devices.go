package routes

import (
	"encoding/json"
	"net"
	"net/http"
	"regexp"

	"github.com/cedricgrothues/home-automation/libraries/go/errors"
	"github.com/cedricgrothues/home-automation/modules/_sonoff/dao"
	"github.com/gorilla/mux"
)

// Response : a typical response struct
type Response struct {
	ID      string `json:"id"`
	Name    string `json:"name"`
	Address string `json:"address"`
	State   struct {
		Power bool `json:"power"`
	} `json:"state"`
}

// GetState combines core.device-registry data, with device state
func GetState(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)

	device, err := dao.GetDeviceInfo(vars["id"])

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

	response := Response{
		ID:      device.ID,
		Name:    device.Name,
		Address: device.Address,
	}

	power, err := dao.GetState(response.Address, device.Token)

	if err != nil {
		w.Header().Add("Content-Type", "application/json; charset=utf-8")
		w.WriteHeader(http.StatusFailedDependency)
		w.Write([]byte(`{"message":"Failed to connect to the device."}`))
		return
	}

	response.State.Power = power

	w.Header().Add("Content-Type", "application/json; charset=utf-8")
	w.WriteHeader(http.StatusOK)

	bytes, err := json.Marshal(response)

	if err != nil {
		panic("A problem occured while converting JSON: " + err.Error())
	}

	w.Write(bytes)
}

// PutState updates a device state
func PutState(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)

	var request struct {
		Power bool `json:"power"`
	}

	err := json.NewDecoder(r.Body).Decode(&request)
	// Check if all params are present, if not abort with 400 error
	if err != nil {
		errors.MissingParams(w)
		return
	}

	device, err := dao.GetDeviceInfo(vars["id"])

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

	response := Response{
		ID:      device.ID,
		Name:    device.Name,
		Address: device.Address,
	}

	if err != nil {
		w.Header().Add("Content-Type", "application/json; charset=utf-8")
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte(`{"message":"Invalid value for key 'power'."}`))
		return
	}

	power, err := dao.SetState(response.Address, request.Power, device.Token)

	if err != nil {
		if err, ok := err.(net.Error); ok && err.Timeout() {
			w.Header().Add("Content-Type", "application/json; charset=utf-8")
			w.WriteHeader(http.StatusServiceUnavailable)
			w.Write([]byte(`{"message":"device timed out"}`))
			return
		}

		w.Header().Add("Content-Type", "application/json; charset=utf-8")
		w.WriteHeader(http.StatusFailedDependency)
		w.Write([]byte(`{"message":"Failed to connect to the device."}`))
		return
	}

	response.State.Power = power

	w.Header().Add("Content-Type", "application/json; charset=utf-8")
	w.WriteHeader(http.StatusOK)

	bytes, err := json.Marshal(response)

	if err != nil {
		panic("A problem occured while converting JSON: " + err.Error())
	}

	w.Write(bytes)
}
