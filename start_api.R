library(plumber)
#setwd('~/work')
r <- plumb('plumber.R')
r$run(host='0.0.0.0', port=8000)