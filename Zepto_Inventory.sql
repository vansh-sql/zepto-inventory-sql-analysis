use zepto_inventory_analysis;
Drop Table if exists Zepto;
Create Table Zepto(
sku_id serial Primary Key,
Category Varchar(120),
name Varchar(150) Not Null,
mrp Numeric(8,2),
discountPercent Numeric(5,2),
availableQuantity integer,
discountedSellingPrice Numeric(8,2),
weightInGms  integer,
outOfStock Boolean,
quantity  integer  
);


-- Data Exploration -- 
SELECT * FROM zepto_inventory_analysis.zepto_invertry_data;

-- Count Of Rows-- 
select count(*) From zepto_inventory_analysis.zepto_invertry_data;

--  sample data -- 
Select * From zepto_inventory_analysis.zepto_invertry_data
Limit 10;

-- Null Vlues-- 
Select * From zepto_inventory_analysis.zepto_invertry_data
Where Name Is null 
Or 
Category Is null
Or 
mrp Is null
Or 
discountPercent Is null
Or 
availableQuantity Is null
Or 
discountedSellingPrice Is null
Or 
weightInGms Is null
Or 
outOfStock Is null
Or 
quantity Is null;

-- different product Categories -- 
Select distinct Category 
From zepto_inventory_analysis.zepto_invertry_data
order by Category;

-- Product in stock vs out of stock-- 
SELECT outOfStock, COUNT(sku_id) AS total_products
FROM zepto_inventory_analysis.zepto_invertry_data
GROUP BY outOfStock;

-- Product Names Multiple Time -- 
select name,count(sku_id) As "Number Of Sku"
From zepto_inventory_analysis.zepto_invertry_data
group by Name 
Having Count(sku_id)>1
Order by count(sku_id)  DESC;

-- Data Cleaning -- 
-- Product With Price = 0-- 
select * From zepto_inventory_analysis.zepto_invertry_data
where mrp = 0 Or discountedSellingPrice = 0;

DELETE FROM zepto_inventory_analysis.zepto_invertry_data
WHERE mrp = 0;

-- covert  Piase to Ruppes-- 
SET SQL_SAFE_UPDATES = 0;

UPDATE zepto_inventory_analysis.zepto_invertry_data
SET 
    mrp = mrp / 100.0,
    discountedSellingPrice = discountedSellingPrice / 100.0;

SET SQL_SAFE_UPDATES = 1;

select mrp, discountedSellingPrice From zepto_inventory_analysis.zepto_invertry_data;

-- Q1. Find the top 10 best-value products based on the discount percentage.
SELECT DISTINCT name, mrp, discountPercent
FROM zepto_inventory_analysis.zepto_invertry_data
ORDER BY discountPercent DESC
LIMIT 10;

-- Q2.What are the Products with High MRP but Out of Stock-- 
SELECT DISTINCT name, mrp 
FROM zepto_inventory_analysis.zepto_invertry_data
WHERE outOfStock = 'TRUE' AND mrp > 300
ORDER BY mrp DESC;

-- Q3.Calculate Estimated Revenue for each category--
SELECT category, SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM zepto_inventory_analysis.zepto_invertry_data
GROUP BY category
ORDER BY total_revenue;

-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.
SELECT DISTINCT name, mrp, discountPercent
FROM zepto_inventory_analysis.zepto_invertry_data
WHERE mrp > 500 AND discountPercent < 10
ORDER BY mrp DESC, discountPercent DESC;

-- Q5. Identify the top 5 categories offering the highest average discount percentage.
SELECT category,
ROUND(AVG(discountPercent),2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

-- Q6. Find the price per gram for products above 100g and sort by best value.
SELECT DISTINCT name, weightInGms, discountedSellingPrice,
ROUND(discountedSellingPrice/weightInGms,2) AS price_per_gram
FROM zepto_inventory_analysis.zepto_invertry_data
WHERE weightInGms >= 100
ORDER BY price_per_gram;

-- Q7.Group the products into categories like Low, Medium, Bulk.--
SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 THEN 'Low'
	WHEN weightInGms < 5000 THEN 'Medium'
	ELSE 'Bulk'
	END AS weight_category
FROM zepto_inventory_analysis.zepto_invertry_data;

-- Q8.What is the Total Inventory Weight Per Category--
SELECT category,
SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto_inventory_analysis.zepto_invertry_data
GROUP BY category
ORDER BY total_weight;

-- Q9.Which product categories have the highest stock-out rate-- 
SELECT Category,COUNT(*) AS total_products,
    SUM(CASE WHEN outOfStock = TRUE THEN 1 ELSE 0 END) AS out_of_stock_products,
    ROUND(
        SUM(CASE WHEN outOfStock = TRUE THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*), 2
    ) AS stock_out_rate
FROM zepto_inventory_analysis.zepto_invertry_data
GROUP BY Category
ORDER BY stock_out_rate DESC;


-- Q.10Which product categories hold the highest value of available inventory-- 
SELECT Category,
    ROUND(SUM(discountedSellingPrice * availableQuantity), 2) AS inventory_value
FROM zepto_inventory_analysis.zepto_invertry_data
WHERE outOfStock = FALSE
GROUP BY Category
ORDER BY inventory_value DESC;

-- Q.11 Which categories provide the highest average customer savings through discounts-- 
SELECT Category,
    ROUND(AVG(mrp - discountedSellingPrice), 2) AS avg_saving,
    ROUND(SUM(mrp - discountedSellingPrice), 2) AS total_potential_saving
FROM zepto_inventory_analysis.zepto_invertry_data
GROUP BY Category
ORDER BY avg_saving DESC;

-- Q12 How does discount level relate to product stock availability -- 
SELECT
    CASE
        WHEN discountPercent < 10 THEN '0-9%'
        WHEN discountPercent < 20 THEN '10-19%'
        WHEN discountPercent < 30 THEN '20-29%'
        ELSE '30%+'
    END AS discount_band,

    COUNT(*) AS total_products,
    SUM(CASE WHEN outOfStock = TRUE THEN 1 ELSE 0 END) AS out_of_stock,
    ROUND(
        SUM(CASE WHEN outOfStock = TRUE THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*), 2) AS stock_out_rate
FROM zepto_inventory_analysis.zepto_invertry_data
GROUP BY discount_band
ORDER BY stock_out_rate DESC;

-- Q13 Top 10 Products by Inventory Value -- 
SELECT name, Category, discountedSellingPrice, availableQuantity,
    ROUND(
        discountedSellingPrice * availableQuantity, 2
    ) AS inventory_value
FROM zepto_inventory_analysis.zepto_invertry_data
WHERE outOfStock = FALSE
ORDER BY inventory_value DESC
LIMIT 10;

-- Q14 Category Pricing Strategy  How do average MRP, selling price and discount vary across product categories -- 
SELECT Category,
    COUNT(*) AS total_products,
    ROUND(AVG(mrp), 2) AS avg_mrp,
    ROUND(AVG(discountedSellingPrice), 2) AS avg_selling_price,
    ROUND(AVG(discountPercent), 2) AS avg_discount
FROM zepto_inventory_analysis.zepto_invertry_data
GROUP BY Category
ORDER BY avg_mrp DESC;

-- Which products should be considered high inventory risk based on stock availability and inventory value -- 
SELECT name, Category, availableQuantity, discountedSellingPrice,
    ROUND(
        discountedSellingPrice * availableQuantity, 2) AS inventory_value,
    CASE
        WHEN outOfStock = TRUE THEN 'Out of Stock'
        WHEN availableQuantity <= 5
             AND discountedSellingPrice * availableQuantity >= 1000
             THEN 'High Risk'
        WHEN availableQuantity <= 10
             THEN 'Medium Risk'
        ELSE 'Normal'
    END AS inventory_risk
FROM zepto_inventory_analysis.zepto_invertry_data
ORDER BY inventory_value DESC;

-- Q16 What are the top 3 products by inventory value within each category -- 
WITH product_inventory AS (SELECT name, Category,
        ROUND(
            discountedSellingPrice * availableQuantity, 2
        ) AS inventory_value
    FROM zepto_inventory_analysis.zepto_invertry_data
    WHERE outOfStock = FALSE
),
ranked_products AS (SELECT name, Category, inventory_value,
        DENSE_RANK() OVER (
            PARTITION BY Category
            ORDER BY inventory_value DESC
        ) AS category_rank
    FROM product_inventory
)
SELECT Category, name, inventory_value,category_rank
FROM ranked_products
WHERE category_rank <= 3
ORDER BY Category, category_rank;

-- Q17 What percentage of total available inventory value is contributed by each category-- 
WITH category_inventory AS (SELECT Category,
        SUM(discountedSellingPrice * availableQuantity) AS inventory_value
    FROM zepto_inventory_analysis.zepto_invertry_data
    WHERE outOfStock = FALSE
    GROUP BY Category
)
SELECT Category,
    ROUND(inventory_value, 2) AS inventory_value,
    ROUND(
        inventory_value * 100.0 /
        SUM(inventory_value) OVER (), 2
    ) AS contribution_percent
FROM category_inventory
ORDER BY contribution_percent DESC;

-- Q18.Which high-value products receive significant discounts, and are they currently available-- 
SELECT name, Category, mrp, discountedSellingPrice, discountPercent,
    availableQuantity,
    outOfStock
FROM zepto_inventory_analysis.zepto_invertry_data
WHERE mrp >= 1000
  AND discountPercent >= 20
ORDER BY discountPercent DESC, mrp DESC;



