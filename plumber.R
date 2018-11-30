# plumber.R
# API prototype of our XGBoost SC model
library(data.table)
library(xgboost)
library(pROC)
library(jsonlite)
library(png)

# Load model
model <- xgb.load('artifacts/pre_trained.model')
load('artifacts/importance.Rdata')

#* Gives the 30 most important features
#* @json
#* @get /features/list
function(){
  xgb_importance[1:30]
}

#* Plots the 30 most important features
#* @png
#* @get /features/plot
function(){
   xgb.plot.importance(xgb_importance[1:30])
}

#* Scores a sample and returns the score vector
#* in a JSON file
#* @param smpl
#* @get /score
#* @post /score
function(smpl){
  sum(as.numeric(smpl$target))
}
