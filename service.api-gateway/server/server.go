package server

import (
	"fmt"
	"github.com/cedricgrothues/httprouter"
	"net/http"
	"net/http/httputil"
	"net/url"
	"strings"

	"github.com/cedricgrothues/home-automation/service.api-gateway/config"
)

// ListenAndServe provides the config to the client
func ListenAndServe(c *config.Configuration) error {
	router := httprouter.New()
	for _, service := range c.Services {
		url, err := url.Parse(service.URL)
		if err != nil {
			return err
		}

		p := httputil.NewSingleHostReverseProxy(url)

		prefix := addSlashes(service.Prefix)

		router.GET(prefix+"*service", handler(prefix, p))
	}

	return http.ListenAndServe(fmt.Sprintf(":%d", c.Port), router)
}

func handler(prefix string, proxy *httputil.ReverseProxy) func(http.ResponseWriter, *http.Request, httprouter.Params) {
	return func(w http.ResponseWriter, r *http.Request, params httprouter.Params) {
		if p := strings.TrimPrefix(r.URL.Path, prefix); len(p) < len(r.URL.Path) {
			r2 := new(http.Request)
			*r2 = *r
			r2.URL = new(url.URL)
			*r2.URL = *r.URL
			r2.URL.Path = p

			proxy.ServeHTTP(w, r2)
		} else {
			w.Header().Add("Content-Type", "application/json; charset=utf-8")
			w.WriteHeader(http.StatusNotFound)
			w.Write([]byte(`{"message":"Page ` + r.URL.Path + ` not found"}`))
		}
	}
}

func addSlashes(s string) string {
	preSlash := strings.HasPrefix(s, "/")
	postSlash := strings.HasSuffix(s, "/")
	switch {
	case preSlash && postSlash:
		return s
	case !preSlash && postSlash:
		return "/" + s
	case preSlash && !postSlash:
		return s + "/"
	}
	return "/" + s + "/"
}
