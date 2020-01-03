package dao

import (
	"bytes"
	"encoding/json"
	"errors"
	"fmt"
	"net/http"
)

// State defines the returned device state
type State struct {
	Brightness struct {
		Value int `json:"value"`
		Max   int `json:"max,omitempty"`
		Min   int `json:"min,omitempty"`
	} `json:"brightness,omitempty"`
	ColorMode   string `json:"color_mode"`
	Temperature struct {
		Value int `json:"value"`
		Max   int `json:"max,omitempty"`
		Min   int `json:"min,omitempty"`
	} `json:"temperature,omitempty"`
	Hue struct {
		Value int `json:"value"`
		Max   int `json:"max,omitempty"`
		Min   int `json:"min,omitempty"`
	} `json:"hue,omitempty"`
	Power      bool `json:"power"`
	Saturation struct {
		Value int `json:"value"`
		Max   int `json:"max,omitempty"`
		Min   int `json:"min,omitempty"`
	} `json:"saturation,omitempty"`
}

// Aurora : The aurora response structure
type Aurora struct {
	Brightness brightness `json:"brightness,omitempty"`
	ColorMode  string     `json:"colorMode,omitempty"`
	Ct         ct         `json:"ct,omitempty"`
	Hue        hue        `json:"hue,omitempty"`
	On         on         `json:"on,omitempty"`
	Sat        sat        `json:"sat,omitempty"`
}

type on struct {
	Value bool `json:"value"`
}

type brightness struct {
	Value int `json:"value"`
	Max   int `json:"max,omitempty"`
	Min   int `json:"min,omitempty"`
}

type ct struct {
	Value int `json:"value"`
	Max   int `json:"max,omitempty"`
	Min   int `json:"min,omitempty"`
}

type hue struct {
	Value int `json:"value"`
	Max   int `json:"max,omitempty"`
	Min   int `json:"min,omitempty"`
}

type sat struct {
	Value int `json:"value"`
	Max   int `json:"max,omitempty"`
	Min   int `json:"min,omitempty"`
}

// GetState returns the given device's state
func GetState(device *Device) (*State, error) {
	response, err := http.Get(fmt.Sprintf("http://%s:16021/api/v1/%s/state", device.Address, device.Token))

	if err != nil {
		return nil, err
	} else if response.StatusCode != 200 {
		return nil, errors.New("invalid status code")
	}

	var aurora Aurora

	err = json.NewDecoder(response.Body).Decode(&aurora)

	if err != nil {
		return nil, err
	}

	return &State{Brightness: aurora.Brightness, ColorMode: aurora.ColorMode, Temperature: aurora.Ct, Hue: aurora.Hue, Power: aurora.On.Value, Saturation: aurora.Sat}, nil
}

// PatchState changes device state
func PatchState(device *Device, state *State) error {

	b, err := json.Marshal(Aurora{Brightness: brightness{Value: state.Brightness.Value}, ColorMode: state.ColorMode, Ct: ct{Value: state.Temperature.Value}, Hue: hue{Value: state.Hue.Value}, On: on{Value: state.Power}, Sat: sat{Value: state.Saturation.Value}})

	if err != nil {
		return err
	}

	client := &http.Client{}
	req, err := http.NewRequest(http.MethodPut, fmt.Sprintf("http://%s:16021/api/v1/%s/state", device.Address, device.Token), bytes.NewReader(b))

	if err != nil {
		return err
	}

	response, err := client.Do(req)

	if err != nil {
		return err
	} else if response.StatusCode != 204 {
		return errors.New("invalid status code")
	}

	return nil
}
