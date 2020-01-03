package main

import (
	"fmt"

	"github.com/cedricgrothues/home-automation/service.controller.aurora/discover"
)

func main() {
	addresses, err := discover.Discover()

	if err != nil {
		panic(err)
	}

	for _, ip := range addresses {
		fmt.Println(ip)
	}
}
