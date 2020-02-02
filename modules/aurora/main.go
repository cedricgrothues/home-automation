package main

import (
	"github.com/cedricgrothues/home-automation/libraries/go/bootstrap"
	"github.com/cedricgrothues/home-automation/modules/aurora/routes"
)

func main() {
	router, err := bootstrap.New("modules.aurora")

	if err != nil {
		panic(err)
	}

	router.GET("/devices/:id", routes.GetState)
	router.PUT("/devices/:id", routes.PutState)

	panic(bootstrap.Start(router, 4005))
}
