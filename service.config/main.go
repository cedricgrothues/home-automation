package main

import (
	"net/http"
	"strconv"
	"time"

	"github.com/cedricgrothues/home-automation/libraries/go/errors"
	"github.com/cedricgrothues/home-automation/service.config/config"
	"github.com/cedricgrothues/home-automation/service.config/routes"
	"github.com/julienschmidt/httprouter"
)

func main() {
	config := config.Config{
		Path: "./data/config.yaml",
	}

	err := config.Load()
	go config.Watch(time.Millisecond * time.Duration(300))

	if err != nil {
		panic("Could not load config")
	}

	router := httprouter.New()
	router.NotFound = http.HandlerFunc(errors.NotFound)
	router.MethodNotAllowed = http.HandlerFunc(errors.NotAllowed)
	router.PanicHandler = errors.PanicHandler

	handler := routes.Handler{Config: &config}

	router.GET("/config/:service", handler.GetConfig)

	self, err := config.Service("service.config")

	if err != nil {
		panic("Error reading own config")
	}

	port := strconv.Itoa(self["port"].(int))

	errors.Log(self["package"].(string), "Failed to start with error:", http.ListenAndServe(":"+port, router))

}
