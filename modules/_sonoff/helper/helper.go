package helper

import (
	"encoding/json"
	"io"
)

// PowerBool parses the power value from a tasmota response
func PowerBool(body io.ReadCloser) ([]bool, error) {
	var results []bool

	r := make(map[string]interface{})

	err := json.NewDecoder(body).Decode(&r)

	if err != nil {
		return nil, err
	}

	for _, v := range r {
		if v == "ON" {
			results = append(results, true)
		} else {
			results = append(results, false)
		}
	}

	return results, nil
}
