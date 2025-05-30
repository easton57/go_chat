package handlers

import (
	"encoding/json"
	"net/http"
)

// Health struct Move to models maybe?
type HealthStruct struct {
	Status 	string `json:"status"`
	Db		bool 	`json:"db"`
}

func (h *Handler) Health(w http.ResponseWriter, req *http.Request) {
		// Json header setting
		w.Header().Set("Content-Type", "application/json")

		// Set the status as healthy for now
		appState := "healthy"

		// Get db status
		dbState, err := h.Db.HealthCheck()
		if err != nil {
			appState = "unhealthy"
		}

		// Construct our struct
		serverHealth := HealthStruct{Status: appState, Db: dbState }
		serverHealthJS, err := json.Marshal(serverHealth)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		w.Write(serverHealthJS)
}
