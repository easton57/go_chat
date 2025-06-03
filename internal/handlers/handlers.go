package handlers

import (
	"log/slog"
	"github.com/easton57/go_chat/internal/db"
)

type Handler struct { 
	Db *db.DB 
	Log *slog.Logger 
}
