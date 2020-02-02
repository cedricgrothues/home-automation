package main

import (
	"net/http"

	"github.com/cedricgrothues/home-automation/modules/sonos/routes"
	"github.com/cedricgrothues/httprouter"
)

func main() {
	router := httprouter.New()

	router.GET("/", func(w http.ResponseWriter, r *http.Request, params httprouter.Params) {
		w.Header().Add("Content-Type", "application/json; charset=utf-8")
		w.WriteHeader(http.StatusOK)
		w.Write([]byte(`{"name":"modules.sonos"}`))
	})

	router.GET("/devices/:id", routes.GetState)
	router.PUT("/devices/:id", routes.PatchState)

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
