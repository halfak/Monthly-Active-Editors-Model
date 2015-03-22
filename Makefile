
dbstore = --defaults-file=~/.my.research.cnf -h analytics-store.eqiad.wmnet -u research
db1047  = --defaults-file=~/.my.research.cnf -h db1047.eqiad.wmnet -u research


datasets/tables/editor_months.created: sql/tables/editor_months.create.sql
	cat sql/tables/editor_months.create.sql | \
	mysql $(dbstore) staging > \
	datasets/tables/editor_months.created

datasets/tables/editor_months.loaded: datasets/tables/editor_months.created \
                                      datasets/editor_months.all.tsv
	mysql $(dbstore) -e "TRUNCATE TABLE staging.editor_month;" && \
	ln -sf editor_months.all.tsv datasets/editor_month && \
	mysqlimport $(dbstore) --local --ignore-lines=1 staging datasets/editor_month && \
	rm datasets/editor_month && \
	mysql $(dbstore) -e "SELECT COUNT(*), NOW() FROM staging.editor_month;" > \
	datasets/tables/editor_months.loaded

datasets/local_user_info.tsv: datasets/wikimedia_wikis.tsv \
                              sql/local_user_info.sql
	./query_wikis datasets/wikimedia_wikis.tsv --query=sql/local_user_info.sql > \
	datasets/local_user_info.tsv

datasets/tables/local_user_info.created: sql/tables/local_user_info.create.sql
	cat sql/tables/local_user_info.create.sql | \
	mysql $(dbstore) staging > \
	datasets/tables/local_user_info.created

datasets/tables/local_user_info.loaded: datasets/tables/local_user_info.created \
                                        datasets/local_user_info.tsv
	mysql $(dbstore) -e "TRUNCATE TABLE staging.local_user_info;" && \
	mysqlimport $(dbstore) --local --ignore-lines=1 staging datasets/local_user_info.tsv && \
	mysql $(dbstore) -e "SELECT COUNT(*), NOW() FROM staging.local_user_info;" > \
	datasets/tables/local_user_info.loaded

datasets/tables/editor_months_by_namespace.created: sql/tables/editor_months_by_namespace.create.sql
	cat sql/tables/editor_months_by_namespace.create.sql | \
	mysql $(db1047) staging > \
	datasets/tables/editor_months_by_namespace.created

datasets/tables/editor_months_by_namespace.loaded: datasets/tables/editor_months_by_namespace.created \
                                                   datasets/editor_months_by_namespace.enwiki.tsv
	mysql $(db1047) -e "TRUNCATE TABLE staging.editor_month_by_namespace;" && \
	ln -sf editor_months_by_namespace.enwiki.tsv datasets/editor_month_by_namespace && \
	mysqlimport $(db1047) --local --ignore-lines=1 staging datasets/editor_month_by_namespace && \
	rm datasets/editor_month_by_namespace && \
	mysql $(db1047) -e "SELECT COUNT(*), NOW() FROM staging.editor_month_by_namespace;" > \
	datasets/tables/editor_months_by_namespace.loaded
