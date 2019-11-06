package dao

// SetLEDState does what it says
func (s *Sonos) SetLEDState(state string) {
	service := Service{"DeviceProperties", s.Address, 1400, "/DeviceProperties/Control"}

	options := make(map[string]interface{})
	options["DesiredLEDState"] = state

	err := service.request("SetLEDState", options)

	if err != nil {
		panic(err)
	}
}

// GetLEDState does what it says
func (s *Sonos) GetLEDState() {
	service := Service{"DeviceProperties", s.Address, 1400, "/DeviceProperties/Control"}

	options := make(map[string]interface{})

	err := service.request("GetLEDState", options)

	if err != nil {
		panic(err)
	}
}
