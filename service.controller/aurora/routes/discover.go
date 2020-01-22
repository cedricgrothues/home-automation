package routes

import (
	"net/http"

	"github.com/cedricgrothues/httprouter"
)

// DiscoverDevices returns all devices found this service's network, using ssdp discovery
func DiscoverDevices(w http.ResponseWriter, r *http.Request, p httprouter.Params) {

}
