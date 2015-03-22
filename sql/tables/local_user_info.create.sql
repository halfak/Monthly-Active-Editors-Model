CREATE TABLE staging.local_user_info (
    wiki VARCHAR(50),
    user_id INT,
    user_registration VARBINARY(14),
    globaluser_id INT,
    user_attached VARBINARY(14),
    attached_method ENUM('primary','empty','mail','password','admin','new','login')
);
CREATE UNIQUE INDEX wiki_user ON staging.local_user_info (wiki, user_id);
CREATE INDEX globaluser ON staging.local_user_info (globaluser_id);

SELECT COUNT(*), NOW() FROM staging.local_user_info;