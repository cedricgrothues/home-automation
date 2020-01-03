package discover

import (
	"encoding/json"
	"errors"
	"net"
	"net/http"
)

type respose struct {
	Token string `json:"auth_token"`
}

// Token generates a new token for the aurora.
func Token(address *net.IP) (string, error) {
	res, err := http.Post("http://"+address.String()+":16021/api/v1/new", "none", nil)

	if res.StatusCode == 403 {
		return "", errors.New("forbidden")
	} else if res.StatusCode == 401 {
		return "", errors.New("not authorized")
	} else if res.StatusCode == 422 {
		return "", errors.New("unprocessable entity")
	}

	resp := respose{}

	json.NewDecoder(res.Body).Decode(&resp)

	if err != nil {
		return "", err
	}

	return resp.Token, nil
}
