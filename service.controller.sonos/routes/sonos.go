package routes

import (
	"net/http"

	"github.com/cedricgrothues/httprouter"
)

/* GET STATE -> JSON
- id, name, ip,
- state
	- current_track: song_uid1wjh24uz282
	- volume:
		- min: 0
		- max: 10
		- value: 5
	- service: Apple Music / Spotify
	- artist:
*/

// GetState combines service.device-registry data, with device state
func GetState(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	w.Header().Add("Content-Type", "application/json; charset=utf-8")
	w.WriteHeader(http.StatusFailedDependency)
	w.Write([]byte(`{"message":"Unable to contact the device."}`))
}

// PatchState updates a device state
func PatchState(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	w.Header().Add("Content-Type", "application/json; charset=utf-8")
	w.WriteHeader(http.StatusServiceUnavailable)
	w.Write([]byte(`{"message":"Unable to contact the device."}`))
}
