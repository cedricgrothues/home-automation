package nanoleaf

import (
	"bytes"
	"encoding/json"
	"errors"
	"io"
	"net/http"
	"net/url"
)

// Client defines the default client interface
type Client interface {
	Authorize() error
	GetInfo() (*DeviceInfo, error)
	SetState(state *State) error
	GetPower() (*OnValue, error)
	SetPower(value bool) error
	GetBrightness() (*RangedValue, error)
	SetBrightness(value int) error
	SetBrightnessWithDuration(value int, duration int) error
	GetHue() (*RangedValue, error)
	SetHue(value int) error
	GetSaturation() (*RangedValue, error)
	SetSaturation(value int) error
	GetColorTemperature() (*RangedValue, error)
	SetColorTemperature(value int) error
	GetColorMode() (string, error)
	GetCurrentEffect() (string, error)
	GetAllEffects() ([]string, error)
	SelectEffect(effect string) error
}

type client struct {
	BaseURL *url.URL
	Token   *string
}

// New returns a new client
func New(address string, token string) (Client, error) {
	baseURL, err := url.Parse("http://" + address + "/api/v1/" + token + "/")
	if err != nil {
		return nil, err
	}
	return &client{
		BaseURL: baseURL,
		Token:   &token,
	}, nil
}

func (c *client) new(method, path string, body interface{}) (*http.Request, error) {
	rel := url.URL{Path: path}
	url := c.BaseURL.ResolveReference(&rel)
	var buf io.ReadWriter
	if body != nil {
		buf = new(bytes.Buffer)
		err := json.NewEncoder(buf).Encode(body)
		if err != nil {
			return nil, err
		}
	}

	req, err := http.NewRequest(method, url.String(), buf)
	if err != nil {
		return nil, err
	}

	if body != nil {
		req.Header.Set("Content-Type", "application/json")
	}

	req.Header.Set("Accept", "application/json")

	return req, nil
}

func (c *client) do(req *http.Request, v interface{}) (*http.Response, error) {
	client := http.DefaultClient

	resp, err := client.Do(req)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if v != nil {
		decoder := json.NewDecoder(resp.Body)
		decoder.UseNumber()

		decoder.Decode(v)
	}

	return resp, err
}

func (c *client) request(method, path string, data interface{}, resp interface{}) (*http.Response, error) {
	req, err := c.new(method, path, data)

	if err != nil {
		return nil, err
	}

	response, err := c.do(req, resp)

	if err != nil {
		return nil, err
	}

	switch response.StatusCode {
	case http.StatusNotFound:
		return nil, errors.New("not found")
	case http.StatusInternalServerError:
		return nil, errors.New("internal server error")
	}
	return response, nil
}

func (c *client) raw(method, path string, data interface{}) (*http.Response, error) {
	req, err := c.new(method, path, data)

	if err != nil {
		return nil, err
	}

	client := http.DefaultClient

	resp, err := client.Do(req)

	switch resp.StatusCode {
	case 404:
		err = errors.New("not found")
	case 500:
		err = errors.New("internal server error")
	}

	return resp, err
}
