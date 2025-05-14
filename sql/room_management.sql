-- Create Room
CREATE OR REPLACE FUNCTION create_room(p_room_name VARCHAR, p_user_id INTEGER)
RETURNS VARCHAR
LANGUAGE plpgsql
AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM rooms WHERE room_name = p_room_name) THEN
        RETURN 'Room already exists';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM Users WHERE user_id = p_user_id) THEN
        RETURN 'User not found';
    END IF;

    INSERT INTO rooms (room_name, created_by, created_at)
    VALUES (p_room_name, p_user_id, CURRENT_TIMESTAMP);

    RETURN 'Room created';

EXCEPTION
    WHEN OTHERS THEN
        RETURN 'Error creating room: ' || SQLERRM;
END;
$$;

-- Get Room ID
CREATE OR REPLACE FUNCTION get_room_id(p_room_name VARCHAR)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_room_id INTEGER;
BEGIN
    SELECT room_id INTO v_room_id
    FROM rooms
    WHERE room_name = p_room_name;

    IF v_room_id IS NULL THEN
       RAISE EXCEPTION 'Room not found';
    END IF;

    RETURN v_room_id;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error getting room id: %', SQLERRM;
END;
$$;

-- Delete room
CREATE OR REPLACE FUNCTION delete_room(p_room_name VARCHAR)
RETURNS VARCHAR
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM rooms WHERE room_name = p_room_name) THEN
        RETURN 'Room not found';
    END IF;

    DELETE FROM rooms WHERE room_name = p_room_name;

    RETURN 'Room deleted';

EXCEPTION 
    WHEN OTHERS THEN
        RETURN 'Error deleting room: ' || SQLERRM;
END;
$$;

-- Get Room Details
CREATE OR REPLACE FUNCTION get_room_details(p_room_name VARCHAR)
RETURNS TABLE (room_id INTEGER, room_name VARCHAR, created_by INTEGER, created_at TIMESTAMP WITH TIME ZONE)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT rooms.room_id, rooms.room_name, rooms.created_by, rooms.created_at
    FROM rooms
    WHERE rooms.room_name = p_room_name;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Room not found';
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error fetching room details: %', SQLERRM;
END;
$$;

-- List rooms
CREATE OR REPLACE FUNCTION list_rooms()
RETURNS TABLE (room_id INTEGER, room_name VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT rooms.room_id, rooms.room_name
    FROM rooms;

    RETURN;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error fetching rooms: %', SQLERRM;
END;
$$;

-- Join Room
CREATE OR REPLACE FUNCTION join_room(p_room_id INTEGER, p_user_id INTEGER)
RETURNS VARCHAR
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Rooms WHERE room_id = p_room_id) THEN
        RETURN 'Room not found';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM Users WHERE user_id = p_user_id) THEN
        RETURN 'User not found';
    END IF;

    IF EXISTS (SELECT 1 FROM room_members WHERE user_id = p_user_id AND room_id = p_room_id) THEN
        RETURN 'User already room member!';
    END IF;

    INSERT INTO room_members (room_id, user_id, joined_at)
    VALUES (p_room_id, p_user_id, CURRENT_TIMESTAMP);

    RETURN 'User joined room';

EXCEPTION
    WHEN OTHERS THEN
        RETURN 'Error adding user to room: ' || SQLERRM;
END;
$$;

-- Leave Room
CREATE OR REPLACE FUNCTION leave_room(p_room_id INTEGER, p_user_id INTEGER)
RETURNS VARCHAR
LANGUAGE plpgsql
AS $$
BEGIN
     IF NOT EXISTS (SELECT 1 FROM room_members WHERE user_id = p_user_id AND room_id = p_room_id) THEN
        RETURN 'User not room member';
    END IF;   

    DELETE FROM room_members WHERE user_id = p_user_id AND room_id = p_room_id;

    RETURN 'User left room';

EXCEPTION
    WHEN OTHERS THEN
        RETURN 'Error removing user from room: ' || SQLERRM;
END;
$$;
