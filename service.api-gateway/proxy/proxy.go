package proxy

import (
	"fmt"
	"net/http"
	"net/http/httputil"
	"net/url"
	"strings"

	"github.com/cedricgrothues/home-automation/libraries/go/bootstrap"
	"github.com/cedricgrothues/home-automation/service.api-gateway/routing"
	"github.com/cedricgrothues/httprouter"
)

// ListenAndServe provides the config to the client
func ListenAndServe(c *routing.Configuration) error {
	router, err := bootstrap.New("service.api-gateway")

	if err != nil {
		return err
	}

	for _, service := range c.Services {
		url, err := url.Parse(service.Upstream)
		if err != nil {
			return err
		}

		p := httputil.NewSingleHostReverseProxy(url)

		prefix := addSlashes(service.Prefix)

		router.GET(prefix+"*s", handler(prefix, p))
		router.PUT(prefix+"*s", handler(prefix, p))
		router.POST(prefix+"*s", handler(prefix, p))
		router.PATCH(prefix+"*s", handler(prefix, p))
		router.DELETE(prefix+"*s", handler(prefix, p))
	}

	return http.ListenAndServe(port(c.Port), router)
}

func port(p int) string {
	if p == 0 {
		return fmt.Sprintf(":%d", 80)
	}
	return fmt.Sprintf(":%d", p)
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
			httprouter.NotFound(w, r)
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
