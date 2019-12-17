package main

import (
	"fmt"

	"github.com/cedricgrothues/home-automation/service.controller.sonos/discovery"
)

func main() {
	//router := httprouter.New()
	//
	//router.GET("/",func(w http.ResponseWriter, r *http.Request, params httprouter.Params) {
	//	w.Header().Add("Content-Type", "application/json; charset=utf-8")
	//	w.WriteHeader(http.StatusOK)
	//	w.Write([]byte(`{"name":"service.controller.sonos"}`))
	//})
	//
	//router.GET("/discover", routes.DiscoverDevices)
	//router.GET("/devices/:id", routes.GetState)
	//router.PATCH("/devices/:id", routes.PatchState)
	//
	//panic(http.ListenAndServe(":4003", router))

	devices, _ := discovery.Discover()

	for _, device := range devices {
		fmt.Println(device)
	}

	// sonos := dao.Sonos{Address: net.ParseIP("192.168.2.158")}

	// _, err = sonos.GetCurrentTrack()

	// if err != nil && err != io.EOF {
	// 	panic(err)
	// }

	// err = sonos.Seek("00:01:01")

	// if err != nil {
	// 	panic(err)
	// }
}
