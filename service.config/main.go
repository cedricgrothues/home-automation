package main

import (
	"fmt"
	"time"

	"github.com/cedricgrothues/home-automation/service.config/handler"
)

func main() {
	// router := httprouter.New()
	// router.NotFound = http.HandlerFunc(errors.NotFound)
	// router.MethodNotAllowed = http.HandlerFunc(errors.NotAllowed)
	// router.PanicHandler = errors.PanicHandler

	// info := readme.Info{Name: "service.config", Friendly: "Config Service"}
	// router.GET("/", info.Get)

	// router.GET("/devices/:id", routes.GetState)
	// router.PATCH("/devices/:id", routes.PatchState)

	// errors.Log("service.controller.sonoff", "Failed to start with error:", http.ListenAndServe(":4002", router))

	handler := handler.ConfigHandler{
		Path: "data/dev.config.json",
	}

	err := handler.Read()

	if err != nil {
		panic(err)
	}

	handler.Watch(time.Minute / 4)

	fmt.Println(handler.Config.Version)
}
