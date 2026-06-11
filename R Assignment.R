#Library Installation
library(tidyverse) 
library(ggplot2)
library(dplyr)
library(shinydashboard)
library(scales)
library(DT)
library(plotly)
library(shiny)
library(lubridate)
#CSV Dataset Import
salesdata <- read.csv("C:/Users/vivek/Desktop/R presentation/data.csv")
head(salesdata)
summary(salesdata)
#-----------------------Step 1: Data Cleaning ------------------------------------
#1-----------------------------1.Identify Null Values and Handle Them
colSums(is.na(salesdata))


# Replace missing CustomerID with 'Unknown'
salesdata$CustomerID[is.na(salesdata$CustomerID)] <- "Unknown"


#------------------------------2. Find and Remove Duplicate Records------------------
# Check duplicate rows
sum(duplicated(salesdata))  #---5268 duplicate rows 


# Remove duplicates
salesdata <- salesdata %>%distinct()


# Verify duplicates removed
sum(duplicated(salesdata)) #---all duplicate rows removed 

#------------------------------3. Fix Incorrect Data Types-------------------------

# Convert InvoiceDate into Date-Time format
salesdata$InvoiceDate <- mdy_hm(salesdata$InvoiceDate)
head(salesdata$InvoiceDate) #--String to Date-time-format

# Convert CustomerID into character
salesdata$CustomerID <- as.character(salesdata$CustomerID) #---CustomerID is an identifier, not a numeric value.

# Check updated structure
str(salesdata)

#----------------------------4.Filter Out Returns or Cancelled Transactions--------
# Remove cancelled/returned transactions
salesdata <- salesdata %>%
  filter(!grepl("^C", InvoiceNo), Quantity > 0)#---invoiceNo - start with C and Quantity less than 0

# View cleaned data
head(salesdata)

#----------------------------5.Create a New Meaningful Column------------------
#Create TotalAmount Column
salesdata <- salesdata %>%
  mutate(TotalAmount = Quantity * UnitPrice)

# View updated dataset
head(salesdata)

#--------------Final Cleaned Dataset Check
# Dataset structure
str(salesdata)

# First few rows
head(salesdata)

# Final summary
summary(salesdata)

#-----------------Data Cleaning Done :)--------------------

#-----------Phase 2 — Exploratory Data Analysis (EDA) in R Studio

#----------------------1. Unique Customers and Products
length(unique(salesdata$CustomerID))#----Unique customers
length(unique(salesdata$StockCode))#----Unique Products

#----------------------2. Distribution of Transaction Quantities and Prices
summary(salesdata$Quantity)
summary(salesdata$UnitPrice)

#----------------------3. Countries Appearing Most Frequently
country_count <- salesdata %>%
  count(Country, sort = TRUE)

head(country_count, 10)

#----------------------4. Products with Unusually High or Low Prices
summary(salesdata$UnitPrice)
    #Extremely High Price Products
salesdata %>%
  arrange(desc(UnitPrice)) %>%
  select(Description, UnitPrice) %>%
  head(10)
    #Extremely Low Price Products
salesdata %>%
  arrange(UnitPrice) %>%
  select(Description, UnitPrice) %>%
  head(10)

#---------------------5. Average Order Value Per Transaction
  #create total amount column
sales_data <- sales_data %>%
  mutate(TotalAmount = Quantity * UnitPrice)

#Calculate Order Value Per Invoice
order_value <- salesdata %>%
  group_by(InvoiceNo) %>%
  summarise(OrderValue = sum(TotalAmount))

#Average Order Value
mean(order_value$OrderValue)

#---------------------6. Time Periods with Highest Transaction Counts
  #Extract Month
salesdata$Month <- month(salesdata$InvoiceDate,label = TRUE)
  #Count Transactions by Month
monthly_transactions <- salesdata %>%
  count(Month)

monthly_transactions

#-------------EDA DONE-------------

#-------------Phase 3 — Graphical Reports in R Studio

#--------------------------1. Show the revenue trend over time.--------------
salesdata <- salesdata %>%
  mutate(TotalAmount = Quantity * UnitPrice)

#Revenue by Month
monthly_revenue <- salesdata %>%
  group_by(Month = floor_date(InvoiceDate, "month")) %>%
  summarise(Revenue = sum(TotalAmount))

#---------Line Chart----------(ideal for time series and countinuous progression)
#Line charts are ideal for:
#                Dates
#                Months
#                Years
#                Continuous progression

ggplot(monthly_revenue,
       aes(x = Month, y = Revenue)) +
  geom_line() +
  geom_point() +
  ggtitle("Revenue Trend Over Time") +
  xlab("Month") +
  ylab("Revenue")

#-------------------2. Compare sales performance across different countries
  #Revenue by Country
country_sales <- salesdata %>%
  group_by(Country) %>%
  summarise(TotalSales = sum(TotalAmount)) %>%
  arrange(desc(TotalSales))

  #Top 10 Countries
top_countries <- head(country_sales, 10)
  #Bar Chart(A bar chart is used when you want to compare different categories.)
ggplot(top_countries,
       aes(x = reorder(Country, TotalSales),
           y = TotalSales)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  ggtitle("Top 10 Countries by Sales") +
  xlab("Country") +
  ylab("Total Sales")

#------------------------3. Identify the best and worst performing products.
  #Product Sales Summary
product_sales <- salesdata %>%
  group_by(Description) %>%
  summarise(TotalSales = sum(TotalAmount)) %>%
  arrange(desc(TotalSales))
  #Best Performing Products
best_products <- head(product_sales, 10)
best_products
  #Worst Performing Products
worst_products <- tail(product_sales, 10)
worst_products
  #Best Products Chart
ggplot(best_products,
       aes(x = reorder(Description, TotalSales),
           y = TotalSales)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  ggtitle("Top 10 Best Performing Products") +
  xlab("Products") +
  ylab("Sales")
  #Worst product sales
ggplot(worst_products,
       aes(x = reorder(Description, TotalSales),
           y = TotalSales)) +
  geom_bar(stat = "identity") +
  coord_flip() +
  ggtitle("Top 10 Worst Performing Products") +
  xlab("Products") +
  ylab("Sales")

#------------------------4. Visualise the distribution of order values.
#Calculate Order Value Per Invoice
order_values <- salesdata %>%
  group_by(InvoiceNo) %>%
  summarise(OrderValue = sum(TotalAmount))
#Histogram
ggplot(order_values,
       aes(x = OrderValue)) +
  geom_histogram(bins = 50) +
  ggtitle("Distribution of Order Values") +
  xlab("Order Value") +
  ylab("Frequency")
#Boxplot
ggplot(order_values,
       aes(y = OrderValue)) +
  geom_boxplot() +
  ggtitle("Boxplot of Order Values")
#----------------------------EDA DONE---------------------


