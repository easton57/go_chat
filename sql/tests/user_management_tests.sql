SELECT create_user('testuser', 'testhash', 'test@test.com');
SELECT update_password('testuser', 'newtestpassword');
SELECT get_user_details('testuser');
SELECT login('testuser');
SELECT get_user_id('testuser');
SELECT delete_user('testuser');
