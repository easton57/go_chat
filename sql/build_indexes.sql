-- Create indexes
CREATE INDEX ON Users (username)
CREATE INDEX ON Rooms (room_name)
CREATE INDEX ON Messages (room_id, sent_at)
CREATE INDEX ON Room_Members (user_id)
