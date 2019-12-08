// Package discovery finds new sonos devices in the network to add them to the controller
package discovery

import (
	"bytes"
	"fmt"
	"github.com/cedricgrothues/home-automation/service.controller.sonos/dao"
	"net"
	"strings"
	"syscall"
	"time"
)

// **********************************************
// TODO: FIGURE OUT WHY WE CANT ESCAPE THIS LOOP
// **********************************************

// Discover looks for new Devices on the local network
func Discover() ([]*dao.Sonos, error) {
	search := []string{"M-SEARCH * HTTP/1.1", "HOST: 239.255.255.250:reservedSSDPport", "MAN: ssdp:discover", "MX: 1", "ST: urn:schemas-upnp-org:device:ZonePlayer:1"}

	message := new(bytes.Buffer)
	message.WriteString(strings.Join(search, "\r\n"))

	socket, err := syscall.Socket(syscall.AF_INET, syscall.SOCK_DGRAM, syscall.IPPROTO_UDP)

	if err != nil {
		return nil, err
	}

	err = syscall.SetsockoptInt(socket, syscall.IPPROTO_IP, syscall.IP_MULTICAST_TTL, 2)

	if err != nil {
		return nil, err
	}

	err = syscall.Sendto(socket, message.Bytes(), 0, &syscall.SockaddrInet4{
		Port: 1900,
		Addr: [4]byte{239, 255, 255, 250},
	})

	if err != nil {
		return nil, err
	}

	var speakers []*dao.Sonos

	buffer := make([]byte, 2048)
	for {
		timeout := syscall.NsecToTimeval(time.Nanosecond.Nanoseconds())

		err := syscall.Select(socket+1, nil, nil, nil, &timeout)

		if err != nil {
			break
		}

		_, addr, err := syscall.Recvfrom(socket, buffer, 0)

		if err != nil {
			break
		}

		a := addr.(*syscall.SockaddrInet4)

		fmt.Println(net.IPv4(a.Addr[0], a.Addr[1], a.Addr[2], a.Addr[3]).String())

		speakers = append(speakers, &dao.Sonos{Address: net.IPv4(a.Addr[0], a.Addr[1], a.Addr[2], a.Addr[3])})
	}

	return speakers, nil
}