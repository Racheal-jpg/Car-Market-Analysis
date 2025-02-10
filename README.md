# Car Market Analysis

Develop a predictive model for used car valuation, leveraging key features such as make and model, year of manufacture, mileage, fuel type, transmission type, and other relevant attributes.

### ***`Data Cleaning and Preprocessing of Car Datasets`***

This R script performs data cleaning and preprocessing on four car datasets (car_1, Car_2, Car_3, and Car_4) before combining them into a single dataset. The script uses the \`dplyr\` and \`tidyr\` libraries for data manipulation.

#### Libraries

\* dplyr: For data manipulation and transformation.

\* tidyr: For tidying data.

-   Data Preprocessing Steps

The script performs the following steps for each dataset:

1.  Column Reordering:

The columns of each dataset are reordered to ensure consistency across all datasets before combining. The desired order is: Name, Year_mfd, km_drv, fuel_type, seller_type, transmission, no_own, Selling_price.

2\. Column Renaming:

### Columns are renamed for clarity and consistency:

\* name/ Car_Name / Make and Model(combined) / Name -\> "Name"

\* year / Year-\> Year_mfd"

\* km_driven / Kms_Driven/ Kilometer -\> km_drv

\* fuel / Fuel_Type / Fuel Type -\> fuel_type

\* seller_type / Seller_Type -\> seller_type

\* transmission / \`Transmission -\> transmission

\* owner / Owner -\> no_own

\* selling_price / Selling_Price / Price -\> Selling_price

\* Present_Price(from Car_4) is also included.

3\. Data Type Conversion and Cleaning:

-   Car_2:

\* The Owner column is recoded to more descriptive values (e.g., "0" to "First owner").

\* The Selling_price column is converted from a double to a numeric type after multiplying by 10000 and rounding to two decimal places. This step assumes the original values were in a different unit (e.g., lakhs or thousands).

-   Car_4:

\* The Make and Model columns are combined into a single Name column.

\* The Owner column is recoded to consistent values, handling variations like "First," "Second," "Third," "Fourth," and "4 or More."

4\. Data Combination:

The four processed data frames (car_1, Car_2, Car_3, and Car_4) are combined into a single data frame called combined_cars using rbind().

5\. Data Inspection:

The script includes View() and str() calls to inspect the resulting combined_cars data frame and check its structure. This allows for verification of the data cleaning and preprocessing steps.

\## Usage

1\. Ensure you have R and RStudio installed.

2\. Install the dplyr and tidyr packages if you haven't already:

\`\`\`R

install.packages(c("dplyr", "tidyr"))

4\. The script will create a "combined_cars.csv" file in your working directory. The data will also be read back into R and stored in the "my_data" variable.

Output

The script generates a CSV file named "combined_cars.csv"containing the combined and preprocessed car data. It also prints the first few rows of the read-back data to the console.
