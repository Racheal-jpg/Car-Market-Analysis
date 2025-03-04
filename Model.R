library(ggplot2)
library(randomForest)
library(xgboost)
library(e1071)
library(pracma)
library(ggcorrplot)

#Data collection
combined_cars<- readr::read_csv("combined_cars.csv")


#feature Engineering
#convert Categorical variables to factors
combined_cars$fuel_type <- as.factor(combined_cars$fuel_type)
combined_cars$seller_type <- as.factor(combined_cars$seller_type)
combined_cars$transmission <- as.factor(combined_cars$transmission)
combined_cars$no_own <- as.factor(combined_cars$no_own)


combined_cars$car_age <- 2025 - combined_cars$Year_mfd#car age instead of year manufactured

#feature selection
numeric_cols <- names(combined_cars)[sapply(combined_cars,is.numeric)]
cor_matrix <- cor(combined_cars[, numeric_cols], use = "pairwise.complete.obs")#Handle NAs in correlation
ggcorrplot(cor_matrix, method = "square", digits = 2, lab = TRUE)

#keeping the numerical features with the corr values > 0.2 
high_cor_feature <- names(cor_matrix[abs(cor_matrix["Selling_price",]) > 0.2, "Selling_price"])
print(high_cor_feature)

#feature selection for categorical values
categorical_cols <- names(combined_cars)[sapply(combined_cars, is.factor)]

anova_result <- list() #store Anova results
for (col in categorical_cols) {
  model <- aov(Selling_price ~ combined_cars[[col]], data = combined_cars)
  anova_result[[col]] <- summary(model)
  print(paste("ANOVa for", col, ":"))
  print(anova_result[[col]])
}

#keep features with p-values < 0.05
significant_categorical <- names(anova_result)[sapply(anova_result, function(x) x[[1]][["Pr(>F)"]][1] < 0.05)]
print(significant_categorical)


#combine the features
selected_features <- c(high_cor_feature,
                       significant_categorical)#combine
selected_features <- unique(selected_features) #Remove duplicates very necessary please write

combined_cars_selected <- combined_cars[, c("Selling_price",selected_features)]#includes target variables
print(names(combined_cars_selected))


# Now Splitting the data.
set.seed(300) # For Reproducibility
n <- nrow(all_cars)
train_idx <- sample(1:n , 0.7 * n)
# split into train and test data
train_data <- all_cars[train_idx, ]
test_data <- all_cars[-train_idx, ]

# Model Building: for building this model we are going to be considering three model algorithms[Logistic Regression, Random Forest, Extreme Gradient Boosting].
# Linear Regression
linear_model <- lm(Selling_price ~ ., data = train_data)
summary(linear_model)

# Random Forest
rf_model <- randomForest(Selling_price ~ ., data = train_data, ntree = 100, importance=TRUE)
print(rf_model)

# Extreme Gradient Boosting
train_matrix <- model.matrix(Selling_price ~ .-1, data = train_data)
test_matrix <- model.matrix(Selling_price ~ .-1, data = test_data)

xgb_model <- xgboost(data = train_matrix, label = train_data$Selling_price, nrounds = 100, objective = "reg:squarederror")

# Model Evaluation
linear_predictions <- predict(linear_model, newdata = test_data)
rf_predictions <- predict(rf_model, newdata = test_data)
xgb_predictions <- predict(xgb_model, newdata = test_matrix)

# Evaluation metrics: Function calculate Root mean squared value
calculate_rmse <- function(actual, predicted) {
  sqrt(mean((actual - predicted)^2, na.rm = TRUE))}

linear_rmse <- calculate_rmse(test_data$Selling_price, linear_predictions)
rf_rmse <- calculate_rmse(test_data$Selling_price, rf_predictions)
xgb_rmse <- calculate_rmse(test_data$Selling_price, xgb_predictions)

cat("Linear Regression RMSE:", linear_rmse, "\n")
cat("Random Forest RMSE:", rf_rmse, "\n")
cat("XGBoost RMSE:", xgb_rmse, "\n")

# Plotting predicted vs. actual values (example for Random Forest)
plot(test_data$Selling_price, rf_predictions, 
     xlab = "Actual Selling Price", ylab = "Predicted Selling Price",
     main = "Actual vs. Predicted (Random Forest)", col="blue", pch=16)
abline(0, 1, col = "red")

# Further Evaluation: Example - Feature Importance for Random Forest
importance(rf_model)
varImpPlot(rf_model)

# Compare model performance visually 
rmse_df <- data.frame(
  Model = c("Linear Regression", "Random Forest", "XGBoost"),
  RMSE = c(linear_rmse, rf_rmse, xgb_rmse)
)

ggplot(rmse_df, aes(x = Model, y = RMSE)) +
  geom_col(fill = "skyblue", color = "black") +
  labs(title = "RMSE Comparison", x = "Model", y = "RMSE") + theme_bw()

#lets test with random rows
set.seed(20)
rmd_rows <- combined_cars[sample(nrow(combined_cars), size = 5), ]

rf_predictions<-predict(rf_model, newdata = rdm_rows)
linear_predictions<- predict(linear_model, newdata = random_rows)

# create a data frame for easy comparison
prediction_df <- data.frame(
  Actual = random_rows$Selling_price,
  randomForest = rf_predictions,
  LinearRegression = linear_predictions
)

#print the predictions
print(prediction_df)

