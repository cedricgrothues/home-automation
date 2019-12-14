package routes

import (
	"encoding/json"
	"github.com/cedricgrothues/home-automation/service.controller.sonos/discovery"
	"github.com/cedricgrothues/httprouter"
	"net/http"
)

// DiscoverDevices returns all devices found this service's network, using ssdp discovery
func DiscoverDevices(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	devices := make(chan *discovery.Sonos)
	done := make(chan bool)
	errors := make(chan error)

	go discovery.Discover(devices, errors, done)

	var speakers []*discovery.Sonos

	for {
		select {
		case speaker := <-devices:
			speakers = append(speakers, speaker)
		case err := <-errors:
			panic(err)
		case <-done:
			w.Header().Add("Content-Type", "application/json; charset=utf-8")

			bytes, err := json.Marshal(speakers)

			if err != nil {
				w.WriteHeader(http.StatusInternalServerError)
				w.Write([]byte(`{"message":"Failed to marshall json."}`))
				return
			}

			w.WriteHeader(http.StatusOK)
			w.Write(bytes)
			return
		}
	}
}
