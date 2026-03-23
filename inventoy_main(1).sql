USE olist_inventory;

SHOW TABLES;

SELECT * FROM forecast_output LIMIT 5;

-- ABC_Analysis
DROP TABLE IF EXISTS abc_analysis_table;

-- Creating New ABC table
CREATE TABLE abc_analysis_table AS
WITH ProductSales AS (
    SELECT product_id, SUM(price) as total_revenue
    FROM olist_order_items_dataset
    GROUP BY product_id
),
RunningTotals AS (
    SELECT *,
    SUM(total_revenue) OVER (ORDER BY total_revenue DESC) / SUM(total_revenue) OVER () as cum_pct
    FROM ProductSales
)
SELECT *,
    CASE 
        WHEN cum_pct <= 0.70 THEN 'A (High Value)'
        WHEN cum_pct <= 0.90 THEN 'B (Medium Value)'
        ELSE 'C (Low Value)'
    END AS inventory_class
FROM RunningTotals;

SELECT * FROM abc_analysis_table 


CREATE OR REPLACE VIEW v_inventory_forecast_master AS
SELECT 
    f.ds AS forecast_date,
    f.yhat AS predicted_demand,
    f.yhat_upper AS safety_stock_limit,
    abc.inventory_class,
    p.product_category_name
FROM forecast_output f
-- Joining Product id
LEFT JOIN abc_analysis_table abc ON abc.product_id = '7c180f6386932551046452e805507d62'
LEFT JOIN olist_products_dataset p ON abc.product_id = p.product_id;

SELECT * FROM v_inventory_forecast_master LIMIT 5;

-- Null Happening
DROP VIEW IF EXISTS v_inventory_forecast_master;


CREATE OR REPLACE VIEW v_inventory_forecast_master AS
SELECT 
    f.ds AS forecast_date,
    f.yhat AS predicted_demand,
    f.yhat_upper AS safety_stock_limit,
    abc.inventory_class,
    p.product_category_name
FROM forecast_output f
CROSS JOIN (
    SELECT a.* FROM abc_analysis_table a
    WHERE a.product_id = (
        SELECT product_id 
        FROM olist_order_items_dataset 
        GROUP BY product_id 
        ORDER BY COUNT(*) DESC 
        LIMIT 1
    )
) abc
LEFT JOIN olist_products_dataset p ON abc.product_id = p.product_id;

-- Recheck Nulls
SELECT * FROM v_inventory_forecast_master LIMIT 5;

-- Lead Time Analysis 


CREATE OR REPLACE VIEW v_lead_time_analysis AS
SELECT 
    order_id,
    order_purchase_timestamp,
    order_delivered_customer_date,
    -- Expected delivery Days
    DATEDIFF(order_delivered_customer_date, order_purchase_timestamp) AS lead_time_days
FROM olist_orders_dataset
WHERE order_delivered_customer_date IS NOT NULL 
  AND order_status = 'delivered';

-- avg lead time
SELECT AVG(lead_time_days) as avg_delivery_time FROM v_lead_time_analysis;

-- Task 1: Stock-out Risk Analysis (AI + Business Logic)

CREATE OR REPLACE VIEW v_stockout_risk_analysis AS
SELECT 
    f.ds AS forecast_date,
    f.yhat AS predicted_demand,
    --  95% Confidence Interval (yhat_upper) 
    f.yhat_upper AS safety_stock_threshold,
    abc.inventory_class,
    p.product_category_name,
    -- \\
    CASE 
        WHEN f.yhat >= (f.yhat_upper * 0.8) THEN 'High Risk'
        WHEN f.yhat >= (f.yhat_upper * 0.5) THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS replenishment_urgency
FROM forecast_output f
CROSS JOIN (
    SELECT a.* FROM abc_analysis_table a
    WHERE a.product_id = (SELECT product_id FROM olist_order_items_dataset GROUP BY product_id ORDER BY COUNT(*) DESC LIMIT 1)
) abc
LEFT JOIN olist_products_dataset p ON abc.product_id = p.product_id;

-- Task 2: Monthly Sales Growth (Time-Series in SQL)

USE olist_inventory;

CREATE OR REPLACE VIEW v_monthly_sales_performance AS
SELECT 
    
    DATE_FORMAT(STR_TO_DATE(o.order_purchase_timestamp, '%Y-%m-%d %H:%i:%s'), '%Y-%m') AS month_year,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS monthly_revenue,

    LAG(SUM(oi.price)) OVER (ORDER BY DATE_FORMAT(STR_TO_DATE(o.order_purchase_timestamp, '%Y-%m-%d %H:%i:%s'), '%Y-%m')) AS last_month_revenue
FROM olist_orders_dataset o
JOIN olist_order_items_dataset oi ON o.order_id = oi.order_id

GROUP BY DATE_FORMAT(STR_TO_DATE(o.order_purchase_timestamp, '%Y-%m-%d %H:%i:%s'), '%Y-%m');


SELECT * FROM v_monthly_sales_performance LIMIT 10;


--  Task 3: Customer Satisfaction vs Inventory 

CREATE OR REPLACE VIEW v_customer_experience AS
SELECT 
    abc.inventory_class,
    
    ROUND(AVG(r.review_score), 2) AS avg_customer_rating,
    -- Total Reviews count
    COUNT(r.review_id) AS feedback_count,

    ROUND(SUM(CASE WHEN r.review_score = 5 THEN 1 ELSE 0 END) * 100.0 / COUNT(r.review_id), 2) AS five_star_percentage
FROM olist_order_reviews_dataset r
JOIN olist_order_items_dataset oi ON r.order_id = oi.order_id
JOIN abc_analysis_table abc ON oi.product_id = abc.product_id
GROUP BY abc.inventory_class;


SELECT * FROM v_customer_experience;

-- v_delivery_performance 


DROP VIEW IF EXISTS v_delivery_performance;

-- Clean View
CREATE VIEW v_delivery_performance AS
SELECT 
    order_id,
    order_status,
   
    DATEDIFF(
        STR_TO_DATE(order_delivered_customer_date, '%Y-%m-%d %H:%i:%s'), 
        STR_TO_DATE(order_purchase_timestamp, '%Y-%m-%d %H:%i:%s')
    ) AS delivery_days
FROM olist_orders_dataset

WHERE order_status = 'delivered' 
  AND order_delivered_customer_date IS NOT NULL 
  AND order_purchase_timestamp IS NOT NULL;

SELECT * FROM v_delivery_performance LIMIT 5;