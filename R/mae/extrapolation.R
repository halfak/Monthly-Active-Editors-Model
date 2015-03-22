source("loader/mae.en_mobile.R")
source("loader/mnr.en_mobile.R")

mae.mobile = load_mae.en_mobile(reload=T)[wiki == "enwiki",]
mnr.mobile = load_mnr.en_mobile(reload=T)[wiki == "enwiki",]
months.mobile = merge(mae.mobile, mnr.mobile, by=c("wiki", "month_date"))[,
    list(
        wiki,
        month_date,
        registered = "mobile",
        registrations,
        total_active_editors,
        new_active_editors,
        surviving_new_active_editors,
        old_active_editors,
        reactivated_editors
    ),
]

source("loader/mae.en_it_bg_meta.R")
source("loader/mnr.en_it_bg_meta.R")

mae = load_mae.en_it_bg_meta(reload=T)[wiki == "enwiki",]
mnr = load_mnr.en_it_bg_meta(reload=T)[wiki == "enwiki",]
months.all = merge(mae, mnr, by=c("wiki", "month_date"))


months.desktop = with(
    merge(months.all, months.mobile,
          by=c("wiki", "month_date"),
          suffixes=c(".all", ".mobile"),
          all=T
    ),
    data.table(
        wiki,
        month_date,
        registered = "desktop",
        registrations = registrations.all - ifna(registrations.mobile, 0),
        total_active_editors = total_active_editors.all - ifna(total_active_editors.mobile, 0),
        new_active_editors = new_active_editors.all - ifna(new_active_editors.mobile, 0),
        surviving_new_active_editors = surviving_new_active_editors.all - ifna(surviving_new_active_editors.mobile, 0),
        old_active_editors = old_active_editors.all - ifna(old_active_editors.mobile, 0),
        reactivated_editors = reactivated_editors.all - ifna(reactivated_editors.mobile, 0)
    )
)


normalized_months = rbind(months.desktop, months.mobile)


ggplot(
    normalized_months,
    aes(x=month_date, y=registrations, fill=registered)
) +
geom_area() +
geom_line(position="stack", size=0.25) +
theme_bw()


registrations_model.mobile = lm(registrations ~ month_date,
                  data=months.mobile[month_date >= "2013-07-01" &
                                     month_date <= "2014-05-01",])
summary(registrations_model.mobile)

registrations_model.desktop = lm(registrations ~ month_date,
                  data=months.desktop[month_date >= "2012-05-01" &
                                      month_date <= "2014-05-01",])
summary(registrations_model.desktop)

new_active_editors_model.mobile = lm(new_active_editors ~ month_date,
                  data=months.mobile[month_date >= "2013-07-01" &
                                     month_date <= "2014-05-01",])
summary(new_active_editors_model.mobile)

new_active_editors_model.desktop = lm(new_active_editors ~ month_date,
                  data=months.desktop[month_date >= "2012-05-01" &
                                      month_date <= "2014-05-01",])
summary(new_active_editors_model.desktop)

library(lubridate)

future_month_dates = sapply(
    1:60,
    function(i){
        base_date = as.Date("2014-05-01")
        month(base_date) = month(base_date) + i
        base_date
    }
)
class(future_month_dates) <- "Date"

future_registrations.mobile = predict(
    registrations_model.mobile,
    newdata=data.table(month_date=future_month_dates),
    se.fit=T
)
future_registrations.desktop = predict(
    registrations_model.desktop,
    newdata=data.table(month_date=future_month_dates),
    se.fit=T
)
future_new_active_editors.mobile = predict(
    new_active_editors_model.mobile,
    newdata=data.table(month_date=future_month_dates),
    se.fit=T
)
future_new_active_editors.desktop = predict(
    new_active_editors_model.desktop,
    newdata=data.table(month_date=future_month_dates),
    se.fit=T
)

normalized_months.with_future = rbind(
    normalized_months[month_date <= "2014-05-01",
        list(
            month_date,
            registered,
            source = "data",
            registrations,
            registrations.upper = registrations,
            registrations.lower = registrations,
            new_active_editors,
            new_active_editors.upper = new_active_editors,
            new_active_editors.lower = new_active_editors
        ),
    ],
    data.table(
        month_date = future_month_dates,
        registered = "mobile",
        source = "projection",
        registrations = future_registrations.mobile$fit,
        registrations.upper = future_registrations.mobile$fit + future_registrations.mobile$se.fit,
        registrations.lower = future_registrations.mobile$fit - future_registrations.mobile$se.fit,
        new_active_editors = future_new_active_editors.mobile$fit,
        new_active_editors.upper = future_new_active_editors.mobile$fit + future_new_active_editors.mobile$se.fit,
        new_active_editors.lower = future_new_active_editors.mobile$fit - future_new_active_editors.mobile$se.fit
    ),
    data.table(
        month_date = future_month_dates,
        registered = "desktop",
        source = "projection",
        registrations = future_registrations.desktop$fit,
        registrations.upper = future_registrations.desktop$fit + future_registrations.desktop$se.fit,
        registrations.lower = future_registrations.desktop$fit - future_registrations.desktop$se.fit,
        new_active_editors = future_new_active_editors.desktop$fit,
        new_active_editors.upper = future_new_active_editors.desktop$fit + future_new_active_editors.desktop$se.fit,
        new_active_editors.lower = future_new_active_editors.desktop$fit - future_new_active_editors.desktop$se.fit
    )
)
normalized_months.with_future$source = as.factor(normalized_months.with_future$source)

svg("mae/plots/registration_rates.mobile_and_desktop.with_projection.enwiki.svg",
    height=5, width=7)
ggplot(
    normalized_months.with_future,
    aes(
        x=month_date,
        y=registrations,
        color=registered,
        fill=registered,
        linetype=source
    )
) +
geom_ribbon(
    aes(x=month_date, ymin=registrations.lower, ymax=registrations.upper),
    alpha=0.25,
    linetype=0
) +
geom_line() +
scale_y_continuous("Monthly registered users") +
scale_x_date("Calendar month") +
theme_bw()
dev.off()

svg("mae/plots/new_active_editor_rates.mobile_and_desktop.with_projection.enwiki.svg",
    height=5, width=7)
ggplot(
    normalized_months.with_future,
    aes(
        x=month_date,
        y=new_active_editors,
        color=registered,
        fill=registered,
        linetype=source
    )
) +
geom_ribbon(
    aes(x=month_date, ymin=new_active_editors.lower, ymax=new_active_editors.upper),
    alpha=0.25,
    linetype=0
) +
geom_line() +
scale_y_continuous("Monthly new active editors") +
scale_x_date("Calendar month") +
theme_bw()
dev.off()


denormalized_months.with_future = merge(
    normalized_months.with_future[registered=="desktop"],
    normalized_months.with_future[registered=="mobile"],
    by=c("month_date"),
    suffixes=c(".desktop", ".mobile"),
    all=T
)
denormalized_months.with_future$mobile_prop = with(
    denormalized_months.with_future,
    ifna(registrations.mobile, 0) / (registrations.desktop + ifna(registrations.mobile, 0))
)
denormalized_months.with_future$mobile_prop.upper = with(
    denormalized_months.with_future,
    ifna(registrations.upper.mobile, 0) / (registrations.desktop + ifna(registrations.upper.mobile, 0))
)
denormalized_months.with_future$mobile_prop.lower = with(
    denormalized_months.with_future,
    ifna(registrations.lower.mobile, 0) / (registrations.desktop + ifna(registrations.lower.mobile, 0))
)
denormalized_months.with_future$nae_prop = with(
    denormalized_months.with_future,
    ifna(new_active_editors.mobile, 0) / (new_active_editors.desktop + ifna(new_active_editors.mobile, 0))
)
denormalized_months.with_future$nae_prop.upper = with(
    denormalized_months.with_future,
    ifna(new_active_editors.upper.mobile, 0) / (new_active_editors.desktop + ifna(new_active_editors.upper.mobile, 0))
)
denormalized_months.with_future$nae_prop.lower = with(
    denormalized_months.with_future,
    ifna(new_active_editors.lower.mobile, 0) / (new_active_editors.desktop + ifna(new_active_editors.lower.mobile, 0))
)
denormalized_months.with_future$registered.desktop = NULL
denormalized_months.with_future$registered.mobile = NULL
denormalized_months.with_future$source = denormalized_months.with_future$source.desktop
denormalized_months.with_future$source.desktop = NULL
denormalized_months.with_future$source.mobile = NULL

svg("mae/plots/registration_rates.mobile_prop.with_projection.enwiki.svg",
    height=5, width=7)
ggplot(
    denormalized_months.with_future,
    aes(
        x=month_date,
        y=mobile_prop,
        linetype=source
    )
) +
geom_ribbon(
    aes(x=month_date, ymin=mobile_prop.lower, ymax=mobile_prop.upper),
    alpha=0.25,
    linetype=0
) +
geom_line() +
geom_hline(yintercept=0.5) +
scale_y_continuous("Mobile registration proportion") +
scale_x_date("Calendar month") +
theme_bw()
dev.off()


svg("mae/plots/new_active_editor_rates.mobile_prop.with_projection.enwiki.svg",
    height=5, width=7)
ggplot(
    denormalized_months.with_future,
    aes(
        x=month_date,
        y=nae_prop,
        linetype=source
    )
) +
geom_ribbon(
    aes(x=month_date, ymin=nae_prop.lower, ymax=nae_prop.upper),
    alpha=0.25,
    linetype=0
) +
geom_line() +
geom_hline(yintercept=0.5) +
scale_y_continuous("New active editor proportion") +
scale_x_date("Calendar month") +
theme_bw()
dev.off()

wiki.table(denormalized_months.with_future)
write.csv(denormalized_months.with_future, "registrations_and_new_editors.by_registration.with_projection.csv")
