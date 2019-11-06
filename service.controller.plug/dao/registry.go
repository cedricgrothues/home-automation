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
}

// GetDeviceInfo returns the requested devices info and an optional error
func GetDeviceInfo(id string) (*Device, error) {
	resp, err := http.Get(fmt.Sprintf(`http://localhost:4000/devices/%s?controller=%s`, id, "service.controller.plug"))

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
