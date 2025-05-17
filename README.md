# go_chat

A little chat room application I am using to learn go and some web development

## backend functions
* authentication
* room management (creation, join, leave, delete)
* message broadcasting
* user sign ups
* read messages

## database choice
PostgreSQL

TODO: Docker Compose file for database deployment

Tables:
* Users (user_id, username, password_hash, email, created_at)
* Rooms (room_id, room_name, created_by, created_at)
* Messages (message_id, room_id, user_id, content, sent_at)
* Room_Members (room_id, user_id, joined_at)

## frontend 
Nothing here yet either.

Flutter? I've made some stuff with that... could be fun ;)
(Plus I hate webdev, flutter makes it tolerable)

## Features to add
* Profile pictures
* Read receipts
* Roles
* Encryption
* Friends
* Direct Messages

## File Structure
go_chat/
├── sql/
│   ├── schema.sql              # Table definitions (Users, Rooms, Messages, Room_Members)
│   ├── user_management.sql     # User stored procedures
│   ├── room_management.sql     # Room stored procedures
│   ├── messaging_management.sql # Messaging stored procedures
├── internal/
│   ├── db/
│   │   ├── db.go              # Database connection and common logic
│   │   ├── user.go            # User database operations
│   │   ├── room.go            # Room database operations
│   │   ├── message.go         # Message database operations
│   ├── handlers/
│   │   ├── user.go            # User HTTP handlers (e.g., /register, /login)
│   │   ├── room.go            # Room HTTP handlers (e.g., /rooms, /rooms/{id}/join)
│   │   ├── message.go         # Message HTTP/WebSocket handlers (e.g., /rooms/{id}/messages)
│   │   ├── middleware.go      # Authentication middleware (e.g., JWT)
│   ├── models/
│   │   ├── user.go            # User struct
│   │   ├── room.go            # Room struct
│   │   ├── message.go         # Message struct
│   ├── websocket/
│   │   ├── websocket.go       # WebSocket connection manager
├── main.go                    # Application entry point
├── go.mod                     # Go module definition
├── README.md                  # Project documentation
├── docker-compose.yml         # Optional: Local PostgreSQL setup
