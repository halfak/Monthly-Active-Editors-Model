SELECT
    em.*,
    lui.attached_method
FROM editor_month em
INNER JOIN local_user_info lui USING (wiki, user_id)
WHERE wiki IN ("enwiki", "itwiki", "metawiki", "bgwiki")
ORDER BY wiki, month;