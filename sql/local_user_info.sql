SELECT
    DATABASE() AS wiki,
    user_id AS user_id,
    user_registration AS user_registration,
    gu_id AS globaluser_id,
    lu_attached_timestamp AS user_attached,
    lu_attached_method AS attached_method
FROM user
LEFT JOIN centralauth.localuser ON 
    lu_wiki = DATABASE() AND
    lu_name = user_name
LEFT JOIN centralauth.globaluser ON
    gu_name = lu_name
GROUP BY user_id;