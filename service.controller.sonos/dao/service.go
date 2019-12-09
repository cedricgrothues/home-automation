package dao

import (
	"bytes"
	"fmt"
	"io/ioutil"
	"net"
	"net/http"
)

var (
	DeviceService    = Service{Name: "DeviceProperties", Port: 1400, ControlURL: "/DeviceProperties/Control", EventURL: "/DeviceProperties/Event"}
	RenderingService = Service{Name: "RenderingControl", Port: 1400, ControlURL: "/MediaRenderer/RenderingControl/Control", EventURL: "/MediaRenderer/RenderingControl/Event"}
	TransportService = Service{Name: "AVTransport", Port: 1400, ControlURL: "/MediaRenderer/AVTransport/Control", EventURL: "/MediaRenderer/AVTransport/Event"}
	MusicService     = Service{Name: "MusicServices", Port: 1400, ControlURL: "/MusicServices/Control", EventURL: "/MusicServices/Event"}
)

// Sonos : Defines a speaker for the dao package
type Sonos struct {
	Address net.IP `json:"address"`
}

// Service : Defines a sevice in the dao package
type Service struct {
	Name       string
	Port       int
	ControlURL string
	EventURL   string
}

// Envelope : A response Envelope
type Envelope struct {
	TrackDuration string `xml:"Body>GetPositionInfoResponse>TrackDuration"`
	TrackMetaData string `xml:"Body>GetPositionInfoResponse>TrackMetaData"`
	TrackURI      string `xml:"Body>GetPositionInfoResponse>TrackURI"`
}

func (s *Service) request(address net.IP, a string, o map[string]interface{}) (string, error) {
	action := fmt.Sprintf(`"urn:schemas-upnp-org:service:%s:1#%s"`, s.Name, a)
	body := `<u:` + a + ` xmlns:u="urn:schemas-upnp-org:service:` + s.Name + `:1">`

	for k, v := range o {
		fmt.Println(k, v)
		body += fmt.Sprintf(`<%s>%v</%s>`, k, v, k)
	}

	body += fmt.Sprintf(`</u:%s>`, a)

	buffer := bytes.NewBufferString(fmt.Sprintf(`<?xml version="1.0" ?><s:Envelope s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xmlns:s="http://schemas.xmlsoap.org/soap/envelope/"><s:Body>%s</s:Body></s:Envelope>`, body))

	req, err := http.NewRequest("POST", fmt.Sprintf(`http://%s:%d%s`, address.String(), s.Port, s.ControlURL), buffer)

	if err != nil {
		return "", err
	}

	req.Header.Set("Content-Type", "text/xml; charset=utf8")
	req.Header.Set("SOAPAction", action)

	client := &http.Client{}
	res, err := client.Do(req)

	if err != nil {
		return "", err
	}

	defer res.Body.Close()

	bytes, err := ioutil.ReadAll(res.Body)

	if err != nil {
		return "", err
	}

	return string(bytes), nil
}
