package main

import (
	"net/http"

	"github.com/cedricgrothues/home-automation/libraries/go/errors"
	"github.com/cedricgrothues/home-automation/libraries/go/readme"
	"github.com/cedricgrothues/home-automation/libraries/go/registrar"
	"github.com/cedricgrothues/home-automation/service.controller.sonoff/routes"
	"github.com/julienschmidt/httprouter"
)

func main() {
	router := httprouter.New()
	router.NotFound = http.HandlerFunc(errors.NotFound)
	router.MethodNotAllowed = http.HandlerFunc(errors.NotAllowed)
	router.PanicHandler = errors.PanicHandler

	info := readme.Info{Name: "service.controller.sonoff", Friendly: "Sonoff Controller"}
	router.GET("/", info.Get)

	router.GET("/devices/:id", routes.GetState)
	router.PATCH("/devices/:id", routes.PatchState)

	err := registrar.Register("service.controller.sonoff", 4002)

	if err != nil {
		panic(err)
	}

	defer func() {
		err := registrar.Unregister("service.controller.sonoff")
		if err != nil {
			panic(err)
		}
	}()

	errors.Log("service.controller.sonoff", "Failed to start with error:", http.ListenAndServe(":4002", router))
}
