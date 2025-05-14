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
