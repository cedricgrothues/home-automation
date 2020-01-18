package main

import (
	"github.com/cedricgrothues/home-automation/libraries/go/bootstrap"
	"github.com/cedricgrothues/home-automation/service.controller.aurora/routes"
)

func main() {
	router, err := bootstrap.New("service.controller.aurora")

	if err != nil {
		panic(err)
	}

	router.GET("/discover", routes.DiscoverDevices)

	router.GET("/devices/:id", routes.GetState)
	router.PUT("/devices/:id", routes.PutState)

	panic(bootstrap.Start(router, 4004))
}
