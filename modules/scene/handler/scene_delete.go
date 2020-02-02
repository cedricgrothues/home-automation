package handler

import (
	"database/sql"
	"fmt"
	"net/http"

	"github.com/cedricgrothues/httprouter"
)

// DeleteScene removes the scene from the database
func DeleteScene(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	var id string

	err := Database.QueryRow("SELECT id FROM scenes WHERE id=$1", p[0].Value).Scan(&id)

	if err != nil {
		if err != sql.ErrNoRows {
			panic(err)
		} else {
			w.Header().Add("Content-Type", "application/json; charset=utf-8")
			w.WriteHeader(http.StatusNotFound)
			w.Write([]byte(fmt.Sprintf(`{"message":"Scene with ID '%s' not found."}`, p[0].Value)))
			return
		}
	}

	statement, err := Database.Prepare("DELETE FROM actions WHERE scene_id=$1")
	_, err = statement.Exec(p[0].Value)

	defer statement.Close()

	if err != nil {
		panic(err)
	}

	statement, err = Database.Prepare("DELETE FROM scenes WHERE id=$1")
	_, err = statement.Exec(p[0].Value)

	defer statement.Close()

	if err != nil {
		panic(err)
	}

	w.WriteHeader(http.StatusNoContent)
}
