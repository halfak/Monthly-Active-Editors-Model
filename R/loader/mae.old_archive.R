source("util.R")
source("env.R")

load_mae.old_archive = data_loader(
	function(reload=T, verbose=F){
		df = read.csv(
			paste(DATA_DIR, "old/mae_archive.csv", sep="/"),
			header=T
		)
		data.table(df)
	},
	"MAE.OLD_ARCHIVE",
	function(dt){
		dt$month_date = with(
			dt,
			as.Date(
				paste(
					dt$month,
					"01",
					sep="-"
				)
			)
		)
		dt
		
	}
)