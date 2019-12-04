package server

import (
	"fmt"
	"net/http"
	"net/url"

	"github.com/cedricgrothues/home-automation/service.api-gateway/config"
	"github.com/cedricgrothues/home-automation/service.api-gateway/proxy"
	"github.com/cedricgrothues/home-automation/service.api-gateway/utils"
)

// ListenAndServe provides the config to the client
func ListenAndServe(c *config.Configuration) error {
	router := http.NewServeMux()
	for _, service := range c.Services {
		url, err := url.Parse(service.URL)
		if err != nil {
			return err
		}

		p := proxy.New(url)

		prefix := utils.AddSlashes(service.Prefix)
		h := http.StripPrefix(prefix, p)

		router.Handle(prefix, h)
	}

	return http.ListenAndServe(fmt.Sprintf(":%d", c.Port), router)
}
