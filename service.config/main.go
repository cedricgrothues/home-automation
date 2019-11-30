package main

import (
	"fmt"
	"net/http"
	"time"

	"github.com/cedricgrothues/home-automation/libraries/go/errors"
	"github.com/cedricgrothues/home-automation/libraries/go/readme"
	"github.com/cedricgrothues/home-automation/service.config/handler"
	"github.com/julienschmidt/httprouter"
)

func main() {

	config, err := handler.Read("./data/config.json")

	if err != nil {
		panic(err)
	}

	if config.Polling.Enabled {
		fmt.Printf("Reloading config every %d milliseconds (%d seconds)\n", config.Polling.Interval, config.Polling.Interval/1000)
		go config.Watch(time.Millisecond * time.Duration(config.Polling.Interval))
	}

	self, err := config.Get("service.config")

	if err != nil {
		panic("Failed to get own config with error: " + err.Error())
	}

	router := httprouter.New()
	router.NotFound = http.HandlerFunc(errors.NotFound)
	router.MethodNotAllowed = http.HandlerFunc(errors.NotAllowed)
	router.PanicHandler = errors.PanicHandler

	info := readme.Info{Name: self.Identifier, Friendly: self.Friendly}
	router.GET("/", info.Get)

	router.GET("/read/:id", config.ReadConfig)
	router.GET("/reload", config.ReloadConfig)

	errors.Log("service.config", "Failed to start with error:", http.ListenAndServe(fmt.Sprintf(":%d", self.Port), router))
}
