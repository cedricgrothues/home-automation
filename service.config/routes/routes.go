package routes

import (
	"encoding/json"
	"net/http"

	"github.com/cedricgrothues/home-automation/service.config/handler"
	"github.com/julienschmidt/httprouter"
)

// ConfigHandler handles config loading / watching
type ConfigHandler struct {
	Path   string
	Config *handler.Config
}

// ReadConfig returns a config for a givend device
func ReadConfig(w http.ResponseWriter, r *http.Request, p httprouter.Params) {

	w.Header().Add("Content-Type", "application/json; charset=utf-8")
	w.WriteHeader(http.StatusOK)

	bytes, err := json.Marshal("")

	if err != nil {
		panic("A problem occured while converting JSON: " + err.Error())
	}

	w.Write(bytes)
}

// ReloadConfig reloads the config
func (h *ConfigHandler) ReloadConfig(w http.ResponseWriter, r *http.Request, p httprouter.Params) {

	err := h.
		w.Header().Add("Content-Type", "application/json; charset=utf-8")
	w.WriteHeader(http.StatusOK)

	bytes, err := json.Marshal("{\"message\": \"config file reloaded successfully\"}")

	if err != nil {
		panic("A problem occured while converting JSON: " + err.Error())
	}

	w.Write(bytes)
}
