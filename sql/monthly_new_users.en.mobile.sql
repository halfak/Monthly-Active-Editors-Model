SELECT
    lui.wiki,
    LEFT(user_registration, 6) AS month,
    COUNT(*) AS registrations
FROM local_user_info lui
LEFT JOIN log.ServerSideAccountCreation_5487345 ssac ON
    lui.wiki = ssac.wiki AND
    event_userId = user_id
WHERE
    lui.wiki IN ('enwiki') AND
    user_registration IS NOT NULL AND
    attached_method != "login" AND
    event_displayMobile = 1
GROUP BY 1,2;
