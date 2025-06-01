package main

import (
	"log/slog"
	"net/http"
	"os"

	"github.com/easton57/go_chat/internal/db"
	"github.com/easton57/go_chat/internal/handlers"
)

func main() {
	// Initialize main logger
	logger := createLogConfig("go_chat.log")	
	slog.SetDefault(logger)
	slog.Info("* * * * * * * * * * *")
	slog.Info("* Starting go_chat! *")
	slog.Info("* * * * * * * * * * *")

	// Database connection creation
	slog.Info("Testing Database connection")
	dbLogger := createLogConfig("db.log")

	dbConn, err := db.NewDB(db.GetConnInfo(), dbLogger)
	if err != nil {
		slog.Error("Can't connect to database!", "error", err)
		os.Exit(1)
	}
	defer dbConn.Close()
	slog.Info("Database connection successful")

	// Initialize our handler
	h := &handlers.Handler{Db: dbConn}
	
	// Setup our endpoints
	http.HandleFunc("/health", h.Health)

	slog.Info("Delivering application")
	http.ListenAndServe(":8090", nil)
}

func createLogConfig(fileName string) *slog.Logger {
	// Create path string
	filePath := "logs/" + fileName

	// Logger file
	logFile, err := os.OpenFile(filePath, os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0644)
	if err != nil {
		panic(err)
	}

	// Logger initialization
	logLevel := new(slog.LevelVar)
	logger := slog.NewJSONHandler(logFile, &slog.HandlerOptions{Level: logLevel})

	return slog.New(logger)
}
