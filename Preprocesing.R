car_1<-readr::read_csv("C://Users//USER//OneDrive//Documents//Vechicle_dataset//used_cars_data//Car_1.csv")
Car_2<-readr::read_csv("C://Users//USER//OneDrive//Documents//Vechicle_dataset//used_cars_data//Car_2.csv")
Car_3<-readr::read_csv("C://Users//USER//OneDrive//Documents//Vechicle_dataset//used_cars_data//Car_3.csv")
Car_4<-readr::read_csv("C://Users//USER//OneDrive//Documents//Vechicle_dataset//used_cars_data//Car_4.csv")
 
library(dplyr)
library(tidyr)

#Reorder for Car_1
car_1 <- car_1[, c("name","year","km_driven","fuel","seller_type","transmission","owner","selling_price")]

#Rename the column
colnames(car_1)<- c("Name","Year_mfd","km_drv","fuel_type","seller_type","transmission","no_own","Selling_price")

View(car_1)


#re_coding (car_2)
vehicle_dataset<-Car_2 %>%
  mutate(
    Owner = case_when(
      Owner == "0" ~ "First owner",
      Owner == "1" ~ "Second Owner",
      Owner == "3" ~ "Fourth & above owner",
      TRUE ~ as.character(Owner)
    )
  )


View(vehicle_dataset)
 
Car_2 <- vehicle_dataset

View(Car_2)

#Reorder for Car_2
Car_2 <- Car_2[, c("Car_Name","Year","Kms_Driven","Fuel_Type","Seller_Type","Transmission","Owner","Selling_Price")]

#Rename the column
colnames(Car_2)<- c("Name","Year_mfd","km_drv","fuel_type","seller_type","transmission","no_own","Selling_price")



#changing double to thousand for car_2 

to_thousands <- function(x) {
  paste0(round(x*10000, 2)) 
}
selling_price <- sapply(Car_2$Selling_price, to_thousands)

#changing to numeric(car_2)
selling_price <- as.numeric(selling_price)

View(selling_price)

Car_2$Selling_price<-selling_price

View(Car_2)

str(Car_2)



#Reorder for Car_3

Car_3 <- Car_3[, c("name","year","km_driven","fuel","seller_type","transmission","owner","selling_price")]


#Rename the column
colnames(Car_3)<- c("Name","Year_mfd","km_drv","fuel_type","seller_type","transmission","no_own","Selling_price","Present_Price")


#combining two colums together for car_4
  Car_4$Name<- paste(Car_4$Make,Car_4$Model, sep = " ")
print(Car_4)

#re_coding (car_4)
vehicle_dataset_4<-Car_4 %>%
  mutate(
    Owner = case_when(
      Owner == "First" ~ "First owner",
      Owner == "Second" ~ "Second Owner",
      Owner == "Third" ~ "Third owner",
      Owner == "Fourth" ~ "Fourth & above owner",
      Owner == "4 or More" ~ "Fourth & above owner",
      TRUE ~ as.character(Owner)
    )
  )

Car_4 <- vehicle_dataset_4

#Reorder for Car_4

Car_4 <- Car_4[, c("Name","Year","Kilometer","Fuel Type","Seller Type","Transmission","Owner","Price")]

#Rename the column
colnames(Car_4)<- c("Name","Year_mfd","km_drv","fuel_type","seller_type","transmission","no_own","Selling_price","Present_Price")



# Merge the tables using a loop
merged_cars <- Reduce(function(x, y) merge(x, y, all = TRUE), list(car_1,Car_2,Car_3,Car_4))

# View the merged data frame
View(merged_cars)

