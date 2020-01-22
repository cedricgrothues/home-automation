package nanoleaf

import (
	"errors"
	"io/ioutil"
	"net/url"
)

func (c *client) Authorize() error {
	authResp := &AddUserResponse{}
	_, err := c.request("POST", "new", nil, authResp)
	if err != nil {
		return err
	}

	c.Token = authResp.AuthToken
	if c.Token != nil {
		tokenPath := &url.URL{Path: *c.Token}
		c.BaseURL = c.BaseURL.ResolveReference(tokenPath)
		return nil
	}

	return errors.New("Unable to authenticate")
}

func (c *client) GetInfo() (*DeviceInfo, error) {
	info := &DeviceInfo{}
	_, err := c.request("GET", "", nil, info)
	if err != nil {
		return nil, err
	}
	return info, nil
}

func (c *client) SetState(state *State) error {
	_, err := c.request("PUT", "state", state, nil)
	return err
}

func (c *client) GetPower() (*OnValue, error) {
	value := &OnValue{}
	_, err := c.request("GET", "state/on", nil, value)
	if err != nil {
		return nil, err
	}
	return value, nil
}

func (c *client) SetPower(value bool) error {
	state := &State{
		On: &OnValue{Value: &value},
	}
	return c.SetState(state)
}

func (c *client) GetBrightness() (*RangedValue, error) {
	value := &RangedValue{}
	_, err := c.request("GET", "state/brightness", nil, value)
	if err != nil {
		return nil, err
	}
	return value, err
}

func (c *client) SetBrightness(value int) error {
	state := &State{
		Brightness: &RangedValue{Value: &value},
	}
	return c.SetState(state)
}

func (c *client) SetBrightnessWithDuration(value int, duration int) error {
	state := &State{
		Brightness: &RangedValue{Value: &value, Duration: &duration},
	}
	return c.SetState(state)
}

func (c *client) GetHue() (*RangedValue, error) {
	value := &RangedValue{}
	_, err := c.request("GET", "state/hue", nil, value)
	if err != nil {
		return nil, err
	}
	return value, nil
}

func (c *client) SetHue(value int) error {
	state := &State{
		Hue: &RangedValue{Value: &value},
	}
	return c.SetState(state)
}

func (c *client) GetSaturation() (*RangedValue, error) {
	value := &RangedValue{}
	_, err := c.request("GET", "state/sat", nil, value)
	if err != nil {
		return nil, err
	}
	return value, nil
}

func (c *client) SetSaturation(value int) error {
	state := &State{
		Sat: &RangedValue{Value: &value},
	}
	return c.SetState(state)
}

func (c *client) GetColorTemperature() (*RangedValue, error) {
	value := &RangedValue{}
	_, err := c.request("GET", "state/ct", nil, value)
	if err != nil {
		return nil, err
	}
	return value, nil
}

func (c *client) SetColorTemperature(value int) error {
	state := &State{
		CT: &RangedValue{Value: &value},
	}
	return c.SetState(state)
}

func (c *client) GetColorMode() (string, error) {
	resp, err := c.raw("GET", "state/colorMode", nil)
	defer resp.Body.Close()
	if err != nil {
		return "", err
	}
	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return "", err
	}

	value := string(body)

	return value, err
}

func (c *client) GetCurrentEffect() (string, error) {
	var value string
	_, err := c.raw("GET", "effects/select", nil)

	return value, err
}

func (c *client) GetAllEffects() ([]string, error) {
	value := &[]string{}
	_, err := c.request("GET", "effects/effectsList", nil, value)
	return *value, err
}

func (c *client) SelectEffect(effect string) error {
	value := &Effects{Select: &effect}
	_, err := c.request("PUT", "effects", value, nil)
	return err
}
