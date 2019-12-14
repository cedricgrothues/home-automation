package server

import (
	"context"
	"fmt"
	"github.com/cedricgrothues/httprouter"
	"net/http"
	"net/http/httputil"
	"net/url"
	"os"
	"os/signal"
	"strings"
	"syscall"
	"time"

	"github.com/cedricgrothues/home-automation/service.api-gateway/config"
)

// ListenAndServe provides the config to the client
func ListenAndServe(c *config.Configuration) error {
	router := httprouter.New()

	router.GET("/", func(w http.ResponseWriter, r *http.Request, params httprouter.Params) {
		w.Header().Add("Content-Type", "application/json; charset=utf-8")
		w.WriteHeader(http.StatusOK)
		w.Write([]byte(`{"name":"service.api-gateway"}`))
	})

	for _, service := range c.Services {
		url, err := url.Parse(service.URL)
		if err != nil {
			return err
		}

		p := httputil.NewSingleHostReverseProxy(url)

		prefix := addSlashes(service.Prefix)

		router.GET(prefix+"*service", handler(prefix, p))
		router.POST(prefix+"*service", handler(prefix, p))
		router.DELETE(prefix+"*service", handler(prefix, p))
		router.PATCH(prefix+"*service", handler(prefix, p))
	}

	server := &http.Server{Addr: fmt.Sprintf(":%d", c.Port), Handler: router}

	go run(server)
	graceful(server, time.Second*5)

	return nil
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

func run(server *http.Server) {
	if err := server.ListenAndServe(); err != http.ErrServerClosed {
		panic(err)
	}
}

func graceful(server *http.Server, timeout time.Duration) {
	stop := make(chan os.Signal, 1)

	signal.Notify(stop, os.Interrupt, syscall.SIGTERM)

	<-stop

	ctx, cancel := context.WithTimeout(context.Background(), timeout)
	defer cancel()

	if err := server.Shutdown(ctx); err != nil {
		panic(err)
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
