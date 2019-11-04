package routes

import (
	"encoding/json"
	"fmt"
	"net/http"
	"regexp"
	"strconv"

	"github.com/cedricgrothues/home-automation/libraries/go/errors"
	"github.com/cedricgrothues/home-automation/service.controller.plug/helper"
	"github.com/julienschmidt/httprouter"
)

// Device : instance of a device
type Device struct {
	ID         string `json:"id"`
	Name       string `json:"name"`
	Type       string `json:"type"`
	Controller string `json:"controller"`
	Address    string `json:"address"`
	Room       struct {
		ID      string   `json:"id"`
		Name    string   `json:"name"`
		Devices []Device `json:"devices,omitempty"`
	} `json:"room,omitempty"`
}

// Response : a typical response struct
type Response struct {
	ID      string `json:"id"`
	Name    string `json:"name"`
	Address string `json:"address"`
	State   struct {
		Power bool `json:"power"`
	} `json:"room"`
}

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

	var result Device

	err = json.NewDecoder(resp.Body).Decode(&result)

	if err != nil {
		panic(err)
	}

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

	response := Response{
		ID:      result.ID,
		Name:    result.Name,
		Address: result.Address,
	}

	resp, err = http.Get("http://" + response.Address + "/cm?cmnd=Power")

	if err != nil {
		if match, _ := regexp.MatchString(`connection refused$`, err.Error()); !match {
			panic(err)
		} else {
			w.Header().Add("Content-Type", "application/json; charset=utf-8")
			w.WriteHeader(http.StatusServiceUnavailable)
			w.Write([]byte(`{"message":"Unable to contact the device."}`))
			return
		}
	}

	defer resp.Body.Close()

	power, err := helper.PowerBool(resp.Body)

	if err != nil {
		panic(err)
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

// PatchState updates a device state
func PatchState(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	r.ParseForm()

	// Check if all params are present, if not abort with 400 error
	if !(len(r.Form["power"]) > 0) {
		errors.MissingParams(w)
		return
	}

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

	var result Device

	err = json.NewDecoder(resp.Body).Decode(&result)

	if err != nil {
		panic(err)
	}

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

	response := Response{
		ID:      result.ID,
		Name:    result.Name,
		Address: result.Address,
	}

	power, err := strconv.ParseBool(r.Form["power"][0])

	if err != nil {
		w.Header().Add("Content-Type", "application/json; charset=utf-8")
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte(`{"message":"Invalid value for key 'power'."}`))
		return
	}

	var query string

	if power == true {
		query = "cmnd=Power%201"
	} else if power == false {
		query = "cmnd=Power%200"
	}

	resp, err = http.Get("http://" + response.Address + "/cm?" + query)

	if err != nil {
		if match, _ := regexp.MatchString(`connection refused$`, err.Error()); !match {
			panic(err)
		} else {
			w.Header().Add("Content-Type", "application/json; charset=utf-8")
			w.WriteHeader(http.StatusServiceUnavailable)
			w.Write([]byte(`{"message":"Unable to contact the device."}`))
			return
		}
	}

	defer resp.Body.Close()

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

	fmt.Print("http://" + response.Address + "/cm?" + query)

	power, err = helper.PowerBool(resp.Body)

	if err != nil {
		panic(err)
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
