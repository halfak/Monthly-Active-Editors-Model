SELECT
    wiki,
    month,
    user_id,
    page_namespace,
    SUM(IF(archived, revisions, 0)) AS archived,
    SUM(revisions) AS revisions
FROM (
    SELECT
        DATABASE() AS wiki,
        LEFT(rev_timestamp, 6) AS month,
        rev_user AS user_id,
        page_namespace AS page_namespace,
        FALSE AS archived,
        COUNT(*) AS revisions
    FROM revision
    INNER JOIN page ON rev_page = page_id
    GROUP BY 1,2,3,4

    UNION ALL

    SELECT
        DATABASE() AS wiki,
        LEFT(ar_timestamp, 6) AS month,
        ar_user AS user_id,
        ar_namespace AS page_namespace,
        TRUE AS archived,
        COUNT(*) AS revisions
    FROM archive
    GROUP BY 1,2,3,4
) AS editor_months
GROUP BY wiki, month, user_id, page_namespace
ORDER BY wiki, month;
