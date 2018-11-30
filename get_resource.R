library(httr)
library(jsonlite)
library(magrittr)

load('stage/test.Rdata')
#url <- 'http://ec2-54-93-75-75.eu-central-1.compute.amazonaws.com:8000'
url <- 'http://localhost:8000'

# xmpl 1
resource <- '/features/list'
r <- GET(paste0(url, resource)) %>%
  content(as = "text", encoding = 'UTF-8') %>%
  fromJSON(simplifyDataFrame = T)

# xmpl 2
resource <- '/score'
r <- POST(paste0(url, resource), body = list(target = c(1,2,3))) %>%
  content(as = "text", encoding = 'UTF-8') %>%
  fromJSON(simplifyDataFrame = T)