library(httr)

url <- 'http://ec2-54-93-75-75.eu-central-1.compute.amazonaws.com:8000'
resource <- '/echo?msg=testing'

for(i in 1:20){
r <- GET(paste0(url, resource))
msg <- content(r)$msg
print(msg)
}