package main

import (
	"net/http"

	"github.com/cedricgrothues/home-automation/libraries/go/errors"
	"github.com/cedricgrothues/home-automation/libraries/go/readme"
	"github.com/cedricgrothues/home-automation/service.controller.sonos/routes"
	"github.com/cedricgrothues/httprouter"
)

func main() {
	router := httprouter.New()

	info := readme.Info{Name: "service.controller.sonos", Friendly: "Sonos Controller"}
	router.GET("/", info.Get)

	router.GET("/devices/:id", routes.GetState)
	router.PATCH("/devices/:id", routes.PatchState)

	errors.Log("service.controller.sonos", "Failed to start with error:", http.ListenAndServe(":4003", router))

}
