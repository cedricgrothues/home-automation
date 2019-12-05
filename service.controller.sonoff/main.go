package main

import (
	"net/http"

	"github.com/cedricgrothues/home-automation/libraries/go/errors"
	"github.com/cedricgrothues/home-automation/service.controller.sonoff/routes"
	"github.com/cedricgrothues/httprouter"
)

func main() {
	router := httprouter.New()

	router.GET("/",func(w http.ResponseWriter, r *http.Request, params httprouter.Params) {
		w.Header().Add("Content-Type", "application/json; charset=utf-8")
		w.WriteHeader(http.StatusOK)
		w.Write([]byte(`{"name":"service.controller.sonoff"}`))
	})

	router.GET("/devices/:id", routes.GetState)
	router.PATCH("/devices/:id", routes.PatchState)

	errors.Log("service.controller.sonoff", "Failed to start with error:", http.ListenAndServe(":4002", router))
}
