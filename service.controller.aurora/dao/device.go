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

// SetState defines the set device state
type SetState struct {
	Brightness  int    `json:"brightness"`
	ColorMode   string `json:"color_mode"`
	Temperature int    `json:"temperature"`
	Hue         int    `json:"hue"`
	Power       bool   `json:"power"`
	Saturation  int    `json:"saturation"`
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

// SetAurora : The aurora request structure
type SetAurora struct {
	Brightness brightness `json:"brightness"`
	ColorMode  string     `json:"colorMode"`
	Ct         ct         `json:"ct"`
	Hue        hue        `json:"hue"`
	On         on         `json:"on"`
	Sat        sat        `json:"sat"`
}

type brightness struct {
	Value     int `json:"value,omitempty"`
	Increment int `json:"increment,omitempty"`
}

type ct struct {
	Value     int `json:"value,omitempty"`
	Increment int `json:"increment,omitempty"`
}

type hue struct {
	Value     int `json:"value,omitempty"`
	Increment int `json:"increment,omitempty"`
}

type on struct {
	Value bool `json:"value,omitempty"`
}

type sat struct {
	Value     int `json:"value,omitempty"`
	Increment int `json:"increment,omitempty"`
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
func PatchState(device *Device, state *SetState) error {

	b, err := json.Marshal(SetAurora{Brightness: brightness{Value: state.Brightness}, ColorMode: state.ColorMode, Ct: ct{Value: state.Temperature}, Hue: hue{Value: state.Hue}, On: on{Value: state.Power}, Sat: sat{Value: state.Saturation}})

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
