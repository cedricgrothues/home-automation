package routes

import (
	"encoding/json"
	"net/http"
	"regexp"

	"github.com/cedricgrothues/home-automation/libraries/go/errors"
	"github.com/cedricgrothues/home-automation/service.config/config"
	"github.com/julienschmidt/httprouter"
)

// Handler holds a pointer to our config reference
type Handler struct {
	Config *config.Config
}

// GetConfig handles incoming requestest to /config/:service
func (h *Handler) GetConfig(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	if match, _ := regexp.MatchString(`^[A-Za-z0-9.]+$`, p[0].Value); !match {
		w.Header().Add("Content-Type", "application/json; charset=utf-8")
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte(`{"message":"Service name contains invalid characters, refer to the documentation for more information."}`))
		return
	}

	service, err := h.Config.Service(p[0].Value)
	if err != nil {
		if err.Error() == "no config for service" {
			w.Header().Add("Content-Type", "application/json; charset=utf-8")
			w.WriteHeader(http.StatusNotFound)
			w.Write([]byte(`{"message":"Service '` + p[0].Value + `' not found."}`))
			return
		}
		errors.Handle(err)
	}

	bytes, err := json.Marshal(service)
	errors.Handle(err)

	w.Header().Add("Content-Type", "application/json; charset=utf-8")
	w.WriteHeader(http.StatusOK)

	w.Write(bytes)
}
