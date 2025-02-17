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
numeric_cols <- names(combined_cars)[sapply(all_cars,is.numeric)]
cor_matrix <- cor(combined_cars[, numeric_cols], use = "pairwise.complete.obs")#Handle NAs in correlation
print(cor_matrix)

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



