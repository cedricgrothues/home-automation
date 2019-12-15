package bootstrap

import (
	"encoding/json"
	"fmt"
	"net/http"

	"github.com/cedricgrothues/httprouter"
)

type service struct {
	Name string `json:"name"`
}

// New creates a new bootstrap
func New(name string) (*httprouter.Router, error) {
	router := httprouter.New()

	router.GET("/", func(w http.ResponseWriter, r *http.Request, params httprouter.Params) {
		bytes, err := json.Marshal(service{Name: name})

		if err != nil {
			w.Header().Add("Content-Type", "application/json; charset=utf-8")
			w.WriteHeader(http.StatusInternalServerError)
			return
		}

		w.Header().Add("Content-Type", "application/json; charset=utf-8")
		w.WriteHeader(http.StatusOK)
		w.Write(bytes)
	})

	return router, nil
}

// Start a new service
func Start(router *httprouter.Router, port int) error {
	return http.ListenAndServe(fmt.Sprintf(":%d", port), router)
}
