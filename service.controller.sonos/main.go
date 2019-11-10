package main

import (
	"net/http"

	"github.com/cedricgrothues/home-automation/libraries/go/errors"
	"github.com/cedricgrothues/home-automation/service.controller.sonos/routes"
	"github.com/julienschmidt/httprouter"
)

func main() {
	// sonos := dao.Sonos{Address: "192.168.2.103"}

	router := httprouter.New()
	router.NotFound = http.HandlerFunc(errors.NotFound)
	router.MethodNotAllowed = http.HandlerFunc(errors.NotAllowed)
	router.PanicHandler = errors.PanicHandler

	router.GET("/devices/:id", routes.GetState)
	router.PATCH("/devices/:id", routes.PatchState)

	errors.Log("service.controller.sonos", "Failed to start with error:", http.ListenAndServe(":4003", router))

}
