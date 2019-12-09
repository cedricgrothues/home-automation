// Package discovery finds new sonos devices in the network to add them to the controller
package discovery

import (
	"bytes"
	"encoding/xml"
	"net"
	"net/http"
	"strings"
	"time"
)

type Sonos struct {
	Address net.IP `json:"address"`
	Friendly string `xml:"device>displayName" json:"friendly"`
}

// Discover looks for new Devices on the local network
func Discover(c chan *Sonos, e chan error, d chan bool) {
	search := []string{"M-SEARCH * HTTP/1.1", "HOST: 239.255.255.250:1900", "MAN: \"ssdp:discover\"", "MX: 1", "ST: urn:schemas-upnp-org:device:ZonePlayer:1"}

	addr, err := net.ResolveUDPAddr("udp", ":1900")

	if err != nil {
		e <- err
		return
	}

	connection, err := net.ListenUDP("udp", addr)

	if err != nil {
		e <- err
		return
	}

	err = connection.SetReadDeadline(time.Now().Add(time.Second * 5))

	if err != nil {
		e <- err
		return
	}

	defer connection.Close()

	multicast, err := net.ResolveUDPAddr("udp", "239.255.255.250:1900")

	if err != nil {
		e <- err
		return
	}

	message := new(bytes.Buffer)
	message.WriteString(strings.Join(search, "\r\n"))

	_, err = connection.WriteTo(message.Bytes(), multicast)

	if err != nil {
		e <- err
		return
	}

	for {
		buf := make([]byte, 1024)
		_, addr, err := connection.ReadFromUDP(buf)
		if err, ok := err.(net.Error); ok && err.Timeout() {
			d <- true
			break
		}

		sonos := Sonos{
			Address: addr.IP,
		}

		res, err := http.Get("http://" + sonos.Address.String() + ":1400/xml/device_description.xml")

		if err != nil {
			e <- err
			break
		}

		err = xml.NewDecoder(res.Body).Decode(&sonos)
		res.Body.Close()

		if err != nil {
			e <- err
			break
		}

		c <- &sonos
	}
}
