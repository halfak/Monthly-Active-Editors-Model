SELECT
    em.*,
    lui.attached_method
FROM editor_month em
INNER JOIN local_user_info lui USING (wiki, user_id)
ORDER BY wiki, month;
