package main

import (
	"net"
	"os"
	"os/signal"
	"time"

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
		"hub:c01d7cf6-ec3f-47f0-9556-a5d6e9009a43",
		"http://"+addr.IP.String()+":4000/",
		"http://github.com/cedricgrothues/home-automation",
		60,
	)

	if err != nil {
		panic(err)
	}

	quit := make(chan os.Signal, 1)
	signal.Notify(quit, os.Interrupt)

	alive := time.Tick(300 * time.Second)

loop:
	for {
		select {
		case <-alive:
			ad.Alive()
		case <-quit:
			break loop
		}
	}

	ad.Bye()
	ad.Close()
}
