package dao

// ListAvailableServices does what it says
func (s *Sonos) ListAvailableServices() {
	service := Service{"MusicServices", s.Address, 1400, "/MusicServices/Control"}

	options := make(map[string]interface{})

	err := service.request("ListAvailableServices", options)

	if err != nil {
		panic(err)
	}
}

// GetSessionID does what it says
func (s *Sonos) GetSessionID() {
	service := Service{"MusicServices", s.Address, 1400, "/MusicServices/Control"}

	options := make(map[string]interface{})

	err := service.request("GetSessionId", options)

	if err != nil {
		panic(err)
	}
}
