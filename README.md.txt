AtliQ Hardware: Sales & Supply Chain Analytics (SQL)

📌 Project Overview
This project focuses on providing data-driven insights for a hardware company (AtliQ) to improve their sales strategies and supply chain efficiency. Using a Star Schema database design, I developed complex SQL queries, stored procedures, and views to automate financial reporting and performance tracking.

🏗️ Data Architecture
The project utilizes a relational database structure consisting of:

-- Dimension Tables: dim_customer, dim_product, and dim_date for descriptive attributes.

-- Fact Tables: fact_sales_monthly, fact_act_est, fact_forecast_monthly, and fact_freight_cost to store quantitative transactions.

-- Analytics Views: Pre-calculated metrics for net_sales, gross_sales, and invoice deductions.

🚀 Key Features & SQL Logic
-- Finance Analytics: Automated the calculation of Gross Sales and Net Sales through optimized MySQL Views.

-- Supply Chain Insights: Developed stored procedures to calculate Forecast Accuracy to help reduce inventory costs.

-- Performance Tracking: Created dynamic procedures to identify Top N Products and Top N Markets by net sales and quantity sold.

-- Fiscal Reporting: Built custom functions to determine Fiscal Year and Fiscal Quarter based on specific business cycles.

🛠️ Tools Used
-- Database: MySQL

-- Modeling: MySQL Workbench (ER Diagrams)

-- Concepts: Data Modeling, Star Schema, CTEs, Window Functions, Stored Procedures, and User-Defined Functions.