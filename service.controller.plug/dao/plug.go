package dao

import (
	"net/http"

	"github.com/cedricgrothues/home-automation/service.controller.plug/helper"
)

// GetState returns the requested devices state and an optional error
func GetState(address string) (bool, error) {
	resp, err := http.Get("http://" + address + "/cm?cmnd=Power")

	if err != nil {
		return false, err
	}

	defer resp.Body.Close()

	power, err := helper.PowerBool(resp.Body)

	if err != nil {
		return false, err
	}

	return power, nil
}

// SetState updates the requested devices state and returns the power state and an optional error
func SetState(address string, state string) (bool, error) {
	var query string

	if state == "true" {
		query = "cmnd=Power%201"
	} else if state == "false" {
		query = "cmnd=Power%200"
	}

	resp, err := http.Get("http://" + address + "/cm?" + query)

	if err != nil {
		return false, err
	}

	defer resp.Body.Close()

	power, err := helper.PowerBool(resp.Body)

	if err != nil {
		return false, err
	}
	return power, nil
}
