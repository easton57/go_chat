package db

import (
	"os"
	"fmt"
	"database/sql"
	"log/slog"

	_ "github.com/lib/pq"
)

// DB Struct
type DB struct {
	conn *sql.DB
	log *slog.Logger
}

// For creating a new database connection
func NewDB(connInfo string, logger *slog.Logger) (*DB, error) {
	logger.Info("* * * * * * * * * * * * * *")
	logger.Info("* Creating DB Connection *")
	logger.Info("* * * * * * * * * * * * * *")

	db, err := sql.Open("postgres", connInfo)	
	if err != nil {
		logger.Error("Couldn't connect to database!")
		return nil, err	
	}

	logger.Info("Connection to database opened")

	newDB := DB{conn: db, log: logger}

	// Verify connection
	_, err = newDB.HealthCheck()
	if err != nil {
		return nil, err
	}

	logger.Info("Database successfully connected")

	return &newDB, nil
}

func (db *DB) Close() error {
	return db.conn.Close()
}

// Check to see if the database is pingable
func (db *DB) HealthCheck() (bool, error) {
	db.log.Info("Pinging database...")
	err := db.conn.Ping()
	if err != nil {
		errorStr := "Unable to ping database: " + err.Error()
		db.log.Error(errorStr)
		return false, err
	}

	db.log.Info("Database pingable")

	return true, nil 
}

// Create the connection string
func GetConnInfo() string {
	host := "hermit-postgres-10.buffalo-anoles.ts.net"
	port := 5432
	user := os.Getenv("username")
	password := os.Getenv("password") 
	dbname := "go_chat"

	// Check for credentials and set if not there
	if user == "" || password == "" {
		setCredentials()
		user = os.Getenv("username")
		password = os.Getenv("password") 

	}

	psqlInfo := fmt.Sprintf("host=%s port=%d user=%s password=%s dbname=%s sslmode=disable", host, port, user, password, dbname)
	return psqlInfo
}

// TODO: error handling
func setCredentials() {
	var username string
	var password string

	fmt.Println("Credentials not found... Please enter username: ")
	fmt.Scan(&username)
	fmt.Println("Please enter password: ")
	fmt.Scan(&password)

	os.Setenv("username", username)
	os.Setenv("password", password)
}

