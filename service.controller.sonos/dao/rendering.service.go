package dao

import "github.com/cedricgrothues/home-automation/service.controller.sonos/helper"

// GetVolume gets the current volume
func (s *Sonos) GetVolume() {
	service := Service{"RenderingControl", s.Address, 1400, "/MediaRenderer/RenderingControl/Control", "/MediaRenderer/RenderingControl/Event"}

	options := make(map[string]interface{})
	options["InstanceID"] = 0
	options["Channel"] = "Master"

	err := service.request("GetVolume", options)

	if err != nil {
		panic(err)
	}
}

// SetVolume sets the volume
func (s *Sonos) SetVolume(desired int) {
	service := Service{"RenderingControl", s.Address, 1400, "/MediaRenderer/RenderingControl/Control", "/MediaRenderer/RenderingControl/Event"}

	options := make(map[string]interface{})
	options["InstanceID"] = 0
	options["Channel"] = "Master"
	options["DesiredVolume"] = desired

	err := service.request("SetVolume", options)

	if err != nil {
		panic(err)
	}
}

// SetRelativeVolume adjusts the volume
func (s *Sonos) SetRelativeVolume(adjustment int) {
	service := Service{"RenderingControl", s.Address, 1400, "/MediaRenderer/RenderingControl/Control", "/MediaRenderer/RenderingControl/Event"}

	options := make(map[string]interface{})
	options["InstanceID"] = 0
	options["Channel"] = "Master"
	options["Adjustment"] = adjustment

	err := service.request("SetRelativeVolume", options)

	if err != nil {
		panic(err)
	}
}

// GetMute gets the current mute value
func (s *Sonos) GetMute() {
	service := Service{"RenderingControl", s.Address, 1400, "/MediaRenderer/RenderingControl/Control", "/MediaRenderer/RenderingControl/Event"}

	options := make(map[string]interface{})
	options["InstanceID"] = 0
	options["Channel"] = "Master"

	err := service.request("GetMute", options)

	if err != nil {
		panic(err)
	}
}

// SetMute sets the mute
func (s *Sonos) SetMute(mute bool) {
	service := Service{"RenderingControl", s.Address, 1400, "/MediaRenderer/RenderingControl/Control", "/MediaRenderer/RenderingControl/Event"}

	options := make(map[string]interface{})
	options["InstanceID"] = 0
	options["Channel"] = "Master"
	options["DesiredMute"] = helper.BoolToInt(mute)

	err := service.request("SetMute", options)

	if err != nil {
		panic(err)
	}
}
