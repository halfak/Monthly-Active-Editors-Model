SELECT
    wiki,
    LEFT(user_registration, 6) AS month,
    COUNT(*) AS registrations
FROM local_user_info
WHERE 
    user_registration IS NOT NULL AND
    attached_method != "login"
GROUP BY 1,2;