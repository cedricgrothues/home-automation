package dao

// SetLEDState does what it says
func (s *Sonos) SetLEDState(on bool) (bool, error) {

	options := make(map[string]interface{})

	if on == false {
		options["DesiredLEDState"] = "Off"
	} else {
		options["DesiredLEDState"] = "On"
	}

	_, err := deviceService.request(s.Address, "SetLEDState", options)

	if err != nil {
		return false, err
	}

	return true, nil
}

// GetLEDState does what it says
func (s *Sonos) GetLEDState() {
	options := make(map[string]interface{})

	_, err := deviceService.request(s.Address, "GetLEDState", options)

	if err != nil {
		panic(err)
	}
}

// func (s *Sonos) SetFriendlyName() {

// }
