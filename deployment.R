library(plumber)

#load the plumber array

#---load your trained models fro the saved rds
rf_model <- readRDS("models/rf_model.rds")
#linear_model<- readRDS("models/linear_model.rds")
#xgb_model <- readRDS("models/xgb_model.rds")
#comement not working well


#--- create a Plumber API---

#* @apiTitle  Used car price prediction API
#* @param Year_mfd year of maunfacture
#* @param km_drv kilometer driven
#* @param fuel_type fuel_type(petrol, diesel, etc.)
#* @param seller_type seller type (individual, dealer)
#* @param transmission Transmission type (Maunel, Automatic)
#* @param no_own Number of Owners
#* @get  /predict
#* @serializer json

function(Year_mfd,km_drv,fuel_type,seller_type,transmission,no_own){
  
  #calculate car age
  car_age <- 2025 - as.numeric(Year_mfd)
  
  #create a data frame with the input data
  new_data <- data.frame(
    km_drv = as.numeric(km_drv),
    fuel_type = as.factor(fuel_type),
    seller_type = as.factor(seller_type),
    transmission = as.factor(transmission),
    no_own = as.factor(no_own),
    car_age = car_age
    
  )
  
  #make predictions
  rf_pred <- predict(rf_model, newdata = new_data)
  linear_pred <- predict(linear_model, newdata = new_data)
  
  #prepare data for xgboost
  xgb_data <- model.matrix(~.-1, new_data)
  xgb_pred <- predict(xgb_model, newdata = xgb_data)
  
  svr_pred <- predict(svr_model, new_data = new_data)
  
  #return the prediction as a list
  list(
    randomForest = rf_pred,
    LinearRegression = linear_pred,
    YGBoost = xgb_pred,
    SVR = svr_pred
    )
}

#---Run the API ---
pr("deployment.R") %>% # Replace with the actual path to your R script if needed
  pr_run(port = 8080) # you can change the port number