package main

import (
	"github.com/cedricgrothues/home-automation/libraries/go/bootstrap"
	"github.com/cedricgrothues/home-automation/service.controller.sonoff/routes"
)

func main() {
	router, err := bootstrap.New("service.controller.sonoff")

	if err != nil {
		panic(err)
	}

	router.GET("/devices/:id", routes.GetState)
	router.PATCH("/devices/:id", routes.PatchState)

	panic(bootstrap.Start(router, 4002))
}
