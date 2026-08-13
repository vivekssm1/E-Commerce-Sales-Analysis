# 🛒 E-Commerce Sales Analytics Dashboard

An interactive **E-Commerce Sales Analytics Dashboard** built using **R, Shiny, Plotly, and ggplot2**. This project performs data cleaning, exploratory data analysis (EDA), and interactive visualization on a large e-commerce transaction dataset.

The dashboard helps analyze **revenue trends, country-wise sales, product performance, order values, customers, and transaction patterns**.

---

## 📌 Project Overview

This project was developed as part of **Data Science with R** coursework.

The main objective is to transform raw e-commerce transaction data into meaningful business insights through:

* Data cleaning and preprocessing
* Exploratory Data Analysis (EDA)
* Revenue analysis
* Country-wise sales analysis
* Product performance analysis
* Order value distribution analysis
* Interactive data visualization
* Interactive filtering through a Shiny dashboard

---

## 📊 Dataset

The project uses an e-commerce transaction dataset containing **541,909 records** and 8 attributes.

### Dataset Features

| Column        | Description                    |
| ------------- | ------------------------------ |
| `InvoiceNo`   | Unique invoice/order number    |
| `StockCode`   | Product identification code    |
| `Description` | Product description            |
| `Quantity`    | Number of units purchased      |
| `InvoiceDate` | Date and time of transaction   |
| `UnitPrice`   | Price per unit                 |
| `CustomerID`  | Customer identification number |
| `Country`     | Customer's country             |

### Dataset Source

The original dataset is included in this repository as `data.csv`.

---

## 🧹 Data Cleaning

The following preprocessing steps were performed:

1. Checked for missing values.
2. Replaced missing `CustomerID` values with `Unknown`.
3. Identified and removed duplicate records.
4. Converted `InvoiceDate` into date-time format.
5. Converted `CustomerID` into character format.
6. Removed cancelled transactions.
7. Removed transactions with non-positive quantities.
8. Created a new `TotalAmount` feature.

### Revenue Calculation

```r
TotalAmount = Quantity * UnitPrice
```

This value is used throughout the project to calculate revenue and sales performance.

---

## 🔎 Exploratory Data Analysis

The project performs several EDA tasks:

* Number of unique customers
* Number of unique products
* Quantity distribution
* Product price distribution
* Country transaction frequency
* Highest and lowest product prices
* Average order value
* Monthly transaction volume
* Monthly revenue
* Country-wise revenue
* Best-selling products
* Worst-performing products
* Order value distribution

---

## 📈 Dashboard Features

The interactive dashboard contains six major sections.

### 1. Overview

Provides a quick business summary using KPI cards:

* Total Revenue
* Total Orders
* Average Order Value
* Unique Customers
* Unique Products
* Number of Countries

It also displays:

* Monthly revenue trend
* Top countries
* Best-selling products
* Order value distribution

---

### 2. Revenue Trend

Displays:

* Monthly revenue trend
* Monthly transaction volume
* Interactive Plotly charts

This helps identify changes in sales performance over time and potential seasonal patterns.

---

### 3. Country Sales

Provides country-level sales analysis.

Features include:

* Revenue by country
* Top N country selection
* Country summary table
* Number of orders
* Total revenue

---

### 4. Product Analysis

Analyzes product performance using:

* Best-selling products
* Worst-performing products
* Units sold
* Revenue
* Number of customers
* Interactive product table

---

### 5. Order Distribution

Analyzes the value of individual orders.

Includes:

* Order value distribution
* Order value bands
* Minimum order value
* Maximum order value
* Mean order value
* Median order value
* Quartiles
* Orders above £500
* Orders below £10
* Boxplot for order values

---

### 6. Raw Data

Provides an interactive table containing the cleaned transaction data.

Users can:

* Search/filter records
* Browse transactions
* View invoice information
* View product information
* View customer information
* View calculated transaction amount

---

## 🎛️ Interactive Filters

The dashboard provides a **Country filter** that dynamically updates the dashboard.

It also provides a **Top N slider** allowing users to select the number of countries or products displayed in relevant charts.

---

## 🛠️ Technologies Used

### Programming Language

* **R**

### R Packages

* `shiny`
* `shinydashboard`
* `ggplot2`
* `dplyr`
* `tidyverse`
* `lubridate`
* `scales`
* `DT`
* `plotly`

### Visualization

* ggplot2
* Plotly
* Interactive tables
* KPI cards
* Bar charts
* Line charts
* Histograms
* Boxplots

---

## 📁 Project Structure

```text
R presentation/
│
├── data.csv
├── EcommerceSales.R
├── R Assignment.R
├── Ecommerce_Sales.pptx
├── Data set link where to download.txt
├── .RData
└── .Rhistory
```

### Important Files

**`EcommerceSales.R`**
Main Shiny application containing the UI, server logic, data processing, and interactive visualizations.

**`R Assignment.R`**
Contains the data cleaning, EDA, and graphical analysis performed during the project.

**`data.csv`**
Raw e-commerce transaction dataset.

**`Ecommerce_Sales.pptx`**
Project presentation.

---

## 🚀 How to Run the Project

### 1. Install R

Download and install R from the official R website.

### 2. Install RStudio

RStudio is recommended for running and developing the project.

### 3. Install Required Packages

Run the following command in RStudio:

```r
install.packages(c(
  "shiny",
  "shinydashboard",
  "ggplot2",
  "dplyr",
  "tidyverse",
  "lubridate",
  "scales",
  "DT",
  "plotly"
))
```

### 4. Clone the Repository

```bash
git clone https://github.com/YOUR-USERNAME/ecommerce-sales-analytics-r.git
```

### 5. Open the Project

Open `EcommerceSales.R` in RStudio.

Make sure `data.csv` is located in the same project directory.

### 6. Run the Dashboard

Run:

```r
shiny::runApp()
```

Or open `EcommerceSales.R` in RStudio and click:

**Run App**

---

## ⚠️ Important: File Path

The current version of the R script contains a local Windows path similar to:

```r
read.csv("C:/Users/vivek/Desktop/R presentation/data.csv")
```

For GitHub, this should be changed to a relative path:

```r
salesdata <- read.csv("data.csv", stringsAsFactors = FALSE)
```

This allows the project to work on other computers.

---

## 💡 Key Business Insights

The dashboard is designed to help identify:

* Overall revenue performance
* Monthly sales trends
* High-performing countries
* Best-selling products
* Poor-performing products
* Customer purchasing behavior
* Typical order value
* High-value/B2B orders
* Potential opportunities for product and market optimization

---

## 🎯 Project Objectives

The project demonstrates practical knowledge of:

* Data preprocessing
* Data cleaning
* Data transformation
* Exploratory Data Analysis
* Statistical summaries
* Data visualization
* Interactive dashboards
* Business intelligence
* R programming
* Shiny application development

---

## 🔮 Future Improvements

Possible improvements include:

* Add date-range filtering
* Add customer segmentation
* Add RFM analysis
* Add sales forecasting
* Add customer lifetime value analysis
* Add profit/margin analysis
* Add geographic visualization
* Add downloadable reports
* Deploy the Shiny application online
* Add authentication for dashboard users

---

## 👨‍💻 Author

**Vivek Kumar**

MCA — Artificial Intelligence & Machine Learning
Data Science with R Project

---

## ⭐ If You Like This Project

If you find this project useful, consider giving the repository a ⭐ on GitHub.

---
