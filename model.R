library(data.table)
library(skimr)
library(ggplot2)
library(xgboost)

# Load data -----
# Note: here we assume that the data extraction and integration is
# already done.
dev <- fread('data/application_train.csv', stringsAsFactors = FALSE)
names(dev) <- tolower(names(dev))
descr <- fread('data/HomeCredit_columns_description.csv', stringsAsFactors = FALSE)

# Data exploration
skim_dev <- data.table(skim(dev))

# Quickly explore character variables ----
cols <- unique(skim_dev[skim_dev$type == 'character']$variable)
skim_dev_chr <- data.table()
for(i in cols){
  r <- dev[, .(.N), by = i]
  names(r)[1] <- "value"
  r$var <- i
  skim_dev_chr <- rbind(skim_dev_chr, r[,.(var, value, N)])
}
# Practically the empty fields and the XNA value are the missing ones
# so we convert these values to missing
test <- dev[, lapply(.SD, function(x){ifelse(x %in% c('','XNA'), NA, x)})
            , .SDcols = cols]

