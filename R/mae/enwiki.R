source("loader/mae.en_it_bg_meta.R")
source("loader/mnr.en_it_bg_meta.R")

mae = load_mae.en_it_bg_meta(reload=T)[wiki == "enwiki",]
mnr = load_mnr.en_it_bg_meta(reload=T)[wiki == "enwiki",]

merged_mae = merge(mae, mnr[month >= "2006-01-01",], by=c("month_date"), all.x=T)
merged_mae$new_editor_activation_rate = with(
    merged_mae,
    pmin(new_active_editors/registrations, 1) # Deals with weird old Wikipedia data
)

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

svg("mae/plots/monthly_active_editor_rates.enwiki.svg", height=5, width=7)
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
scale_y_continuous("Activation Rate")
dev.off()

svg("mae/plots/monthly_registrations.enwiki.svg", height=5, width=7)
ggplot(
    mr,
    aes(
        x = month_date,
        y = registrations
    )
) +
geom_line() +
theme_bw() +
scale_x_date("Month") +
scale_y_continuous("Activation Rate")
dev.off()

summary(lm(
    rate ~ month_date,
    data=normalized.rates[
        group == "new editor activation" &
        month >= "2012-05-01" &
        month < "2014-06-01",
    ]
))
summary(lm(
    reactivated_editors ~ month_date,
    data=merged_mae[
        month_date >= "2012-05-01" & 
        month_date < "2014-06-01",
    ]
))

wiki.table(
	merge(
		normalized.rates[
			group == "new editor activation",
			list(month_date, new_editor_activation=rate),
		],
		merge(
			normalized.rates[
				group == "new active survival",
				list(month_date, new_active_survival=rate),
			],
			normalized.rates[
				group == "old active survival",
				list(month_date, old_active_survival=rate),
			],
			by="month_date",
			all=T
		),
		by="month_date",
		all=T
	)
)

wiki.table(
	merged_mae[,
		list(
			month_date,
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
	merged_mae[month_date >= "2013-05-01" & month_date < "2014-05-01",
		list(
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
summary(
	merged_mae[month_date >= "2013-05-01" & month_date < "2014-05-01",
		list(
			registrations,
			nae_prop = new_active_editors / total_active_editors,
			snae_prop = surviving_new_active_editors / total_active_editors,
			roae_prop = old_active_editors / total_active_editors,
			rae_prop = reactivated_editors / total_active_editors
		)
	]
)
