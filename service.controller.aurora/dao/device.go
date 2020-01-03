package dao

import (
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

type resp struct {
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

// GetState returns the given device's state
func GetState(device *Device) (*State, error) {
	response, err := http.Get(fmt.Sprintf("http://%s:16021/api/v1/%s/state", device.Address, device.Token))

	if err != nil {
		return nil, err
	} else if response.StatusCode != 200 {
		return nil, errors.New("invalid status code")
	}

	var resp resp

	err = json.NewDecoder(response.Body).Decode(&resp)

	if err != nil {
		return nil, err
	}

	return &State{Brightness: resp.Brightness, ColorMode: resp.ColorMode, Temperature: resp.Ct, Hue: resp.Hue, Power: resp.On.Value, Saturation: resp.Sat}, nil
}
