package readme

import (
	"encoding/json"
	"net/http"

	"github.com/cedricgrothues/httprouter"
)

// Info returns service info
type Info struct {
	Name     string `json:"name"`
	Friendly string `json:"friendly"`
}

// Get returns the service info
func (i *Info) Get(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	w.Header().Add("Content-Type", "application/json; charset=utf-8")
	w.WriteHeader(http.StatusOK)

	bytes, err := json.Marshal(i)

	if err != nil {
		panic("A problem occured while converting JSON: " + err.Error())
	}

	w.Write(bytes)
}
