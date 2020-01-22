package routes

import (
	"encoding/json"
	"fmt"
	"net/http"
	"regexp"

	"github.com/cedricgrothues/home-automation/libraries/go/errors"
	"github.com/cedricgrothues/home-automation/modules/aurora/nanoleaf"
	"github.com/cedricgrothues/home-automation/modules/aurora/registry"
	"github.com/cedricgrothues/httprouter"
)

// GetState combines core.device-registry data, with device state
func GetState(w http.ResponseWriter, r *http.Request, p httprouter.Params) {

	device, err := registry.GetDeviceInfo(p[0].Value)

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

	client, err := nanoleaf.New(device.Address+":16021", device.Token)
	result, err := client.GetInfo()

	rv := struct {
		ID         string `json:"id,omitempty"`
		Name       string `json:"name,omitempty"`
		Type       string `json:"type,omitempty"`
		Controller string `json:"controller,omitempty"`
		State      struct {
			Brightness  *nanoleaf.RangedValue `json:"brightness,omitempty"`
			ColorMode   *string               `json:"color_mode,omitempty"`
			Temperature *nanoleaf.RangedValue `json:"temperature,omitempty"`
			Hue         *nanoleaf.RangedValue `json:"hue,omitempty"`
			Power       *bool                 `json:"power,omitempty"`
			Saturation  *nanoleaf.RangedValue `json:"saturation,omitempty"`
		} `json:"state,omitempty"`
	}{
		ID:         device.ID,
		Name:       device.Name,
		Type:       device.Type,
		Controller: device.Controller,
		State: struct {
			Brightness  *nanoleaf.RangedValue `json:"brightness,omitempty"`
			ColorMode   *string               `json:"color_mode,omitempty"`
			Temperature *nanoleaf.RangedValue `json:"temperature,omitempty"`
			Hue         *nanoleaf.RangedValue `json:"hue,omitempty"`
			Power       *bool                 `json:"power,omitempty"`
			Saturation  *nanoleaf.RangedValue `json:"saturation,omitempty"`
		}{
			Brightness:  result.State.Brightness,
			ColorMode:   result.State.ColorMode,
			Temperature: result.State.CT,
			Hue:         result.State.Hue,
			Power:       result.State.On.Value,
			Saturation:  result.State.Sat,
		},
	}

	if err != nil {
		fmt.Println(err)
	}

	w.Header().Add("Content-Type", "application/json; charset=utf-8")

	bytes, err := json.Marshal(rv)

	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte(`{"message":"Failed to marshall JSON"}`))
	}

	w.WriteHeader(http.StatusOK)
	w.Write(bytes)
}

// PutState updates a device state
func PutState(w http.ResponseWriter, r *http.Request, p httprouter.Params) {

	state := struct {
		Power       *bool `json:"power"`
		Brightness  *int  `json:"brightness"`
		Temperature *int  `json:"temperature"`
		Hue         *int  `json:"hue"`
		Saturation  *int  `json:"saturation"`
	}{}

	err := json.NewDecoder(r.Body).Decode(&state)

	// Check if all params are present, if not abort with 400 error
	if err != nil {
		errors.MissingParams(w)
		return
	}

	device, err := registry.GetDeviceInfo(p[0].Value)

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

	client, _ := nanoleaf.New(device.Address+":16021", device.Token)

	client.SetState(&nanoleaf.State{
		On: &nanoleaf.OnValue{
			Value: state.Power,
		},
		Brightness: &nanoleaf.RangedValue{
			Value: state.Brightness,
		},
		Hue: &nanoleaf.RangedValue{
			Value: state.Hue,
		},
		Sat: &nanoleaf.RangedValue{
			Value: state.Saturation,
		},
		CT: &nanoleaf.RangedValue{
			Value: state.Temperature,
		},
	})

	w.WriteHeader(http.StatusNoContent)
}
