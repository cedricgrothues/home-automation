package database

import (
	"database/sql"

	_ "github.com/mattn/go-sqlite3"
)

type Database struct {
	d *sql.DB
}

func Open() {

}
