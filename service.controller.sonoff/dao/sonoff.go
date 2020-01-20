package dao

import (
	"fmt"
	"net/http"
	"time"

	"github.com/cedricgrothues/home-automation/service.controller.sonoff/helper"
)

// GetState returns the requested devices state and an optional error
func GetState(address string, token string) (bool, error) {
	client := http.Client{
		Timeout: 5 * time.Second,
	}

	var auth string

	if token != "" {
		auth = fmt.Sprintf("user=admin&password=%s&", token)
	}

	fmt.Println(auth)

	url := fmt.Sprintf(`http://%s/cm?%scmnd=Power`, address, auth)

	fmt.Println(url)

	resp, err := client.Get(url)

	if err != nil {
		return false, err
	}

	power, err := helper.PowerBool(resp.Body)

	if err != nil {
		return false, err
	}

	defer resp.Body.Close()

	if len(power) < 1 {
		return false, fmt.Errorf("no result")
	}

	return power[0], nil
}

// SetState updates the requested devices state and returns the power state and an optional error
func SetState(address string, state bool, token string) (bool, error) {
	var cmnd string

	if state == true {
		cmnd = "1"
	} else if state == false {
		cmnd = "0"
	}

	var auth string

	if token != "" {
		auth = fmt.Sprintf("user=admin&password=%s&", token)
	}

	resp, err := http.Get(fmt.Sprintf(`http://%s/cm?%scmnd=Power%%20%s`, address, auth, cmnd))

	if err != nil {
		return false, err
	}

	defer resp.Body.Close()

	power, err := helper.PowerBool(resp.Body)

	if err != nil {
		return false, err
	}

	if len(power) < 1 {
		return false, fmt.Errorf("no result")
	}

	return power[0], nil
}
