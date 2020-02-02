package main

import (
	"github.com/cedricgrothues/home-automation/libraries/go/bootstrap"
	"github.com/cedricgrothues/home-automation/modules/sonoff/routes"
)

func main() {
	router, err := bootstrap.New("modules.sonoff")

	if err != nil {
		panic(err)
	}

	router.GET("/devices/:id", routes.GetState)
	router.PUT("/devices/:id", routes.PutState)

	panic(bootstrap.Start(router, 4003))
}
