source("util.R")
source("env.R")

load_mae.en_mobile = tsv_loader(
	paste(DATA_DIR, "mae.en_mobile.tsv", sep="/"),
	"EDITOR_MONTHS.EN_MOBILE",
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