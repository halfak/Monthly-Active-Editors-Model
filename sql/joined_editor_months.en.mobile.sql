SELECT
    em.*,
    lui.attached_method
FROM editor_month em
INNER JOIN local_user_info lui USING (wiki, user_id)
LEFT JOIN log.ServerSideAccountCreation_5487345 ssac ON
    em.wiki = ssac.wiki AND
    event_userId = user_id
WHERE 
    em.wiki IN ("enwiki") AND 
    event_displayMobile = 1
ORDER BY em.wiki, month;