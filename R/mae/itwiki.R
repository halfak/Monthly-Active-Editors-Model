source("loader/mae.en_it_bg_meta.R")
source("loader/mnr.en_it_bg_meta.R")

mae = load_mae.en_it_bg_meta(reload=T)[wiki == "itwiki",]
mnr = load_mnr.en_it_bg_meta(reload=T)[wiki == "itwiki",]

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

svg("mae/plots/monthly_active_editor_rates.itwiki.svg", height=5, width=7)
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

svg("mae/plots/monthly_registrations.itwiki.svg", height=5, width=7)
ggplot(
    mnr,
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