package helper

import (
	"encoding/json"
	"fmt"
	"io"
)

// PowerBool parses the power value from a tasmota response
func PowerBool(body io.ReadCloser) (bool, error) {
	r := make(map[string]interface{})

	err := json.NewDecoder(body).Decode(&r)

	if err != nil {
		return false, err
	}

	if r["POWER"] == "ON" {
		return true, nil
	} else if r["POWER"] == "OFF" {
		return false, nil
	}

	return false, fmt.Errorf("Can't parse power value %v", r["POWER"])

}
