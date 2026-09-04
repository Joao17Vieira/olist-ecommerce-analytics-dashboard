
# Olist E-commerce Analytics Dashboard

## Project Overview

This project is an end-to-end data analytics project based on the Olist Brazilian E-commerce dataset.

The goal was to transform raw e-commerce data into meaningful business insights using SQL, MySQL and Power BI. The project covers the full analytics workflow: data import, cleaning, exploratory analysis, SQL views, data modelling, DAX measures and dashboard design.

The final deliverable is an interactive Power BI dashboard with five pages covering sales, products, customers, delivery performance, customer reviews and payments.

---

## Dataset

The dataset used in this project is the public Olist Brazilian E-commerce dataset available on the plataform Kaggle.

It contains information about orders, customers, products, sellers, payments, reviews and geolocation data from a Brazilian e-commerce marketplace.

Main tables used:

- Orders
- Order items
- Customers
- Products
- Sellers
- Payments
- Reviews
- Geolocation
- Product category translation

The analysis focuses mainly on delivered orders to keep the dashboard consistent across sales, customers, delivery, reviews and payments.

---

## Tools Used

- MySQL
- SQL
- Power BI
- Power Query
- DAX
- CSV files
- Data cleaning
- Data visualization
- Business intelligence

---

## Project Workflow

The project followed these main steps:

1. Imported the raw CSV files into MySQL.
2. Renamed and organized the original tables.
3. Created clean versions of the main tables.
4. Checked for duplicates, missing values and inconsistent values.
5. Standardized product categories, cities and relevant text fields.
6. Performed exploratory data analysis using SQL.
7. Created SQL views to simplify the Power BI connection.
8. Built DAX measures for KPIs and business metrics.
9. Designed a multi-page Power BI dashboard.
10. Extracted business insights from the final report.

---

## SQL Work

The SQL part of the project includes:

- Table creation and data import
- Data cleaning
- Duplicate checks
- Standardization of text fields
- Exploratory data analysis
- Revenue analysis
- Customer and geography analysis
- Delivery performance analysis
- Review score analysis
- Payment analysis
- SQL views for Power BI

SQL scripts are available in the `sql/` folder:

```text
sql/
├── 01_create_and_import_tables.sql
├── 02_data_cleaning.sql
├── 03_eda_analysis.sql
└── 04_views_for_powerbi.sql
```
---
## Power BI Dashboard

The Power BI report contains five dashboard pages:

1. Executive Overview
2. Sales & Products
3. Customers & Geography
4. Delivery & Reviews
5. Payments

Each page was designed to answer a different business question and provide a clear view of the e-commerce operation.

A PDF export of the dashboard is available in this repository:

[View Dashboard PDF](reports/04_powerbi_dash.pdf)

The interactive `.pbix` file is hosted externally due to GitHub file size limitations:

[Download Power BI PBIX file](https://drive.google.com/file/d/1JXLsQhdQjtGTA9yuv85SEtbngYqS2sQD/view?usp=drive_link)

---

## Dashboard Pages

### 1. Executive Overview

The Executive Overview page provides a high-level summary of business performance.

Main metrics and visuals include:

- Total revenue
- Total orders
- Average ticket
- Average review score
- Delay rate
- Revenue over time
- Top product categories by revenue
- Revenue by state
- Orders by delivery status
- Review score distribution

This page gives a quick overview of the overall performance of the business.

---

### 2. Sales & Products

The Sales & Products page focuses on revenue, products and category performance.

Main metrics and visuals include:

- Total revenue
- Total orders
- Average ticket
- Average item price
- Unique products
- Top categories by revenue
- Top products by revenue
- Average price by category
- Revenue vs items sold

This page helps identify which categories and products contribute the most to revenue.

---

### 3. Customers & Geography

The Customers & Geography page analyzes customer distribution and customer behavior across Brazil.

Main metrics and visuals include:

- Total customers
- New customers
- Repeat customers
- Average orders per customer
- Customers by state
- Top states by customers
- Customers by region
- Customers over time
- Top cities by customers
- Customer distribution by state

This page highlights the geographic concentration of customers and customer growth over time.

---

### 4. Delivery & Reviews

The Delivery & Reviews page combines logistics performance with customer satisfaction.

Main metrics and visuals include:

- Total orders
- Average delivery days
- On-time delivery rate
- Late delivery rate
- Average review score
- Total reviews
- Orders by delivery status
- On-time delivery rate by month
- Review score distribution
- Average delivery time by state
- Late delivery rate by state
- Average review score by category

This page helps understand how delivery performance relates to customer satisfaction.

---

### 5. Payments

The Payments page analyzes payment behavior and payment methods.

Main metrics and visuals include:

- Total payment value
- Total transactions
- Average order payment value
- Full payment rate
- Average installments
- Payment value by payment type
- Payment value over time
- Transactions by installments
- Average order value by payment type
- Top states by payment value
- Payment type share by customer state

This page provides insights into how customers pay and how payment behavior varies by method and geography.

---

## Dashboard Screenshots

### Executive Overview

![Executive Overview](images/01_executive_overview.png)

### Sales & Products

![Sales & Products](images/02_sales_products.png)

### Customers & Geography

![Customers & Geography](images/03_customers_geography.png)

### Delivery & Reviews

![Delivery & Reviews](images/04_delivery_reviews.png)

### Payments

![Payments](images/05_payments.png)

---

## Key Metrics Created in Power BI

Some of the main DAX measures created for the dashboard include:

- Total Revenue
- Total Orders
- Average Ticket
- Average Item Price
- Total Customers
- New Customers
- Repeat Customers
- Repeat Customer Rate
- Average Orders per Customer
- Average Delivery Days
- Delayed Orders
- On-time Delivery Rate
- Late Delivery Rate
- Total Reviews
- Average Review Score
- Positive Review Rate
- Negative Review Rate
- Total Payment Value
- Total Payment Transactions
- Total Paid Orders
- Average Order Payment Value
- Average Installments
- Full Payment Rate

---

## Key Insights

Some of the main insights from the analysis:

- São Paulo is the strongest state in terms of customers, orders, revenue and payment value.
- The Southeast region concentrates the largest share of customers.
- Credit card is the dominant payment method in the dataset.
- Many customers use installment payments, which is common in the Brazilian market.
- Most orders were delivered before or within the estimated delivery date.
- The average review score is generally positive.
- Delayed deliveries remain an important operational metric to monitor.
- The repeat customer rate is low, suggesting an opportunity for retention strategies.
- Categories such as health & beauty, watches & gifts and bed, bath & table are among the strongest revenue contributors.
- Customer activity and revenue grew significantly over time until the final complete months of the dataset.

---

## Data Modelling Notes

During the Power BI development, some additional modelling steps were needed:

- SQL views were created to simplify the data model.
- DAX measures were created for reusable KPIs.
- Power Query was used to prepare dashboard-specific tables.
- Payment and review tables were enriched with order, customer and product fields to improve filtering.
- Delivered orders were used as the main analytical scope to keep pages consistent.
- Date hierarchy fields were created to improve filtering by year and month.
- Some incomplete final months were excluded from time-series visuals to avoid misleading drops.

---

## Business Questions Answered

This dashboard helps answer questions such as:

- What is the total revenue generated by delivered orders?
- Which product categories generate the most revenue?
- Which products perform best?
- Where are customers located?
- Which states and cities have the highest customer concentration?
- How many customers make repeat purchases?
- How long do deliveries take on average?
- Which states have higher delivery delays?
- How are customers rating their orders?
- Which categories have the best average review scores?
- What are the most used payment methods?
- How common are installment payments?
- Which states generate the highest payment value?

---

## What I Learned

Through this project, I practiced:

- Working with real-world relational data.
- Importing and preparing e-commerce data in MySQL.
- Cleaning and standardizing data using SQL.
- Writing SQL queries for exploratory data analysis.
- Creating SQL views for dashboarding.
- Connecting MySQL to Power BI.
- Using Power Query for data preparation.
- Creating DAX measures for business KPIs.
- Building a multi-page dashboard in Power BI.
- Handling filtering and relationship issues between tables.
- Designing dashboards with a consistent layout and visual style.
- Communicating insights in a business-oriented way.

---

## Future Improvements

Possible future improvements include:

- Build a dedicated star schema for a cleaner Power BI model.
- Add a revenue and order volume forecasting page.
- Add customer segmentation analysis.
- Analyze seller performance in more detail.
- Add more advanced delivery delay analysis.
- Publish the report through Power BI Service.
- Build an AI assistant capable of answering business questions about the dataset using natural language.
- Add automated insight generation using LLMs.

---

## Repository Structure

```text
olist-ecommerce-analytics-dashboard/
│
├── README.md
│
├── sql/
│   ├── 01_data_cleaning.sql
│   ├── 02_eda_analysis.sql
│   └── 03_views_for_powerbi.sql
│
├── reports/
│   └── Olist_Ecommerce_Dashboard.pdf
│
├── images/
│   ├── 01_executive_overview.png
│   ├── 02_sales_products.png
│   ├── 03_customers_geography.png
│   ├── 04_delivery_reviews.png
│   └── 05_payments.png
│
└── data/
    └── README.md
