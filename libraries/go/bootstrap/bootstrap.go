package bootstrap

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"

	"github.com/gorilla/mux"
)

type service struct {
	Name string `json:"name"`
}

// New creates a new bootstrap
func New(name string) (*mux.Router, error) {
	router := mux.NewRouter()

	router.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		bytes, err := json.Marshal(service{Name: name})

		if err != nil {
			w.Header().Add("Content-Type", "application/json; charset=utf-8")
			w.WriteHeader(http.StatusInternalServerError)
			return
		}

		w.Header().Add("Content-Type", "application/json; charset=utf-8")
		w.WriteHeader(http.StatusOK)
		w.Write(bytes)
	}).Methods(http.MethodGet)

	return router, nil
}

// Start a new service
func Start(router *mux.Router, port int) error {
	log.Println("Starting service on port ", port)

	return http.ListenAndServe(fmt.Sprintf(":%d", port), router)
}
