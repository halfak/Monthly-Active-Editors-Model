SELECT
    month,
    wiki,
    user_id,
    user_name,
    user_registration,
    archived,
    revisions
FROM (
    SELECT
        CONCAT(LEFT(rev_timestamp, 4), "-", SUBSTRING(rev_timestamp, 7, 2)) AS month,
        DATABASE() AS wiki,
        rev_user AS user_id,
        FALSE AS archived,
        COUNT(*) AS revisions
    FROM revision
    GROUP BY LEFT(rev_timestamp, 6), rev_user

    UNION ALL

    SELECT
        CONCAT(LEFT(ar_timestamp, 4), "-", SUBSTRING(ar_timestamp, 7, 2)) AS month,
        DATABASE() AS wiki,
        ar_user AS user_id,
        FALSE AS archived,
        COUNT(*) AS revisions
    FROM archive
    GROUP BY LEFT(ar_timestamp, 6), ar_user
) AS editor_months
INNER JOIN user USING (user_id);
