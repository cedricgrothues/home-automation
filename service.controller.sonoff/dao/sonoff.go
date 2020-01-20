package dao

import (
	"fmt"
	"net/http"
	"time"

	"github.com/cedricgrothues/home-automation/service.controller.sonoff/helper"
)

// GetState returns the requested devices state and an optional error
func GetState(address string) (bool, error) {
	client := http.Client{
		Timeout: 5 * time.Second,
	}

	resp, err := client.Get(fmt.Sprintf(`http://%s/cm?cmnd=Power`, address))

	if err != nil {
		return false, err
	}

	power, err := helper.PowerBool(resp.Body)

	if err != nil {
		return false, err
	}

	defer resp.Body.Close()

	return power, nil
}

// SetState updates the requested devices state and returns the power state and an optional error
func SetState(address string, state bool, token string) (bool, error) {
	var cmnd string

	if state == true {
		cmnd = "1"
	} else if state == false {
		cmnd = "0"
	}

	var resp *http.Response
	var err error

	if token != "" {
		resp, err = http.Get(fmt.Sprintf(`http://%s/cm?user=admin&password=%s&cmnd=Power%%20%s`, token, address, cmnd))
	} else {
		resp, err = http.Get(fmt.Sprintf(`http://%s/cm?cmnd=Power%%20%s`, address, cmnd))
	}

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
