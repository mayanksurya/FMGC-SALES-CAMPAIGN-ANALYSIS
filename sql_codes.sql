create database Capstone;
use capstone;

# Reading and Understanding the data
select * from dim_campaigns;
select * from dim_products;
select * from dim_stores;
select * from sales_summary;

describe dim_campaigns;
describe dim_products;
describe dim_stores;
describe sales_summary;

# 1) Join sales_summary with dim_products to get product 
# top 5 base price product and product name:
SELECT ss.base_price, dp.product_name 
FROM sales_summary ss
JOIN dim_products dp 
ON ss.product_code = dp.product_code
group by product_name,base_price
order by base_price desc
limit 5;

# 2) Total revenue before and after promotion for each product:
SELECT dp.product_name, SUM(ss.revenue_before) 
AS total_revenue_before, SUM(ss.revenue_after) 
AS total_revenue_after
FROM sales_summary ss
JOIN dim_products dp ON ss.product_code = dp.product_code
GROUP BY dp.product_name;

# 3) Total revenue before and after promotion for each campaign:
SELECT dc.campaign_name, SUM(ss.revenue_before) 
AS total_revenue_before, SUM(ss.revenue_after) 
AS total_revenue_after
FROM sales_summary ss
JOIN dim_campaigns dc ON ss.campaign_id = dc.campaign_id
GROUP BY dc.campaign_name;

# 4) Top 5 products by incremental revenue:
SELECT dp.product_name, SUM(ss.IR) AS total_incremental_revenue
FROM sales_summary ss
JOIN dim_products dp ON ss.product_code = dp.product_code
GROUP BY dp.product_name
ORDER BY total_incremental_revenue DESC
LIMIT 5;

# 5) campaigns by incremental sales units (ISU):
SELECT dc.campaign_name, SUM(ss.isu) AS total_isu
FROM sales_summary ss
JOIN dim_campaigns dc ON ss.campaign_id = dc.campaign_id
GROUP BY dc.campaign_name
ORDER BY total_isu DESC;

# 6) Products with highest quantity sold before and after promotion:
SELECT dp.product_name, SUM(ss.quantity_sold_before_promo) 
AS total_quantity_before
FROM sales_summary ss
JOIN dim_products dp ON ss.product_code = dp.product_code
GROUP BY dp.product_name
ORDER BY total_quantity_before DESC
LIMIT 5;

# 7)Products with highest quantity sold after promotion:
SELECT dp.product_name, SUM(ss.quantity_sold_after_promo) 
AS total_quantity_after
FROM sales_summary ss
JOIN dim_products dp ON ss.product_code = dp.product_code
GROUP BY dp.product_name
ORDER BY total_quantity_after DESC
LIMIT 5;

# 8)Revenue change percentage by product:
SELECT dp.product_name,
(SUM(ss.revenue_after) - SUM(ss.revenue_before)) / SUM(ss.revenue_before) * 100 
AS revenue_change_percentage
FROM sales_summary ss
JOIN dim_products dp ON ss.product_code = dp.product_code
GROUP BY dp.product_name
order by revenue_change_percentage desc
limit 5;

# 9)Total promotions by type:
SELECT promo_type, COUNT(*) AS total_promotions
FROM sales_summary
GROUP BY promo_type
order by total_promotions desc;

# 10)Average base price by category:
SELECT dp.category, AVG(ss.base_price) AS average_base_price
FROM sales_summary ss
JOIN dim_products dp ON ss.product_code = dp.product_code
GROUP BY dp.category
order by average_base_price desc;

# 11)Incremental revenue percentage by campaign:
SELECT dc.campaign_name, AVG(ss.ir_perc) AS average_ir_percentage
FROM sales_summary ss
JOIN dim_campaigns dc ON ss.campaign_id = dc.campaign_id
GROUP BY dc.campaign_name;

# 12)Total quantity sold before and after promotion for each campaign:
SELECT dc.campaign_name, 
SUM(ss.quantity_sold_before_promo) AS total_quantity_sold_before, 
SUM(ss.quantity_sold_after_promo) AS total_quantity_sold_after
FROM sales_summary ss
JOIN dim_campaigns dc ON ss.campaign_id = dc.campaign_id
GROUP BY dc.campaign_name;

# 13)Average incremental revenue by product:
SELECT dp.product_name, AVG(ss.IR) AS average_incremental_revenue
FROM sales_summary ss
JOIN dim_products dp ON ss.product_code = dp.product_code
GROUP BY dp.product_name
order by average_incremental_revenue desc;

# 14)Average incremental revenue by campaign:
SELECT dc.campaign_name, AVG(ss.IR) AS average_incremental_revenue
FROM sales_summary ss
JOIN dim_campaigns dc ON ss.campaign_id = dc.campaign_id
GROUP BY dc.campaign_name;

# 15)Top 5 products by incremental revenue percentage:
SELECT dp.product_name, AVG(ss.ir_perc) AS average_ir_percentage
FROM sales_summary ss
JOIN dim_products dp ON ss.product_code = dp.product_code
GROUP BY dp.product_name
ORDER BY average_ir_percentage DESC
LIMIT 5;
