SELECT
    DATABASE() AS wiki,
    CONCAT(LEFT(user_registration, 4), "-", SUBSTRING(user_registration, 5, 2)) AS month,
    COUNT(*) AS registrations
FROM user
WHERE user_registration IS NOT NULL
GROUP BY 2
ORDER BY 1,2;
