source("loader/mae.en_mobile.R")
source("loader/mnr.en_mobile.R")

mae = load_mae.en_mobile(reload=T)[wiki == "enwiki",]
mnr = load_mnr.en_mobile(reload=T)[wiki == "enwiki",]

merged_mae = merge(mae, mnr[month >= "2006-01-01",], by=c("month_date"), all.x=T)
merged_mae$new_editor_activation_rate = with(
    merged_mae,
    pmin(new_active_editors/registrations, 1) # Deals with weird old Wikipedia data
)

summary(
	merged_mae[month_date >= "2013-07-01" & month_date < "2014-05-01",
		list(
			mae = total_active_editors,
			nae = new_active_editors,
			nae_rate = new_editor_activation_rate,
			snae = surviving_new_active_editors,
			snae_rate = new_active_survival_rate,
			roae = old_active_editors,
			roae_rate = old_active_survival_rate,
			rae = reactivated_editors,
			inactivated = inactivated_editors,
			inactivated_rate = inactivation_rate
		),
	]
)
summary(
	merged_mae[month_date >= "2013-07-01" & month_date < "2014-05-01",
		list(
			registrations,
			nae_prop = new_active_editors / total_active_editors,
			snae_prop = surviving_new_active_editors / total_active_editors,
			roae_prop = old_active_editors / total_active_editors,
			rae_prop = reactivated_editors / total_active_editors
		)
	]
)
wiki.table(
	merged_mae[,
		list(
			month_date,
			registrations,
			mae = total_active_editors,
			nae = new_active_editors,
			nae_rate = new_editor_activation_rate,
			snae = surviving_new_active_editors,
			snae_rate = new_active_survival_rate,
			roae = old_active_editors,
			roae_rate = old_active_survival_rate,
			rae = reactivated_editors,
			inactivated = inactivated_editors,
			inactivated_rate = inactivation_rate
		),
	]
)

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

svg("mae/plots/monthly_active_editors.by_group.en_mobile.svg", height=5, width=7)
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

normalized.rates = rbind(
    merged_mae[,
        list(
            month_date,
            rate = new_editor_activation_rate,
            group = "new editor activation"
        ),
    ],
    merged_mae[,
        list(
            month_date,
            rate = new_active_survival_rate,
            group = "new active survival"
        ),
    ],
    merged_mae[,
        list(
            month_date,
            rate = old_active_survival_rate,
            group = "old active survival"
        ),
    ]
)

svg("mae/plots/monthly_active_editor_rates.en_mobile.svg", height=5, width=7)
ggplot(
    normalized.rates[month_date < "2014-06-01",],
    aes(
        x = month_date,
        y = rate,
        linetype = group
    )
) + 
geom_line() + 
theme_bw() + 
scale_x_date("Month") + 
scale_y_continuous("Rate")
dev.off()


svg("mae/plots/monthly_active_editors.facet_group.en_mobile.svg", height=7, width=7)
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
stat_smooth(linetype=2, se=F, span=1, color="#000000") + 
theme_bw() + 
scale_x_date("Month") + 
scale_y_continuous("Active Editors")
dev.off()
