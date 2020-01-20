package dao

import (
	"encoding/json"
	"fmt"
	"net/http"
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
	Token string `json:"token,omitempty"`
}

// GetDeviceInfo returns the requested devices info and an optional error
func GetDeviceInfo(id string) (*Device, error) {
	resp, err := http.Get(fmt.Sprintf(`http://hub.local:4000/service.device-registry/devices/%s?controller=%s`, id, "service.controller.sonoff"))

	if err != nil {
		return nil, err
	}

	defer resp.Body.Close()

	var result Device

	err = json.NewDecoder(resp.Body).Decode(&result)

	if err != nil {
		return nil, err
	}

	return &result, nil
}
