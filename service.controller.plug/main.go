package main

import (
	"fmt"
	"log"
	"net/http"

	"github.com/cedricgrothues/home-automation/service.controller.plug/routes"
	"github.com/julienschmidt/httprouter"
)

func main() {
	router := httprouter.New()
	router.HandleMethodNotAllowed = true
	router.NotFound = http.HandlerFunc(NotFound)
	router.MethodNotAllowed = http.HandlerFunc(NotAllowed)
	router.PanicHandler = PanicHandler

	router.GET("/devices/:id", routes.GetState)
	router.PATCH("/devices/:id", routes.PatchState)

	log.Fatalf("\n\x1b[31m[%v]\x1b[0m %s %v", "service.device-registry", "Failed to start with error:", http.ListenAndServe(":4001", router))
}

// NotFound : HTTP handler that is called if no matching route is found
func NotFound(w http.ResponseWriter, r *http.Request) {
	w.Header().Add("Content-Type", "application/json; charset=utf-8")
	w.WriteHeader(http.StatusNotFound)
	w.Write([]byte(`{"message":"Page ` + r.URL.Path + ` not found"}`))
}

// NotAllowed : HTTP handler that is called if the current method is not allowed
func NotAllowed(w http.ResponseWriter, r *http.Request) {
	w.Header().Add("Content-Type", "application/json; charset=utf-8")
	w.WriteHeader(http.StatusMethodNotAllowed)
	w.Write([]byte(`{"message":"Method ` + r.Method + ` not allowed"}`))
}

// PanicHandler handles panic calls with internal server errors
func PanicHandler(w http.ResponseWriter, r *http.Request, p interface{}) {
	fmt.Print(p)
	w.Header().Add("Content-Type", "application/json; charset=utf-8")
	w.WriteHeader(http.StatusInternalServerError)
	w.Write([]byte(`{"message":"` + p.(error).Error() + `"}`))
}
