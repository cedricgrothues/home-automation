package main

import (
	"net/http"

	"github.com/cedricgrothues/home-automation/libraries/go/bootstrap"
	"github.com/cedricgrothues/home-automation/modules/_sonoff/routes"
)

func main() {
	router, err := bootstrap.New("modules.sonoff")

	if err != nil {
		panic(err)
	}

	router.HandleFunc("/devices/:id", routes.GetState).Methods(http.MethodGet)
	router.HandleFunc("/devices/:id", routes.PutState).Methods(http.MethodPatch)

	panic(bootstrap.Start(router, 4003))
}
