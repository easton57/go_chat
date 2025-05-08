-- Create User
CREATE OR REPLACE FUNCTION create_user(p_username VARCHAR, p_password_hash VARCHAR, p_email VARCHAR)
RETURNS VARCHAR
LANGUAGE plpgsql
AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM users WHERE username = p_username) THEN
        RETURN 'Username already exists';
    END IF;
    IF email IS NOT NULL AND EXISTS (SELECT 1 FROM users WHERE email = p_email) THEN
        RETURN 'Email in use';
   END IF;

   INSERT INTO users (username, password_hash, email, created_at)
   VALUES (p_username, p_password_hash, p_email, CURRENT_TIMESTAMP);
   RETURN 'User created';

EXCEPTION
    WHEN OTHERS THEN
        RETURN 'Error creating user: ' || SQLERRM;
END;
$$;

-- Update Password
CREATE OR REPLACE FUNCTION update_password(p_username VARCHAR, p_password_hash VARCHAR)
RETURNS VARCHAR
LANGUAGE plpgsql
AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM users WHERE username = p_username) THEN
        RETURN 'User not found';
    END IF;

    UPDATE users SET password_hash = p_password_hash
    WHERE username = p_username;

    RETURN 'Password updated';
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'Error updating password: ' || SQLERRM;
END;
$$;

-- Get User Details
CREATE OR REPLACE FUNCTION get_user_details(p_username VARCHAR)
RETURNS TABLE (user_id INTEGER, username VARCHAR, email VARCHAR, created_at TIMESTAMP WITH TIME ZONE)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT user_id, username, email, created_at
    FROM users
    WHERE username = username;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'User not found';
    END IF;
END;
$$;

-- Login
CREATE OR REPLACE FUNCTION login(p_username VARCHAR , p_password_hash VARCHAR)
RETURNS TABLE (user_id INTEGER, password_hash VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT username, password_hash
    FROM users
    where username = p_username;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'User not found';
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error during login: %', SQLERRM;
END;
$$;

-- Delete user
CREATE OR REPLACE FUNCTION delete_user(p_username VARCHAR)
RETURNS VARCHAR
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM users WHERE username = p_username) THEN
        RETURN 'User not found';
    END IF;

    DELETE FROM users WHERE username = p_username;

    RETURN 'User deleted';

EXCEPTION
    WHEN OTHERS THEN
        RETURN 'Error deleting user: ' || SQLERRM;
END;
$$;

-- get user id
CREATE OR REPLACE FUNCTION get_user_id(p_username VARCHAR)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_user_id INTEGER;
BEGIN
    SELECT user_id INTO v_user_id
    FROM users
    WHERE username = p_username;

    IF v_user_id IS NULL THEN
        RETURN 'User not found';
    END IF;

    RETURN v_user_id;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error getting user id: %', SQLERRM;
END;
$$;
