SELECT 
    u.user_id,
    u.email,
    u.full_name,
    u.is_active,
    u.last_login_at,
    uc.password_hash,
    uc.two_factor_secret,
    p.file_url AS presentation_file_url,
    p.status AS presentation_status,
    t.task_status AS task_status,
    t.result AS task_result,
    t.started_at AS task_started_at,
    t.completed_at AS task_completed_at,
    at.token AS auth_token,
    at.expires_at AS auth_token_expiry,
    al.action_type AS action_type,
    al.action_details AS action_details,
    al.ip_address AS action_ip_address,
    al.user_agent AS action_user_agent
FROM 
    users u
JOIN 
    user_credentials uc ON u.user_id = uc.user_id
JOIN 
    presentations p ON u.user_id = p.user_id
JOIN 
    tasks t ON p.presentation_id = t.presentation_id
JOIN 
    auth_tokens at ON u.user_id = at.user_id
JOIN 
    audit_logs al ON u.user_id = al.user_id;
