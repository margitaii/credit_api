library(httr)
library(jsonlite)
library(magrittr)

load('stage/test.Rdata')
url <- 'http://[your-EC2-instance-ip].eu-central-1.compute.amazonaws.com:8000'
#url <- 'http://localhost:8000'

# xmpl 1
resource <- '/features/list'
rsp <- GET(paste0(url, resource)) %>%
  content(as = "text", encoding = 'UTF-8') %>%
  fromJSON(simplifyDataFrame = T)

# xmpl 2
resource <- '/score'
load('stage/test.Rdata')

rsp2 <- POST(paste0(url, resource)
          , body = test[1:100,]
          , encode = 'json') %>%
  content(as = "text", encoding = 'UTF-8') %>%
  fromJSON(simplifyDataFrame = T)


