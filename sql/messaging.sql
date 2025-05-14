--send message
CREATE OR REPLACE FUNCTION send_message(p_room_id INTEGER, p_user_id INTEGER, p_content VARCHAR)
RETURNS VARCHAR
LANGUAGE plpgsql
AS $$
BEGIN
    -- Check to see if the room and user exist
    IF NOT EXISTS (SELECT 1 FROM Rooms WHERE room_id = p_room_id) THEN
        RETURN 'Room not found';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM Users WHERE user_id = p_user_id) THEN
        RETURN 'User not found';
    END IF;
    
    -- Check if user is a room member
    IF NOT EXISTS (SELECT 1 FROM Room_Members WHERE room_id = p_room_id AND user_id = p_user_id) THEN
        RETURN 'User not a room member';
    END IF;

    -- Validate content
    IF p_content IS NULL OR TRIM(p_content) = '' THEN
        RETURN 'Message content cannot be empty';
    END IF;

    -- Insert message to database
    INSERT INTO messages (room_id, user_id, content, sent_at)
    VALUES (p_room_id, p_user_id, p_content, CURRENT_TIMESTAMP);
    
    RETURN 'Message sent';

EXCEPTION
    WHEN string_data_right_truncation THEN
        RETURN 'Error: Message content too long (max 255 characters)';
    WHEN OTHERS THEN
        RETURN 'Error sending message: ' || SQLERRM;
END;
$$;

-- Retrieves messages for a specific room, including sender details.
CREATE OR REPLACE FUNCTION list_messages(p_room_id INTEGER, p_limit INTEGER DEFAULT 50, p_offset INTEGER DEFAULT 0)
RETURNS TABLE (message_id INTEGER, room_id INTEGER, user_id INTEGER, username VARCHAR, content VARCHAR, sent_at TIMESTAMP WITH TIME ZONE)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Check if room exists
    IF NOT EXISTS (SELECT 1 FROM Rooms WHERE room_id = p_room_id) THEN
        RAISE EXCEPTION 'Room not found';
    END IF;

    RETURN QUERY
    SELECT m.message_id, m.room_id, m.user_id, u.username, m.content, m.sent_at
    FROM Messages m
    JOIN Users u ON m.user_id = u.user_id
    WHERE m.room_id = p_room_id
    ORDER BY m.sent_at DESC
    LIMIT p_limit
    OFFSET p_offset;

    RETURN;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error fetching messages: %', SQLERRM;
END;
$$;

-- Delete message
CREATE OR REPLACE FUNCTION delete_message(p_message_id INTEGER, p_user_id INTEGER)
RETURNS VARCHAR
LANGUAGE plpgsql
AS $$
BEGIN
    -- Check if message exists
    IF NOT EXISTS (SELECT 1 FROM Messages WHERE message_id = p_message_id) THEN
        RETURN 'Message not found';
    END IF;

    -- Check if user is the sender
    IF NOT EXISTS (SELECT 1 FROM Messages WHERE message_id = p_message_id AND user_id = p_user_id) THEN
        RETURN 'Unauthorized: Only the sender can delete this message';
    END IF;

    -- Delete message
    DELETE FROM Messages WHERE message_id = p_message_id;

    RETURN 'Message deleted';
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'Error deleting message: ' || SQLERRM;
END;
$$;

-- Validate room membership
CREATE OR REPLACE FUNCTION validate_membership(p_user_id INTEGER, p_room_id INTEGER)
RETURNS VARCHAR
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM rooms WHERE room_id = p_room_id) THEN
        RETURN 'Room not found';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM Users WHERE user_id = p_user_id) THEN
        RETURN 'User not found';
    END IF;

    IF EXISTS (SELECT 1 FROM room_members WHERE user_id = p_user_id AND room_id = p_room_id) THEN
        RETURN 'Confirmed membership';
    END IF;

    RETURN 'User not a member';
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'Error checking for membership: ' || SQLERRM;
END;
$$;

