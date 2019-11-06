package main

import (
	"github.com/cedricgrothues/home-automation/service.controller.sonos/dao"
)

func main() {
	sonos := dao.Sonos{Address: "192.168.2.103"}

	sonos.GetPositionInfo()
}
