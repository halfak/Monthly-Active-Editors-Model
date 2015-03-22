source("util.R")
source("env.R")

load_mr.itwiki = tsv_loader(
    paste(DATA_DIR, "mr.itwiki.tsv", sep="/"),
    "MONTHLY_REGISTRATIONS.ITWIKI"
)