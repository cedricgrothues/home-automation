package main

import (
	"net/http"

	"github.com/cedricgrothues/home-automation/libraries/go/errors"
	"github.com/cedricgrothues/home-automation/service.controller.sonoff/routes"
	"github.com/julienschmidt/httprouter"
)

func main() {
	router := httprouter.New()
	router.NotFound = http.HandlerFunc(errors.NotFound)
	router.MethodNotAllowed = http.HandlerFunc(errors.NotAllowed)
	router.PanicHandler = errors.PanicHandler

	router.GET("/devices/:id", routes.GetState)
	router.PATCH("/devices/:id", routes.PatchState)

	errors.Log("service.device-registry", "Failed to start with error:", http.ListenAndServe(":4002", router))
}
