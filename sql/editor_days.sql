SELECT
    DATABASE() as wiki,
    day,
    user_id,
    SUM(IF(archived, revisions, 0)) AS archived,
    SUM(revisions) AS revisions
FROM (
    SELECT
        LEFT(rev_timestamp, 8) AS day,
        rev_user AS user_id,
        FALSE AS archived,
        COUNT(*) AS revisions
    FROM revision
    GROUP BY LEFT(rev_timestamp, 8), rev_user

    UNION ALL

    SELECT
        LEFT(ar_timestamp, 8) AS day,
        ar_user AS user_id,
        TRUE AS archived,
        COUNT(*) AS revisions
    FROM archive
    GROUP BY LEFT(ar_timestamp, 8), ar_user
) AS editor_days
GROUP BY wiki, day, user_id
ORDER BY wiki, day;
