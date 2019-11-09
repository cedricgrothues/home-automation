package dao

import (
	"fmt"
	"net/http"

	"github.com/cedricgrothues/home-automation/service.controller.sonoff/helper"
)

// GetState returns the requested devices state and an optional error
func GetState(address string) (bool, error) {

	resp, err := http.Get(fmt.Sprintf(`http://%s/cm?cmnd=Power`, address))

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
	var cmnd string

	if state == "true" {
		cmnd = "1"
	} else if state == "false" {
		cmnd = "0"
	}

	resp, err := http.Get(fmt.Sprintf(`http://%s/cm?cmnd=Power%%20%s`, address, cmnd))

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
