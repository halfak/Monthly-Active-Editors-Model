SET @project_type = SELECT project_type FROM staging.wikidb WHERE wiki = DATABASE()

/* Results in a set of "new editors" */
SELECT
    CONCAT(LEFT(rev_timestamp, 4), "-", SUBSTRING(rev_timestamp, 7, 2)) AS month,
    DATABASE() AS wiki,
    @project_type AS project_type,
    rev_user AS user_id,
    FALSE AS archived,
    COUNT(*) AS revisions
FROM revision
GROUP BY LEFT(rev_timestamp, 6), rev_user

UNION ALL

SELECT
    CONCAT(LEFT(ar_timestamp, 4), "-", SUBSTRING(ar_timestamp, 7, 2)) AS month,
    DATABASE() AS wiki,
    @project_type AS project_type,
    ar_user AS user_id,
    FALSE AS archived,
    COUNT(*) AS revisions
FROM archive
GROUP BY LEFT(ar_timestamp, 6), ar_user;
