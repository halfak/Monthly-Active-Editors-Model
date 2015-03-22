CREATE TABLE staging.editor_day_fixed (
	wiki VARCHAR(50),
	day VARBINARY(8),
	user_id INT,
	archived INT,
	revisions INT,
	PRIMARY KEY(wiki, day, user_id)
);
CREATE INDEX wiki_user ON staging.editor_day_fixed (wiki, user_id);

SELECT COUNT(*), NOW() FROM staging.editor_day_fixed;
