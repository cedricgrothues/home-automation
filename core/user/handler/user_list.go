package handler

import (
	"database/sql"
	"encoding/json"
	"net/http"

	"github.com/cedricgrothues/httprouter"
)

// ListUsers returns all users from the database
func ListUsers(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	rows, err := Database.Query(`SELECT name FROM users`)

	defer rows.Close()

	if err != nil {
		if err != sql.ErrNoRows {
			print(err.Error())
		} else {
			w.Header().Add("Content-Type", "application/json; charset=utf-8")
			w.WriteHeader(http.StatusOK)
			w.Write([]byte(`[]`))
			return
		}
	}

	var users []string

	for rows.Next() {
		var name string
		rows.Scan(&name)

		users = append(users, name)
	}

	w.Header().Add("Content-Type", "application/json; charset=utf-8")
	w.WriteHeader(http.StatusOK)

	bytes, err := json.Marshal(users)

	if err != nil {
		panic("A problem occured while converting JSON: " + err.Error())
	}

	w.Write(bytes)
}
