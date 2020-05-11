package handler

import (
	"database/sql"
	"fmt"
	"net/http"

	"github.com/gorilla/mux"
)

// RemoveUser deletes a user from the database
func RemoveUser(w http.ResponseWriter, r *http.Request) {
	var id string
	vars := mux.Vars(r)

	err := Database.QueryRow("SELECT name FROM users WHERE name=$1", vars["id"]).Scan(&id)

	if err != nil {
		if err != sql.ErrNoRows {
			panic(err)
		} else {
			w.Header().Add("Content-Type", "application/json; charset=utf-8")
			w.WriteHeader(http.StatusNotFound)
			w.Write([]byte(fmt.Sprintf(`{"message":"User with name '%s' not found."}`, vars["id"])))
			return
		}
	}

	statement, err := Database.Prepare("DELETE FROM users WHERE name=$1")
	_, err = statement.Exec(vars["id"])

	defer statement.Close()

	if err != nil {
		panic(err)
	}

	w.WriteHeader(http.StatusNoContent)
}
