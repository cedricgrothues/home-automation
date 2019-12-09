package dao

// ListAvailableServices does what it says
func (s *Sonos) ListAvailableServices() {

	options := make(map[string]interface{})

	_, err := MusicService.request(s.Address, "ListAvailableServices", options)

	if err != nil {
		panic(err)
	}
}

// GetSessionID does what it says
func (s *Sonos) GetSessionID() {
	options := make(map[string]interface{})

	_, err := MusicService.request(s.Address, "GetSessionId", options)

	if err != nil {
		panic(err)
	}
}
