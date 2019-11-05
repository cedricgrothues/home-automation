package main

import "github.com/cedricgrothues/home-automation/service.controller.sonos/dao"

func main() {
	sonos := dao.Sonos{Name: "AVTransport", Address: "192.168.2.103", Port: 1400}
	sonos.Stop()
}
