package discover

import (
	"bytes"
	"net"
	"strings"
	"time"
)

// Discover looks for new Devices on the local network
func Discover() ([]*net.IP, error) {
	search := []string{"M-SEARCH * HTTP/1.1", "HOST: 239.255.255.250:1900", "MAN: \"ssdp:discover\"", "MX: 3", "ST: home-automation:hub"}

	addr, err := net.ResolveUDPAddr("udp", ":1900")

	if err != nil {
		return nil, err
	}

	connection, err := net.ListenUDP("udp", addr)

	if err != nil {
		return nil, err
	}

	err = connection.SetReadDeadline(time.Now().Add(time.Second * 5))

	if err != nil {
		return nil, err
	}

	defer connection.Close()

	multicast, err := net.ResolveUDPAddr("udp", "239.255.255.250:1900")

	if err != nil {
		return nil, err
	}

	message := new(bytes.Buffer)
	message.WriteString(strings.Join(search, "\r\n"))

	_, err = connection.WriteTo(message.Bytes(), multicast)

	if err != nil {
		return nil, err
	}

	var devices []*net.IP

	for {
		buf := make([]byte, 1024)
		_, addr, err := connection.ReadFromUDP(buf)

		if err, ok := err.(net.Error); ok && err.Timeout() {
			return devices, nil
		}

		devices = append(devices, &addr.IP)
	}
}
