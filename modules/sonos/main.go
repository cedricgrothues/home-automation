package main

import (
	"net/http"

	"github.com/cedricgrothues/home-automation/modules/sonos/routes"
	"github.com/gorilla/mux"
)

func main() {
	router := mux.NewRouter()

	router.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Add("Content-Type", "application/json; charset=utf-8")
		w.WriteHeader(http.StatusOK)
		w.Write([]byte(`{"name":"modules.sonos"}`))
	}).Methods(http.MethodGet)

	router.HandleFunc("/devices/:id", routes.GetState).Methods(http.MethodGet)
	router.HandleFunc("/devices/:id", routes.PatchState).Methods(http.MethodPut)

	panic(http.ListenAndServe(":4004", router))

	// sonos := dao.Sonos{Address: net.ParseIP("192.168.2.158")}

	// _, err = sonos.GetCurrentTrack()

	// if err != nil && err != io.EOF {
	// 	panic(err)
	// }

	// err = sonos.Seek("00:01:01")

	// if err != nil {
	// 	panic(err)
	// }
}
