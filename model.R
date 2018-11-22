library(data.table)
library(xgboost)
library(DiagrammeR)

# Load data ----
load('stage/dev.Rdata')
load('stage/test.Rdata')

# Corvert to xgb.DMatrix format
train <- list(train = as.matrix(dev[, -"target", with=FALSE])
            ,label = dev$target
)
train <- xgb.DMatrix(data=train$train, label=train$label)
test2 <- list(test = as.matrix(test[, -"target", with=FALSE])
              ,label = test$target
)
test2 <- xgb.DMatrix(data=test2$test, label=test2$label)

# Variable selection based on feature importance ----
# https://cran.r-project.org/web/packages/xgboost/vignettes/xgboostPresentation.html
# https://xgboost.readthedocs.io/en/latest/R-package/xgboostPresentation.html
xgb <- xgboost(data = train,
               eta = 1,
               max_depth = 6,
               nround = 5,
               verbose = 2,
               objective = "binary:logistic",
               nthread = 4
)

xgb_importance <- xgb.importance(model=xgb)
print(xgb_importance)
xgb.plot.importance(importance_matrix = xgb_importance)
xgb.save(model = xgb, 'artifacts/pre_trained.model')
save(xgb_importance, file = 'artifacts/xgb_importance.Rdata')

# Validation ----
pred <- predict(xgb, train)
pred <- ifelse(pred > 0.5, 1, 0)

# Retrain then model with the top 6 features ----
features <- xgb_importance[1:6,]$Feature

