package main

import (
	"log/slog"
	"net/http"
	"os"

	"github.com/easton57/go_chat/internal/db"
	"github.com/easton57/go_chat/internal/handlers"
)

func main() {
	// Logger file
	logFile, err := os.OpenFile("logs/go_chat.log", os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0644)
	if err != nil {
		panic(err)
	}
	defer logFile.Close()

	// Logger initialization
	logLevel := new(slog.LevelVar)
	logger := slog.NewJSONHandler(logFile, &slog.HandlerOptions{Level: logLevel})
	slog.SetDefault(slog.New(logger))
	slog.Info("Starting go_chat")

	// Check for credentials in environment and prompt for them if not present

	// Database connection creation
	slog.Info("Testing Database connection")
	dbConn, err := db.NewDB(db.GetConnInfo())
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


