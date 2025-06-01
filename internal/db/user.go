package db

import (
	"database/sql"

	"golang.org/x/crypto/bcrypt"
)

// TODO: Logging

func (db *DB) CreateUser(username string, password string, email string) (string, error) { 
	// Hash the password
	pass_hash, err := hashPassword(password)	
	if err != nil {
		// panic for now
		panic(err)
	}

	// Run the query
	result, err := db.conn.Query("SELECT create_user(%s, %s, %s);", username, pass_hash, email)	 
	if err != nil {
		panic(err)
	}

	// Convert to string
	jsonResult, err := convertSql(result)
	if err != nil {
		panic(err)
	}

	return jsonResult, err
}

func (db *DB) CheckPassword(username, password string) (string, error) {
	// Query the database
	result, err := db.conn.Query("SELECT login(%s);", username)
	if err != nil {
		panic(err)
	}

	// Convert to string
	jsonResult, err := convertSql(result)
	if err != nil {
		panic(err)
	}

	// Hash the password and compare to existing below is a work in progress
	hash := jsonResult
	err = checkPasswordHash(password, hash)
	if err != nil {
		// Password doesn't match
		panic(err)
	}

	return jsonResult, err
}

func convertSql(queryResult *sql.Rows) (string, error) {
	var jsonResult string
	err := queryResult.Scan(&jsonResult)
	
	return jsonResult, err
}

func hashPassword(password string) (string, error) {
	bytes, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)

	return string(bytes), err
}

func checkPasswordHash(password, hash string) error {
	err := bcrypt.CompareHashAndPassword([]byte(password), []byte(hash))
	return err
}
