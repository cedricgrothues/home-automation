package dao

// Play : Start the media playback
func (s *Sonos) Play() {
	service := Service{"AVTransport", s.Address, 1400, "/MediaRenderer/AVTransport/Control"}

	options := make(map[string]interface{})
	options["InstanceID"] = 0
	options["Speed"] = 1

	err := service.request("Play", options)

	if err != nil {
		panic(err)
	}
}

// Pause the media playback
func (s *Sonos) Pause() {
	service := Service{"AVTransport", s.Address, 1400, "/MediaRenderer/AVTransport/Control"}

	options := make(map[string]interface{})
	options["InstanceID"] = 0

	err := service.request("Pause", options)

	if err != nil {
		panic(err)
	}
}

// Stop the media playback
func (s *Sonos) Stop() {
	service := Service{"AVTransport", s.Address, 1400, "/MediaRenderer/AVTransport/Control"}

	options := make(map[string]interface{})
	options["InstanceID"] = 0

	err := service.request("Stop", options)

	if err != nil {
		panic(err)
	}
}

// Next track
func (s *Sonos) Next() {
	service := Service{"AVTransport", s.Address, 1400, "/MediaRenderer/AVTransport/Control"}

	options := make(map[string]interface{})
	options["InstanceID"] = 0

	err := service.request("Next", options)

	if err != nil {
		panic(err)
	}
}

// Previous track
func (s *Sonos) Previous() {
	service := Service{"AVTransport", s.Address, 1400, "/MediaRenderer/AVTransport/Control"}

	options := make(map[string]interface{})
	options["InstanceID"] = 0

	err := service.request("Previous", options)

	if err != nil {
		panic(err)
	}
}

// GetPositionInfo does that
func (s *Sonos) GetPositionInfo() {
	service := Service{"AVTransport", s.Address, 1400, "/MediaRenderer/AVTransport/Control"}

	options := make(map[string]interface{})
	options["InstanceID"] = 0

	err := service.request("GetPositionInfo", options)

	if err != nil {
		panic(err)
	}
}
