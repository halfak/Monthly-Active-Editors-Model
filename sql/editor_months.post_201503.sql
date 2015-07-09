SELECT
    wiki,
    month,
    user_id,
    user_name,
    user_registration,
    SUM(revisions * archived) AS archived,
    SUM(revisions) AS revisions
FROM (
    SELECT
        LEFT(rev_timestamp, 6) AS month,
        DATABASE() AS wiki,
        rev_user AS user_id,
        FALSE AS archived,
        COUNT(*) AS revisions
    FROM revision
    WHERE rev_timestamp >= "201503"
    GROUP BY LEFT(rev_timestamp, 6), rev_user

    UNION ALL

    SELECT
        LEFT(ar_timestamp, 6) AS month,
        DATABASE() AS wiki,
        ar_user AS user_id,
        TRUE AS archived,
        COUNT(*) AS revisions
    FROM archive
    WHERE ar_timestamp >= "201503"
    GROUP BY LEFT(ar_timestamp, 6), ar_user
) AS editor_months
INNER JOIN user USING (user_id)
GROUP BY wiki, month, user_id
ORDER BY wiki, month;
