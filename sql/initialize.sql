/*
This file is for initializing the database.

It creates the tables:
- Users
- Rooms
- Messages
- Room_Members
*/


-- Create the database
CREATE DATABASE go_chat;

-- Connect to db \c go_chat programatically

-- Create Tables
-- Users
CREATE TABLE Users (
    user_id         SERIAL PRIMARY KEY, 
    username        varchar(20) UNIQUE,
    password_hash   varchar(100),
    email           varchar(100),
    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- rooms
CREATE TABLE Rooms (
    room_id         SERIAL PRIMARY KEY,
    room_name       varchar(40) UNIQUE,
    created_by      integer references users(user_id) ON DELETE SET NULL,
    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- messages
CREATE TABLE Messages (
    message_id      SERIAL PRIMARY KEY,
    room_id         integer references rooms(room_id) ON DELETE CASCADE, 
    user_id         integer references users(user_id) ON DELETE CASCADE,
    content         varchar(255),
    sent_at         TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- room_members
CREATE TABLE Room_Members (
    room_id         integer REFERENCES rooms(room_id) ON DELETE CASCADE,
    user_id         integer REFERENCES users(user_id) ON DELETE CASCADE,
    joined_at       TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (room_id, user_id)
);
