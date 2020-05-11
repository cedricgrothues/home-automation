package main

import (
	"net/http"

	"github.com/cedricgrothues/home-automation/libraries/go/bootstrap"
	"github.com/cedricgrothues/home-automation/modules/aurora/routes"
)

func main() {
	router, err := bootstrap.New("modules.aurora")

	if err != nil {
		panic(err)
	}

	router.HandleFunc("/devices/{id}", routes.GetState).Methods(http.MethodGet)
	router.HandleFunc("/devices/{id}", routes.PutState).Methods(http.MethodPut)

	panic(bootstrap.Start(router, 4005))
}
