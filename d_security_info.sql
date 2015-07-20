delete from security_info
where user_name in
(select name from security_users
where user_type = 0)