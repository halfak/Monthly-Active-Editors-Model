source("loader/mae.en_it_bg_meta.R")
source("loader/mae.old_archive.R")
source("loader/mae.old_dump.R")

archive_mae = load_mae.old_archive(reload=T)
dump_mae = load_mae.old_dump(reload=T)
modern_mae = load_mae.en_it_bg_meta(reload=T)

normalized.mae = rbind(
	archive_mae[,
		list(
			month_date,
			strategy = "archive ns=0",
			wiki = "enwiki",
			mae = en
		)
	],
	archive_mae[,
		list(
			month_date,
			strategy = "archive ns=0",
			wiki = "itwiki",
			mae = it
		)
	],
	dump_mae[,
		list(
			month_date,
			strategy = "dump ns=0",
			wiki = "enwiki",
			mae = en
		)
	],
	dump_mae[,
		list(
			month_date,
			strategy = "dump ns=0",
			wiki = "itwiki",
			mae = it
		)
	],
	modern_mae[wiki == "enwiki" | wiki == "itwiki",
		list(
			month_date,
			strategy = "archive ns=all",
			wiki,
			mae = total_active_editors
		)
	]
)
normalized.mae = normalized.mae[month_date < "2014-06-01",]

svg("comparison/plots/mae.by_strategy.enwiki.svg", height=5, width=7)
ggplot(
	normalized.mae[wiki == "enwiki",],
	aes(
		x = month_date,
		y = mae,
		group=strategy,
		color=strategy
	)
) + 
facet_wrap(~ wiki) + 
geom_line() + 
theme_bw() + 
scale_x_date("Month") + 
scale_y_continuous("Active editors")
dev.off()

svg("comparison/plots/mae.by_strategy.itwiki.svg", height=5, width=7)
ggplot(
	normalized.mae[wiki == "itwiki",],
	aes(
		x = month_date,
		y = mae,
		group=strategy,
		color=strategy
	)
) + 
facet_wrap(~ wiki) + 
geom_line() + 
theme_bw() + 
scale_x_date("Month") + 
scale_y_continuous("Active editors")
dev.off()


denormalized.mae = merge(
	normalized.mae[strategy == "archive ns=all", list(wiki, month_date, archive_ns_all=mae),],
	merge(
		normalized.mae[strategy == "archive ns=0", list(wiki, month_date, archive_ns_0=mae),],
		normalized.mae[strategy == "dump ns=0", list(wiki, month_date, dump_ns_0=mae),],
		by=c("wiki", "month_date")
	),
	by=c("wiki", "month_date")
)

normalized.factor_dump = rbind(
	denormalized.mae[dump_ns_0 > 0,
		list(
			wiki,
			month_date,
			strategy = "archive ns=all",
			factor_of_dump_ns_0 = archive_ns_all/dump_ns_0,
			factor_of_archive_ns_0 = archive_ns_all/archive_ns_0,
			factor_of_archive_ns_all = archive_ns_all/archive_ns_all
		),
	],
	denormalized.mae[dump_ns_0 > 0,
		list(
			wiki,
			month_date,
			strategy = "archive ns=0",
			factor_of_dump_ns_0 = archive_ns_0/dump_ns_0,
			factor_of_archive_ns_0 = archive_ns_0/archive_ns_0,
			factor_of_archive_ns_all = archive_ns_0/archive_ns_all
		),
	],
	denormalized.mae[dump_ns_0 > 0,
		list(
			wiki,
			month_date,
			strategy = "dump ns=0",
			factor_of_dump_ns_0 = dump_ns_0/dump_ns_0,
			factor_of_archive_ns_0 = dump_ns_0/archive_ns_0,
			factor_of_archive_ns_all = dump_ns_0/archive_ns_all
		),
	]
)

svg("comparison/plots/mae.factor_of_dump_ns_0.by_strategy.svg", height=5, width=7)
ggplot(
	normalized.factor_dump,
	aes(
		x=month_date,
		y=factor_of_dump_ns_0,
		group=strategy,
		color=strategy
	)
) + 
facet_wrap(~ wiki) + 
geom_hline(yintercept=1) + 
geom_line() + 
scale_y_continuous("Factor of 'dump ns=0'", limits=c(0.6, 1.55)) + 
theme_bw()
dev.off()

svg("comparison/plots/mae.factor_of_archive_ns_0.by_strategy.svg", height=5, width=7)
ggplot(
	normalized.factor_dump,
	aes(
		x=month_date,
		y=factor_of_archive_ns_0,
		group=strategy,
		color=strategy
	)
) + 
facet_wrap(~ wiki) + 
geom_line() + 
scale_y_continuous("Factor of 'archive ns=0'", limits=c(0.6, 1.55)) + 
theme_bw()
dev.off()


svg("comparison/plots/mae.factor_of_archive_ns_all.by_strategy.svg", height=5, width=7)
ggplot(
	normalized.factor_dump,
	aes(
		x=month_date,
		y=factor_of_archive_ns_all,
		group=strategy,
		color=strategy
	)
) + 
facet_wrap(~ wiki) + 
geom_line() + 
scale_y_continuous("Factor of 'archive ns=all'", limits=c(0.6, 1.55)) + 
theme_bw()
dev.off()