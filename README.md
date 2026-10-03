# Zepto Inventory & Pricing Analysis — SQL

## Project Overview

This project analyzes a **quick-commerce inventory and pricing dataset** using MySQL.

The analysis focuses on product pricing, discounts, stock availability, inventory value, product weight, and category-level patterns to identify useful business insights from the available inventory data.

## Objective

The objective was to use SQL to:

* Explore and understand the dataset
* Clean inconsistent and invalid pricing data
* Analyze inventory and stock availability
* Compare pricing and discount patterns across categories
* Identify high-value and high-risk inventory
* Apply advanced SQL techniques to answer business questions

## Dataset

* **Source:** Kaggle — Zepto Inventory Dataset
* **Raw Records:** 3,732
* **Source Columns:** 9
* **Data Type:** Product-level inventory and pricing data
* **Database:** MySQL
* **Analysis Tool:** MySQL Workbench

The dataset contains product-level information such as category, product name, MRP, discount percentage, selling price, available quantity, weight, stock status, and package quantity.

**Dataset Source:**
[Kaggle — Zepto Inventory Dataset](https://www.kaggle.com/datasets/palvinder2006/zepto-inventory-dataset)

**Zepto:**
[Official Zepto Website](https://www.zeptonow.com/)

> Note: The dataset used in this project was downloaded from Kaggle and should not be interpreted as Zepto's internal company data.

## Data Preparation

Before analysis, I performed basic data quality checks and preparation:

* Checked total records and sample data
* Checked for NULL values
* Identified distinct product categories
* Compared in-stock and out-of-stock products
* Identified repeated product names across SKU-level records
* Removed records with invalid zero MRP values
* Converted MRP and selling price from paise to rupees
* Used SQL conditions and calculated fields for further analysis

## Key Business Questions

The analysis answers questions such as:

1. Which products have the highest discount percentages?
2. Which high-MRP products are currently out of stock?
3. Which categories hold the highest estimated available inventory value?
4. Which high-priced products receive relatively low discounts?
5. Which categories have the highest average discount?
6. How does price per gram vary across products?
7. How is inventory distributed by product weight?
8. Which categories have the highest stock-out rates?
9. Which categories hold the highest inventory value?
10. Which categories provide higher average customer savings?
11. How does discount level relate to stock availability?
12. Which products contribute the highest inventory value?
13. How do pricing and discount patterns vary across categories?
14. Which products can be classified as higher inventory risk?
15. What are the top products by inventory value within each category?
16. What percentage of total inventory value is contributed by each category?
17. Which high-value products receive significant discounts while remaining available?

## Key Insights

The analysis was used to identify:

* Categories with relatively high stock-out rates
* Categories contributing a larger share of available inventory value
* Products with high inventory value based on selling price and available quantity
* Categories with higher average discounts and customer savings
* Discount bands associated with different stock-out rates
* High-MRP products with limited or significant discounts
* Products with higher inventory risk based on availability and inventory value
* Top-value products within individual categories
* Category-level contribution to total available inventory value
* Pricing differences between MRP, selling price, and discount levels

## SQL Concepts Used

This project covers both foundational and advanced SQL concepts:

* `SELECT`, `WHERE`, `ORDER BY`
* `GROUP BY` and `HAVING`
* Aggregate functions: `SUM()`, `AVG()`, `COUNT()`
* `CASE` statements
* Conditional aggregation
* `ROUND()`
* CTEs using `WITH`
* Window functions
* `DENSE_RANK()`
* `PARTITION BY`
* Business-oriented calculated metrics
* Data cleaning and transformation

## Project Structure

```text
Zepto-Inventory-SQL/
│
├── README.md
├── zepto_inventory_analysis.sql
└── data/
    └── zepto_inventory_data.csv
```

## Important Note

This dataset represents **inventory and product listing information**, not transactional sales data.

Therefore, metrics such as inventory value are calculated using:

```text
Discounted Selling Price × Available Quantity
```

These should be interpreted as **estimated available inventory value**, not actual sales revenue.

## Outcome

This project demonstrates an end-to-end SQL workflow from **data exploration and cleaning to business-focused inventory, pricing, discount, and stock analysis**, using MySQL.
