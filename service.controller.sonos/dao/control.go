package dao

import (
	"bytes"
	"fmt"
	"net/http"
)

// Sonos :
type Sonos struct {
	Address string
}

// Service :
type Service struct {
	Name    string
	Address string
	Port    int
}

// Play : Start the media playback
func (s *Sonos) Play() {
	service := Service{"AVTransport", s.Address, 1400}

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

}

// Stop the media playback
func (s *Sonos) Stop() {
	service := Service{"AVTransport", s.Address, 1400}

	options := make(map[string]interface{})
	options["InstanceID"] = 0

	err := service.request("Stop", options)

	if err != nil {
		panic(err)
	}
}

func (s *Service) request(a string, o map[string]interface{}) error {
	action := fmt.Sprintf(`"urn:schemas-upnp-org:service:%s:1#%s"`, s.Name, a)
	body := `<u:` + a + ` xmlns:u="urn:schemas-upnp-org:service:` + s.Name + `:1">`

	for k, v := range o {
		body += fmt.Sprintf(`<%s>%v</%s>`, k, v, k)
	}

	body += fmt.Sprintf(`</u:%s>`, a)

	buffer := bytes.NewBufferString(body)

	req, err := http.NewRequest("POST", fmt.Sprintf(`http://%s:%d/MediaRenderer/AVTransport/Control`, s.Address, s.Port), buffer)

	if err != nil {
		return err
	}

	req.Header.Set("Content-Type", "text/xml; charset=utf8")
	req.Header.Set("SOAPAction", action)

	client := &http.Client{}
	res, err := client.Do(req)

	if err != nil {
		return err
	}

	defer res.Body.Close()

	fmt.Println(res.Body)

	return nil
}
