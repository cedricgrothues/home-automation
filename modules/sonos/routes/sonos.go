package routes

import (
	"net/http"
)

// GetState combines core.device-registry data, with device state
func GetState(w http.ResponseWriter, r *http.Request) {
	w.Header().Add("Content-Type", "application/json; charset=utf-8")
	w.WriteHeader(http.StatusFailedDependency)
	w.Write([]byte(`{"message":"Unable to contact the device."}`))
}

// PatchState updates a device state
func PatchState(w http.ResponseWriter, r *http.Request) {
	w.Header().Add("Content-Type", "application/json; charset=utf-8")
	w.WriteHeader(http.StatusServiceUnavailable)
	w.Write([]byte(`{"message":"Unable to contact the device."}`))
}
