package main

import (
	"log"
	"os"

	"github.com/cedricgrothues/home-automation/core/api-gateway/proxy"
	"github.com/cedricgrothues/home-automation/core/api-gateway/routing"
)

func main() {
	if len(os.Args) < 2 {
		os.Exit(1)
	}

	c, err := routing.Load(os.Args[1])
	if err != nil {
		log.Panicf("Failed to load config: %v", err)
	}

	panic(proxy.ListenAndServe(c))
}
