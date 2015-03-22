CREATE TABLE staging.editor_month_by_namespace (
	wiki VARCHAR(50),
	month VARBINARY(7),
	user_id INT,
	page_namespace INT,
	archived INT,
	revisions INT,
	PRIMARY KEY(wiki, month, user_id, page_namespace)
);
CREATE INDEX wiki_user ON staging.editor_month_by_namespace (wiki, user_id);

SELECT COUNT(*), NOW() FROM staging.editor_month_by_namespace;
