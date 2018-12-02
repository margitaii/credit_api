# plumber.R
#' @apiTitle CREDIT API
#' @apiDescription Home Credit application data with XGBoost

library(data.table)
library(xgboost)
library(pROC)
library(jsonlite)
library(png)

# Load model
model <- xgb.load('artifacts/pre_trained.model')
load('artifacts/importance.Rdata')

#' Gives the 30 most important features
#' @json
#' @get /features/list
function(){
  xgb_importance[1:30]
}

#' Plots the 30 most important features
#' @png
#' @get /features/plot
function(){
   xgb.plot.importance(xgb_importance[1:30])
}

#' Scores a single client
#' @post /score
function(req){
  req <- fromJSON(req$postBody)
  req <- data.table(req)
  
  smpl <- xgb.DMatrix(data = as.matrix(req[, -"target", with=FALSE])
                     , label = req$target)
  predict(model, smpl)
  #req
}
