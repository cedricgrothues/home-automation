package main

import (
	"net"
	"sync"

	"github.com/cedricgrothues/home-automation/service.advertise.ssdp/ssdp"
)

func main() {

	conn, err := net.Dial("udp", "8.8.8.8:80")

	if err != nil {
		panic("Could not find own IP address")
	}

	defer conn.Close()
	addr := conn.LocalAddr().(*net.UDPAddr)

	ad, err := ssdp.Advertise(
		"home-automation:hub",
		"hub:C02P-HPER-FVH3",
		"http://"+addr.IP.String()+":4000/",
		"https://github.com/cedricgrothues/home-automation",
		60,
	)

	if err != nil {
		panic(err)
	}

	var wg sync.WaitGroup
	wg.Add(1)
	wg.Wait()

	ad.Bye()
	ad.Close()
}
