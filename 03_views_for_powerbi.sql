-- =====================================================
-- 04_views_for_powerbi.sql
-- Create views for Power BI dashboard
-- =====================================================


-- view  order + customers
CREATE OR REPLACE VIEW vw_orders_customers AS
SELECT
    ord.order_id,
    ord.customer_id,
    cust.customer_unique_id,
    cust.customer_city,
    cust.customer_state,
    ord.order_status,
    ord.order_purchase_datetime,
    ord.order_approved_datetime,
    ord.order_delivered_carrier_datetime,
    ord.order_delivered_customer_datetime,
    ord.order_estimated_delivery_datetime,

    DATEDIFF(ord.order_delivered_customer_datetime, ord.order_purchase_datetime) AS delivery_days,

    CASE
        WHEN DATE(ord.order_delivered_customer_datetime) > DATE(ord.order_estimated_delivery_datetime)
            THEN 'Delayed'
        WHEN DATE(ord.order_delivered_customer_datetime) = DATE(ord.order_estimated_delivery_datetime)
            THEN 'On estimate'
        WHEN DATE(ord.order_delivered_customer_datetime) < DATE(ord.order_estimated_delivery_datetime)
            THEN 'Early'
        ELSE 'Unknown'
    END AS delivery_status
FROM orders_clean ord
JOIN customers_clean cust
    ON ord.customer_id = cust.customer_id;
    
    
    
    
-- view order items + products + sellers + orders
CREATE OR REPLACE VIEW vw_sales AS
SELECT
    oi.order_id,
    oi.order_item_id,
    oi.product_id,
    prod.product_category_name,
    oi.seller_id,
    sel.seller_city,
    sel.seller_state,
    oi.price,
    oi.freight_value,
    round(oi.price + oi.freight_value,2) AS total_item_value,

    ord.order_status,
    ord.order_purchase_datetime,
    ord.order_delivered_customer_datetime,
    ord.order_estimated_delivery_datetime,

    cust.customer_id,
    cust.customer_unique_id,
    cust.customer_city,
    cust.customer_state,

    DATEDIFF(ord.order_delivered_customer_datetime, ord.order_purchase_datetime) AS delivery_days,

CASE
        WHEN DATE(ord.order_delivered_customer_datetime) > DATE(ord.order_estimated_delivery_datetime)
            THEN 'Delayed'
        WHEN DATE(ord.order_delivered_customer_datetime) = DATE(ord.order_estimated_delivery_datetime)
            THEN 'On estimate'
        WHEN DATE(ord.order_delivered_customer_datetime) < DATE(ord.order_estimated_delivery_datetime)
            THEN 'Early'
        ELSE 'Unknown'
    END AS delivery_status
FROM order_items_clean oi
JOIN products_clean prod
    ON oi.product_id = prod.product_id
JOIN sellers_clean sel
    ON oi.seller_id = sel.seller_id
JOIN orders_clean ord
    ON oi.order_id = ord.order_id
JOIN customers_clean cust
    ON ord.customer_id = cust.customer_id;
    
    
    
-- view for payments
CREATE OR REPLACE VIEW vw_payments AS
SELECT
    pay.order_id,
    pay.payment_sequential,
    pay.payment_type,
    pay.payment_installments,
    pay.payment_value,

    ord.order_status,
    ord.order_purchase_datetime,

    cust.customer_state,
    cust.customer_city
FROM payments_clean pay
JOIN orders_clean ord
    ON pay.order_id = ord.order_id
JOIN customers_clean cust
    ON ord.customer_id = cust.customer_id;
    
    
    
-- view for reviews
CREATE OR REPLACE VIEW vw_reviews AS
SELECT
    rev.review_id,
    rev.order_id,
    rev.review_score,
    rev.review_comment_title,
    rev.review_comment_message,
    rev.review_creation_date,
    rev.review_answer_timestamp,

    ord.order_status,
    ord.order_purchase_datetime,
    ord.order_delivered_customer_datetime,
    ord.order_estimated_delivery_datetime,

    cust.customer_state,
    cust.customer_city,

    CASE
        WHEN rev.review_score IN (1, 2) THEN 'Negative'
        WHEN rev.review_score = 3 THEN 'Neutral'
        WHEN rev.review_score IN (4, 5) THEN 'Positive'
        ELSE 'Unknown'
    END AS review_category,

CASE
        WHEN DATE(ord.order_delivered_customer_datetime) > DATE(ord.order_estimated_delivery_datetime)
            THEN 'Delayed'
        ELSE 'On time or early'
END AS delivery_performance
FROM reviews_clean rev
JOIN orders_clean ord
    ON rev.order_id = ord.order_id
JOIN customers_clean cust
    ON ord.customer_id = cust.customer_id;
    

-- view for monthly revenue
CREATE OR REPLACE VIEW vw_monthly_revenue AS
SELECT
    DATE_FORMAT(ord.order_purchase_datetime, '%Y-%m') AS order_month,
    COUNT(DISTINCT ord.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS product_revenue,
    ROUND(SUM(oi.freight_value), 2) AS freight_value,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS total_revenue,
    ROUND(SUM(oi.price) / COUNT(DISTINCT ord.order_id), 2) AS avg_ticket
FROM orders_clean ord
JOIN order_items_clean oi
    ON ord.order_id = oi.order_id
WHERE ord.order_status = 'delivered'
GROUP BY DATE_FORMAT(ord.order_purchase_datetime, '%Y-%m')
ORDER BY order_month;


-- view for category revenue
CREATE OR REPLACE VIEW vw_category_revenue AS
SELECT
    prod.product_category_name,
    COUNT(*) AS total_items_sold,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS product_revenue,
    ROUND(SUM(oi.freight_value), 2) AS freight_value,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS total_revenue,
    ROUND(AVG(oi.price), 2) AS avg_item_price
FROM order_items_clean oi
JOIN products_clean prod
    ON oi.product_id = prod.product_id
JOIN orders_clean ord
    ON oi.order_id = ord.order_id
WHERE ord.order_status = 'delivered'
GROUP BY prod.product_category_name;


-- view of revenue per state
CREATE OR REPLACE VIEW vw_state_revenue AS
SELECT
    cust.customer_state,
    COUNT(DISTINCT ord.order_id) AS total_orders,
    COUNT(DISTINCT cust.customer_unique_id) AS unique_customers,
    ROUND(SUM(oi.price), 2) AS product_revenue,
    ROUND(SUM(oi.freight_value), 2) AS freight_value,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS total_revenue,
    ROUND(SUM(oi.price) / COUNT(DISTINCT ord.order_id), 2) AS avg_ticket
FROM customers_clean cust
JOIN orders_clean ord
    ON cust.customer_id = ord.customer_id
JOIN order_items_clean oi
    ON ord.order_id = oi.order_id
WHERE ord.order_status = 'delivered'
GROUP BY cust.customer_state;

-- view of deliveries per state
CREATE OR REPLACE VIEW vw_state_delivery AS
SELECT
    cust.customer_state,
    COUNT(DISTINCT ord.order_id) AS total_orders,

    ROUND(
        AVG(DATEDIFF(ord.order_delivered_customer_datetime, ord.order_purchase_datetime)),
        2
    ) AS avg_delivery_days,

	SUM(
        CASE 
            WHEN DATE(ord.order_delivered_customer_datetime) > DATE(ord.order_estimated_delivery_datetime)
            THEN 1 ELSE 0 
        END
		) AS delayed_orders,

    ROUND(
        SUM(
            CASE 
                WHEN DATE(ord.order_delivered_customer_datetime) > DATE(ord.order_estimated_delivery_datetime)
                THEN 1 ELSE 0 
            END
        ) / COUNT(DISTINCT ord.order_id) * 100,
        2
    ) AS delay_rate
FROM orders_clean ord
JOIN customers_clean cust
    ON ord.customer_id = cust.customer_id
WHERE ord.order_status = 'delivered'
  AND ord.order_delivered_customer_datetime IS NOT NULL
  AND ord.order_estimated_delivery_datetime IS NOT NULL
GROUP BY cust.customer_state;



-- view of reviews per category
CREATE OR REPLACE VIEW vw_category_reviews AS
SELECT
    prod.product_category_name,
    COUNT(DISTINCT rev.review_id) AS total_reviews,
    ROUND(AVG(rev.review_score), 2) AS avg_review_score,

    SUM(CASE WHEN rev.review_score IN (1, 2) THEN 1 ELSE 0 END) AS negative_reviews,
    SUM(CASE WHEN rev.review_score = 3 THEN 1 ELSE 0 END) AS neutral_reviews,
    SUM(CASE WHEN rev.review_score IN (4, 5) THEN 1 ELSE 0 END) AS positive_reviews,

    ROUND(
        SUM(CASE WHEN rev.review_score IN (1, 2) THEN 1 ELSE 0 END) 
        / COUNT(DISTINCT rev.review_id) * 100,
        2
    ) AS negative_review_percentage,

    ROUND(
        SUM(CASE WHEN rev.review_score IN (4, 5) THEN 1 ELSE 0 END) 
        / COUNT(DISTINCT rev.review_id) * 100,
        2
    ) AS positive_review_percentage
FROM reviews_clean rev
JOIN order_items_clean oi
    ON rev.order_id = oi.order_id
JOIN products_clean prod
    ON oi.product_id = prod.product_id
GROUP BY prod.product_category_name;



-- views for KPIs
CREATE OR REPLACE VIEW vw_kpis AS
SELECT
    COUNT(DISTINCT ord.order_id) AS total_orders,
    COUNT(DISTINCT cust.customer_unique_id) AS unique_customers,
    COUNT(DISTINCT oi.product_id) AS unique_products,
    COUNT(DISTINCT oi.seller_id) AS total_sellers,

    ROUND(SUM(oi.price), 2) AS product_revenue,
    ROUND(SUM(oi.freight_value), 2) AS freight_value,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS total_revenue,

    ROUND(SUM(oi.price) / COUNT(DISTINCT ord.order_id), 2) AS avg_ticket,

    ROUND(
        AVG(DATEDIFF(ord.order_delivered_customer_datetime, ord.order_purchase_datetime)),
        2
    ) AS avg_delivery_days,

    ROUND(AVG(rev.review_score), 2) AS avg_review_score
FROM orders_clean ord
JOIN customers_clean cust
    ON ord.customer_id = cust.customer_id
JOIN order_items_clean oi
    ON ord.order_id = oi.order_id
LEFT JOIN reviews_clean rev
    ON ord.order_id = rev.order_id
WHERE ord.order_status = 'delivered';


-- view to include categories on vw_reviews table 

CREATE OR REPLACE VIEW vw_reviews AS
SELECT
    rev.review_id,
    rev.order_id,
    rev.review_score,
    rev.review_comment_title,
    rev.review_comment_message,
    rev.review_creation_date,
    rev.review_answer_timestamp,

    ord.order_status,
    ord.order_purchase_datetime,
    ord.order_delivered_customer_datetime,
    ord.order_estimated_delivery_datetime,

    oi.product_id,
    prod.product_category_name,

    cust.customer_id,
    cust.customer_unique_id,
    cust.customer_city,
    cust.customer_state,

    CASE
        WHEN rev.review_score >= 4 THEN 'Positive'
        WHEN rev.review_score = 3 THEN 'Neutral'
        WHEN rev.review_score <= 2 THEN 'Negative'
        ELSE 'Unknown'
    END AS review_category,

    CASE
        WHEN DATE(ord.order_delivered_customer_datetime) > DATE(ord.order_estimated_delivery_datetime)
            THEN 'Delayed'
        WHEN DATE(ord.order_delivered_customer_datetime) <= DATE(ord.order_estimated_delivery_datetime)
            THEN 'On time or early'
        ELSE 'Unknown'
    END AS delivery_performance

FROM reviews_clean rev
JOIN orders_clean ord
    ON rev.order_id = ord.order_id
JOIN customers_clean cust
    ON ord.customer_id = cust.customer_id
JOIN order_items_clean oi
    ON rev.order_id = oi.order_id
JOIN products_clean prod
    ON oi.product_id = prod.product_id
WHERE ord.order_status = 'delivered';



-- =====================================================
-- Test views
-- =====================================================

SELECT * FROM vw_orders_customers LIMIT 10;
SELECT * FROM vw_sales LIMIT 10;
SELECT * FROM vw_payments LIMIT 10;
SELECT * FROM vw_reviews LIMIT 10;
SELECT * FROM vw_monthly_revenue LIMIT 10;
SELECT * FROM vw_category_revenue LIMIT 10;
SELECT * FROM vw_state_revenue LIMIT 10;
SELECT * FROM vw_state_delivery LIMIT 10;
SELECT * FROM vw_category_reviews LIMIT 10;
SELECT * FROM vw_kpis;