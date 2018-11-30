library(data.table)
library(skimr)
library(mltools)

# Load data -----
# Note: here we assume that the data extraction and integration is
# already done.
dev <- fread('data/application_train.csv', stringsAsFactors = FALSE)
names(dev) <- tolower(names(dev))
descr <- fread('data/HomeCredit_columns_description.csv', stringsAsFactors = FALSE)
descr <- descr[Table == 'application_{train|test}.csv', ]

# Data exploration
skim_dev <- data.table(skim(dev))

# Quickly explore character variables ----
cols <- unique(skim_dev[skim_dev$type == 'character']$variable)
# We drop two flags from the list (see later)
cols <- cols[!(cols %in% c('flag_own_realty','flag_own_car'))]
skim_dev_chr <- data.table()
for(i in cols){
  r <- dev[, .(.N), by = i]
  names(r)[1] <- "value"
  r$var <- i
  skim_dev_chr <- rbind(skim_dev_chr, r[,.(var, value, N)])
}
# Practically the empty fields and the XNA values are the missing ones
# so we convert these values to missing
dev[, (cols) := lapply(.SD, function(x) ifelse(x %in% c('XNA',''), '', x))
    , .SDcols = cols]
dev[, (cols) := lapply(.SD, function(x) factor(as.numeric(factor(x)), ordered = F))
    , .SDcols = cols]
# One_hot encoding of categrical variables
dev <- one_hot(dev, naCols=TRUE)
rm('r', 'cols') # cleanup

# Quickly explore flag variables ----
# Recode the flag_own_car and flag_own_reality to 0/1
dev$flag_own_car <- ifelse(dev$flag_own_car == 'N', as.integer(0), as.integer(1))
dev$flag_own_realty <- ifelse(dev$flag_own_realty == 'N', as.integer(0), as.integer(1))
# Some of them are flags while others are counters
# Let's identify first the flag variables using the metatdata descr
cols <- tolower(descr[substr(Row,1,4) == 'FLAG' | substr(Description,1,4) == 'Flag', ]$Row)
skim(dev[, (cols), with=F])
rm('cols')

# Quickly explore numeric variables ----
# Our general rule is that if the missing ratio is above 30%
# then we drop the variable
skim_dev_num <- skim_dev[type == 'numeric' & stat %in% c('missing','n'), .(variable, stat, value)]
skim_dev_num <- dcast(skim_dev_num, variable ~ stat)
skim_dev_num[, rat_missing := missing/n]

# Drop features from the dev sample ----
drop <- c('sk_id_curr'
  ,'fondkapremont_mode'
  ,'flag_cont_mobile'
  ,'flag_mobil'
  # ,'ext_source_1'
  # ,'ext_source_2'
  # ,'ext_source_3'
  , skim_dev_num[rat_missing>0.3,]$variable
)
drop <- unique(drop)
dev[, (drop) := NULL]
rm(drop)

# Create test sample ----
smpl_size <- floor(0.75 * nrow(dev))
set.seed(12345)
dev_ids <- sample(seq_len(nrow(dev)), size = smpl_size, replace = FALSE)

test <- dev[-dev_ids,]
dev <- dev[dev_ids,]

# Save samples ----
save(test, file = 'stage/test.Rdata')
save(dev, file ='stage/dev.Rdata')
