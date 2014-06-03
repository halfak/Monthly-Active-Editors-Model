CREATE TABLE staging.wiki_info (
    wiki VARCHAR(100),
    code VARCHAR(100),
    sitename VARCHAR(100),
    url VARCHAR(255),
    lang_id INT,
    lang_code VARCHAR(100),
    lang_name VARBINARY(255),
    lang_local_name VARBINARY(255),
    PRIMARY KEY(wiki)
);
