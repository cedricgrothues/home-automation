package errors

import (
	"fmt"
	"net/http"
	"os"
)

// Handle panics if the error e is not nil
func Handle(e error) {
	if e != nil {
		panic(e)
	}
}

// Log service, message and error and exit with exit code 1
func Log(s string, m string, e error) {
	fmt.Printf("\n\x1b[31m[%v]\x1b[0m %s %v", s, m, e)
	os.Exit(1)
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

// PanicHandler handles internal server errors
func PanicHandler(w http.ResponseWriter, r *http.Request, p interface{}) {
	fmt.Print(p)
	w.Header().Add("Content-Type", "application/json; charset=utf-8")
	w.WriteHeader(http.StatusInternalServerError)
	w.Write([]byte(`{"message":"` + p.(error).Error() + `"}`))
}
