library(data.table)
library(xgboost)

# Load data ----
load('stage/dev.Rdata')
load('stage/test.Rdata')

# Corvert to xgb.DMatrix format
tr <- xgb.DMatrix(data = as.matrix(dev[, -"target", with=FALSE])
                  , label = dev$target)

te <- xgb.DMatrix(data = as.matrix(test[, -"target", with=FALSE])
                  , label = test$target)

# Variable selection based on feature importance ----
# https://cran.r-project.org/web/packages/xgboost/vignettes/xgboostPresentation.html
# https://xgboost.readthedocs.io/en/latest/R-package/xgboostPresentation.html
xgb <- xgboost(data = tr,
               eta = 1,
               max_depth = 6,
               nround = 50,
               verbose = 2,
               objective = "binary:logistic",
               booster = "gbtree",
               eval_metric = "auc",
               nthread = 4
)

# Save the model
xgb.save(model = xgb, 'artifacts/pre_trained.model')
# Save feature importance list
xgb_importance <- xgb.importance(model=xgb)
save(xgb_importance, file='artifacts/importance.Rdata')

# Validation ----
# pred <- predict(xgb, te)
# roc <- roc(test$target, pred)
# roc
# 2*roc$auc-1
# plot.roc(test$target, pred)

