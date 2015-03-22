source("util.R")
source("env.R")

load_mnr.en_it_bg_meta = tsv_loader(
	paste(DATA_DIR, "mnr.en_it_bg_meta.tsv", sep="/"),
	"MONTHLY_NEW_REGISTRATIONS.EN_IT_BG_META",
	function(dt){
		dt$month_date = with(
			dt,
			as.Date(
				paste(
					substring(as.character(month), 1, 4), 
					substring(as.character(month), 5, 6), 
					"01", sep="-"
				)
			)
		)
		dt
	}
)