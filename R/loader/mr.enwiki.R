source("util.R")
source("env.R")

load_mr.enwiki = tsv_loader(
    paste(DATA_DIR, "mr.enwiki.tsv", sep="/"),
    "MONTHLY_REGISTRATIONS.ENWIKI"
)