package dao

import (
	"bytes"
	"encoding/xml"
	"fmt"
	"io/ioutil"
	"net/http"
	"net/url"
)

// Sonos :
type Sonos struct {
	Address string
}

// Service :
type Service struct {
	Name       string
	Address    string
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

func (s *Service) request(a string, o map[string]interface{}) error {
	action := fmt.Sprintf(`"urn:schemas-upnp-org:service:%s:1#%s"`, s.Name, a)
	body := `<u:` + a + ` xmlns:u="urn:schemas-upnp-org:service:` + s.Name + `:1">`

	for k, v := range o {
		fmt.Println(k, v)
		body += fmt.Sprintf(`<%s>%v</%s>`, k, v, k)
	}

	body += fmt.Sprintf(`</u:%s>`, a)

	buffer := bytes.NewBufferString(fmt.Sprintf(`<?xml version="1.0" ?><s:Envelope s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/" xmlns:s="http://schemas.xmlsoap.org/soap/envelope/"><s:Body>%s</s:Body></s:Envelope>`, body))

	req, err := http.NewRequest("POST", fmt.Sprintf(`http://%s:%d%s`, s.Address, s.Port, s.ControlURL), buffer)

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

	bytes, err := ioutil.ReadAll(res.Body)

	if err != nil {
		return err
	}

	var XML Envelope
	xml.Unmarshal(bytes, &XML)

	fmt.Println(XML.TrackMetaData)
	str, err := url.QueryUnescape(string(bytes))
	fmt.Println("\n\n\n\n" + str)

	return nil
}
