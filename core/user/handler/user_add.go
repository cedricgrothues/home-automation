package handler

import (
	"database/sql"
	"encoding/json"
	"net/http"
	"regexp"
)

// Database instance
var Database *sql.DB

// AddUser persists a new user in the database
func AddUser(w http.ResponseWriter, r *http.Request) {
	user := struct {
		Name string `json:"name"`
	}{}

	err := json.NewDecoder(r.Body).Decode(&user)

	if err != nil {
		panic(err)
	}

	if match, _ := regexp.MatchString(`^[a-zA-Z ]+$`, user.Name); !match {
		w.Header().Add("Content-Type", "application/json; charset=utf-8")
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte(`{"message":"ID contains invalid characters, refer to the documentation for more information."}`))
		return
	}

	stmnt, err := Database.Prepare("INSERT INTO users(name) values($1)")
	defer stmnt.Close()

	if err != nil {
		panic(err)
	}

	_, err = stmnt.Exec(user.Name)

	if err != nil {
		panic(err)
	}

	w.Header().Add("Content-Type", "application/json; charset=utf-8")
	w.WriteHeader(http.StatusCreated)

	bytes, err := json.Marshal(user)

	if err != nil {
		panic("A problem occured while converting JSON: " + err.Error())
	}

	w.Write(bytes)
}
