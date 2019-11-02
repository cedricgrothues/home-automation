package router

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"

	"github.com/cedricgrothues/home-automation/libraries/go/errors"
	"github.com/julienschmidt/httprouter"
)

// Mux is a wrapper around julienschmidt's httprouter.Router.
// It has some convenience functions.
type Mux struct {
	r *httprouter.Router
}

// New returns a new Router instance with some defaults
func New() Mux {
	r := httprouter.New()
	r.NotFound = http.HandlerFunc(errors.NotFound)
	r.MethodNotAllowed = http.HandlerFunc(errors.NotAllowed)
	r.PanicHandler = errors.PanicHandler

	return Mux{r}
}

// Serve runs ListenAndServe on Mux.Router
func (m *Mux) Serve(s string) error {
	res, err := http.Get("http://localhost:4001/config/" + s)

	if err != nil {
		panic(err)
	}

	r := make(map[string]interface{})

	defer res.Body.Close()

	bytes, err := ioutil.ReadAll(res.Body)

	if err != nil {
		panic(err)
	}

	err = json.Unmarshal(bytes, &r)

	if err != nil {
		panic(err)
	}

	err = http.ListenAndServe(fmt.Sprintf(":%d", r["port"]), m.r)

	return err
}

// GET is a shortcut for router.Handle(http.MethodGet, path, handle)
func (m *Mux) GET(path string, handle httprouter.Handle) {
	m.r.GET(path, handle)
}

// HEAD is a shortcut for router.Handle(http.MethodHead, path, handle)
func (m *Mux) HEAD(path string, handle httprouter.Handle) {
	m.r.HEAD(path, handle)
}

// OPTIONS is a shortcut for router.Handle(http.MethodOptions, path, handle)
func (m *Mux) OPTIONS(path string, handle httprouter.Handle) {
	m.r.OPTIONS(path, handle)
}

// POST is a shortcut for router.Handle(http.MethodPost, path, handle)
func (m *Mux) POST(path string, handle httprouter.Handle) {
	m.r.POST(path, handle)
}

// PUT is a shortcut for router.Handle(http.MethodPut, path, handle)
func (m *Mux) PUT(path string, handle httprouter.Handle) {
	m.r.PUT(path, handle)
}

// PATCH is a shortcut for router.Handle(http.MethodPatch, path, handle)
func (m *Mux) PATCH(path string, handle httprouter.Handle) {
	m.r.PATCH(path, handle)
}

// DELETE is a shortcut for router.Handle(http.MethodDelete, path, handle)
func (m *Mux) DELETE(path string, handle httprouter.Handle) {
	m.r.DELETE(path, handle)
}
