package dao

import "github.com/cedricgrothues/home-automation/service.controller.sonos/helper"

// GetVolume gets the current volume
func (s *Sonos) GetVolume() error {
	options := make(map[string]interface{})
	options["InstanceID"] = 0
	options["Channel"] = "Master"

	_, err := renderingService.request(s.Address, "GetVolume", options)

	if err != nil {
		return err
	}

	return nil
}

// SetVolume sets the volume
func (s *Sonos) SetVolume(desired int) error {

	options := make(map[string]interface{})
	options["InstanceID"] = 0
	options["Channel"] = "Master"
	options["DesiredVolume"] = desired

	_, err := renderingService.request(s.Address, "SetVolume", options)

	if err != nil {
		return err
	}

	return nil
}

// SetRelativeVolume adjusts the volume
func (s *Sonos) SetRelativeVolume(adjustment int) error {

	options := make(map[string]interface{})
	options["InstanceID"] = 0
	options["Channel"] = "Master"
	options["Adjustment"] = adjustment

	_, err := renderingService.request(s.Address, "SetRelativeVolume", options)

	if err != nil {
		return err
	}

	return nil
}

// GetMute gets the current mute value
func (s *Sonos) GetMute() bool {

	options := make(map[string]interface{})
	options["InstanceID"] = 0
	options["Channel"] = "Master"

	_, err := renderingService.request(s.Address, "GetMute", options)

	if err != nil {
		panic(err)
	}

	// TODO: Implement return type
	return false
}

// SetMute sets the mute
func (s *Sonos) SetMute(mute bool) error {

	options := make(map[string]interface{})
	options["InstanceID"] = 0
	options["Channel"] = "Master"
	options["DesiredMute"] = helper.BoolToInt(mute)

	_, err := renderingService.request(s.Address, "SetMute", options)

	if err != nil {
		return err
	}

	return nil
}
