CREATE TABLE staging.editor_month (
	wiki VARCHAR(50),
	month VARBINARY(7),
	user_id INT,
	user_name VARBINARY(191),
	user_registration VARBINARY(14),
	archived INT,
	revisions INT,
	PRIMARY KEY(wiki, month, user_id)
);
CREATE INDEX wiki_user ON staging.editor_month (wiki, user_id);

SELECT COUNT(*), NOW() FROM staging.editor_month;
