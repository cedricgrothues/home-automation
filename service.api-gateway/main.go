package main

import (
	"log"
	"os"

	"github.com/cedricgrothues/home-automation/service.api-gateway/config"
	"github.com/cedricgrothues/home-automation/service.api-gateway/server"
)

func main() {
	if len(os.Args) < 2 {
		panic("Usage: gateway /path/to/config.yml")
	}

	c, err := config.Load(os.Args[1])
	if err != nil {
		log.Panicf("Failed to load config: %v", err)
	}

	panic(server.ListenAndServe(c))
}
