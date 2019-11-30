package response

import "encoding/json"

type response struct {
	Message string      `json:"message,omitempty"`
	Data    interface{} `json:"data,omitempty"`
}

// JSON returns a json string with it's [message] and data
func JSON(message string, data interface{}) []byte {
	res := response{Message: message, Data: data}

	b, err := json.Marshal(res)

	if err != nil {
		panic(err)
	}

	return b
}
