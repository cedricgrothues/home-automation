package main

import (
	"fmt"
	"github.com/cedricgrothues/home-automation/service.controller.sonos/discovery"
	"log"
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
	//router.GET("/devices/:id", routes.GetState)
	//router.PATCH("/devices/:id", routes.PatchState)
	//
	//panic(http.ListenAndServe(":4003", router))

	speakers, err := discovery.Discover()

	if err != nil {
		log.Fatal(err)
	}

	for i, speaker := range speakers {
		fmt.Printf("%d: %s", i, speaker.Address.String())
	}
}
