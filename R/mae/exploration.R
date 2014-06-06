source("loader/mae.bgwiki.R")
source("loader/mae.metawiki.R")

mae = rbind(
    load_mae.bgwiki(),
    load_mae.metawiki()
)
mae$month = with(
    mae,
    as.Date(paste(month, "01", sep="-"))
)

normalized.mae = with(mae, rbind(
    data.table(
        month,
        wiki,
        count = new_active_editors,
        group = "new active editors"
    ),
    data.table(
        month,
        wiki,
        count = surviving_new_active_editors,
        group = "surviving new active editors"
    ),
    data.table(
        month,
        wiki,
        count = surviving_new_active_editors,
        group = "old active editors"
    ),
    data.table(
        month,
        wiki,
        count = reactivated_editors,
        group = "reactivated editors"
    )
))
normalized.mae$group = factor(normalized.mae$group, 
                              levels=c("new active editors",
                                       "surviving new active editors",
                                       "reactivated editors",
                                       "old active editors"))

ggplot(
    normalized.mae[wiki == "bgwiki",],
    aes(
        x = month,
        y = count,
        linetype = group,
        fill = group
    )
) + 
geom_area(position="stack") + 
geom_line(position="stack") + 
theme_bw()