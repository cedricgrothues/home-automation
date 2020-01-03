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
		Max   int `json:"max"`
		Min   int `json:"min"`
	} `json:"brightness"`
	ColorMode   string `json:"color_mode"`
	Temperature struct {
		Value int `json:"value"`
		Max   int `json:"max"`
		Min   int `json:"min"`
	} `json:"temperature"`
	Hue struct {
		Value int `json:"value"`
		Max   int `json:"max"`
		Min   int `json:"min"`
	} `json:"hue"`
	Power      bool `json:"power"`
	Saturation struct {
		Value int `json:"value"`
		Max   int `json:"max"`
		Min   int `json:"min"`
	} `json:"saturation"`
}

// Aurora : The aurora response structure
type Aurora struct {
	Brightness struct {
		Value int `json:"value"`
		Max   int `json:"max"`
		Min   int `json:"min"`
	} `json:"brightness"`
	ColorMode string `json:"colorMode"`
	Ct        struct {
		Value int `json:"value"`
		Max   int `json:"max"`
		Min   int `json:"min"`
	} `json:"ct"`
	Hue struct {
		Value int `json:"value"`
		Max   int `json:"max"`
		Min   int `json:"min"`
	} `json:"hue"`
	On struct {
		Value bool `json:"value"`
	} `json:"on"`
	Sat struct {
		Value int `json:"value"`
		Max   int `json:"max"`
		Min   int `json:"min"`
	} `json:"sat"`
}

// Value : the device value
type Value struct {
	Value interface{} `json:"value"`
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
func PatchState(device *Device, state map[string]Value) error {

	b, err := json.Marshal(state)

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
