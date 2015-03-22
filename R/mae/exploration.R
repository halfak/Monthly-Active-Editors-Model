source("loader/mae.en_it_bg_meta.R")

mae = load_mae.en_it_bg_meta(reload=T)


normalized.mae = with(mae, rbind(
	data.table(
		month_date,
		wiki,
		count = new_active_editors,
		group = "new active"
	),
	data.table(
		month_date,
		wiki,
		count = surviving_new_active_editors,
		group = "surviving new active"
	),
	data.table(
		month_date,
		wiki,
		count = old_active_editors,
		group = "old active"
	),
	data.table(
		month_date,
		wiki,
		count = reactivated_editors,
		group = "reactivated"
	)
))
normalized.mae$group = factor(normalized.mae$group, 
                              levels=c("new active",
                                       "surviving new active",
                                       "reactivated",
                                       "old active"))

svg("mae/plots/monthly_active_editors.by_group.metawiki.svg", height=5, width=7)
ggplot(
	normalized.mae[wiki == "metawiki",],
	aes(
		x = month_date,
		y = count,
		fill = group,
		order = - as.numeric(group)
	)
) + 
geom_area(position="stack") + 
geom_line(position="stack", size=0.25) + 
theme_bw() + 
scale_x_date("Month") + 
scale_y_continuous("Active Editors")
dev.off()

svg("mae/plots/monthly_active_editors.by_group.bgwiki.svg", height=5, width=7)
ggplot(
	normalized.mae[wiki == "bgwiki" & month_date < "2014-06-01",],
	aes(
		x = month_date,
		y = count,
		fill = group,
		order = - as.numeric(group)
	)
) + 
geom_area(position="stack") + 
geom_line(position="stack", size=0.25) + 
theme_bw() + 
scale_x_date("Month") + 
scale_y_continuous("Active Editors")
dev.off()

svg("mae/plots/monthly_active_editors.by_group.enwiki.svg", height=5, width=7)
ggplot(
	normalized.mae[wiki == "enwiki" & month_date < "2014-06-01",],
	aes(
		x = month_date,
		y = count,
		fill = group,
		order = - as.numeric(group)
	)
) + 
geom_area(position="stack") + 
geom_line(position="stack", size=0.25) + 
theme_bw() + 
scale_x_date("Month") + 
scale_y_continuous("Active Editors")
dev.off()

svg("mae/plots/monthly_active_editors.by_group.itwiki.svg", height=5, width=7)
ggplot(
	normalized.mae[wiki == "itwiki" & month_date < "2014-06-01",],
	aes(
		x = month_date,
		y = count,
		fill = group,
		order = - as.numeric(group)
	)
) + 
geom_area(position="stack") + 
geom_line(position="stack", size=0.25) + 
theme_bw() + 
scale_x_date("Month") + 
scale_y_continuous("Active Editors")
dev.off()

svg("mae/plots/monthly_active_editors.facet_group.itwiki.svg", height=7, width=7)
ggplot(
	normalized.mae[wiki == "itwiki" & month_date < "2014-06-01",],
	aes(
		x = month_date,
		y = count,
		fill = group,
		order = - as.numeric(group)
	)
) + 
facet_wrap(~ group, ncol=1) + 
geom_area(position="stack", alpha=0.3) + 
geom_line(position="stack", size=0.25, alpha=0.3) + 
stat_smooth(linetype=2, se=F, span=0.5, color="#000000") + 
theme_bw() + 
scale_x_date("Month") + 
scale_y_continuous("Active Editors")
dev.off()

svg("mae/plots/monthly_active_editors.facet_group.enwiki.svg", height=7, width=7)
ggplot(
	normalized.mae[wiki == "enwiki" & month_date < "2014-06-01",],
	aes(
		x = month_date,
		y = count,
		fill = group,
		order = - as.numeric(group)
	)
) + 
facet_wrap(~ group, ncol=1) + 
geom_area(position="stack", alpha=0.3) + 
geom_line(position="stack", size=0.25, alpha=0.3) + 
stat_smooth(linetype=2, se=F, span=0.2, color="#000000") + 
theme_bw() + 
scale_x_date("Month") + 
scale_y_continuous("Active Editors")
dev.off()


