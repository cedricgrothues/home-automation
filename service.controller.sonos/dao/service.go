package dao

import (
	"bytes"
	"fmt"
	"io/ioutil"
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
	Control string
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

	req, err := http.NewRequest("POST", fmt.Sprintf(`http://%s:%d%s`, s.Address, s.Port, s.Control), buffer)

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

	bodyBytes, err := ioutil.ReadAll(res.Body)

	fmt.Println(string(bodyBytes))

	return nil
}
