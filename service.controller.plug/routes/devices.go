package routes

import (
	"net/http"

	"github.com/julienschmidt/httprouter"
)

// GetState combines service.device-registry data, with device state
func GetState(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	w.WriteHeader(http.StatusNoContent)
}

// PatchState updates a device state
func PatchState(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	w.WriteHeader(http.StatusNoContent)
}
