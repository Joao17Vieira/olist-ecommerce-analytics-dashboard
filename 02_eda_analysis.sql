-- =======================================
-- 1. DATA OVERVIEW
-- =======================================

SELECT COUNT(DISTINCT customer_unique_id) AS unique_clients
FROM customers_clean;

-- orders has 99441 rows
-- order_items has 112650 rows -> 112650 items sold
-- products has 32340 rows -> there are 32340 products
-- payments has 103886 rows
-- reviews has 99223 rows
-- sellers has 3093 rows -> 3093 unique sellers
-- geolocation has 195861 rows
-- customers has 99441 rows -> 96096 different clients
-- cat_trans has 71 rows

SELECT MIN(order_purchase_datetime) AS first_order,
       MAX(order_purchase_datetime) AS last_order
FROM orders_clean;

-- first_order: 2016-09-04 21:15:19
-- last_order: 2018-10-17 17:30:18


select avg(items_per_order)  as avg_items_per_order
from 
	(select order_id,
			count(*) as items_per_order
            from order_items_clean
            group by order_id
	)as orders;
    
    -- average number of items per order is 1.1417 items
    
    
-- =======================================
-- 2. ORDERS ANALYSIS 
-- =======================================

SELECT order_status, COUNT(*) AS total_num_orders
FROM orders_clean
GROUP BY order_status
ORDER BY total_num_orders DESC;

	-- delivered 96478
	-- shipped 1107
	-- canceled 625
	-- unavailable 609
	-- invoiced 314
	-- processing 301
	-- created 5 
	-- approved	2
    

SELECT 
    DATE_FORMAT(order_purchase_datetime, '%Y-%m') AS order_month,
    COUNT(*) AS orders_per_month
FROM orders_clean
GROUP BY order_month
ORDER BY order_month;

-- ORDERS PER MONTH 
		-- 2016-09	4
		-- 2016-10	324
		-- 2016-12	1
		-- 2017-01	800
		-- 2017-02	1780
		-- 2017-03	2682
		-- 2017-04	2404
		-- 2017-05	3700
		-- 2017-06	3245
		-- 2017-07	4026
		-- 2017-08	4331
		-- 2017-09	4285
		-- 2017-10	4631
		-- 2017-11	7544
		-- 2017-12	5673
		-- 2018-01	7269
		-- 2018-02	6728
		-- 2018-03	7211
		-- 2018-04	6939
		-- 2018-05	6873
		-- 2018-06	6167
		-- 2018-07	6292
		-- 2018-08	6512
		-- 2018-09	16
		-- 2018-10	4


SELECT 
    DATE_FORMAT(order_purchase_datetime, '%Y-%m') AS order_month,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN order_status = 'delivered' THEN 1 ELSE 0 END) AS delivered_orders,
    ROUND(
        SUM(CASE WHEN order_status = 'delivered' THEN 1 ELSE 0 END) / COUNT(*) * 100,
        2
    ) AS delivered_percentage
FROM orders_clean
GROUP BY order_month
ORDER BY order_month;

-- ORDER MONTH TOTAL_ORDERS DELIVERED_ORDERS  PERCENTAGE_DELIVERED
-- 2016-09	        4	           1	              25.00
-- 2016-10	       324			  265				  81.79
-- 2016-12			1			   1				 100.00
-- 2017-01		   800			  750				  93.75
-- 2017-02		   1780			  1653			      92.87
-- 2017-03	   	   2682			  2546				  94.93
-- 2017-04		   2404			  2303				  95.80
-- 2017-05		   3700			  3546				  95.84
-- 2017-06		   3245		   	  3135				  96.61
-- 2017-07		   4026			  3872				  96.17
-- 2017-08		   4331			  4193			   	  96.81
-- 2017-09		   4285			  4150				  96.85
-- 2017-10		   4631			  4478				  96.70
-- 2017-11		   7544			  7289				  96.62
-- 2017-12		   5673			  5513				  97.18
-- 2018-01		   7269			  7069				  97.25
-- 2018-02		   6728			  6555				  97.43
-- 2018-03		   7211			  7003				  97.12
-- 2018-04		   6939			  6798				  97.97
-- 2018-05		   6873			  6749				  98.20
-- 2018-06		   6167			  6099				  98.90
-- 2018-07		   6292			  6159				  97.89
-- 2018-08		   6512			  6351				  97.53
-- 2018-09			 16			     0				   0.00
-- 2018-10			  4				 0				   0.00


SELECT 
	DATE_FORMAT(order_purchase_datetime, '%Y') AS order_year,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN order_status = 'delivered' THEN 1 ELSE 0 END) AS delivered_orders,
    ROUND(
        SUM(CASE WHEN order_status = 'delivered' THEN 1 ELSE 0 END) / COUNT(*) * 100,
        2
    ) AS delivered_percentage
FROM orders_clean
GROUP BY order_year
ORDER BY order_year;

-- ORDERS_YEAR TOTAL_ORDERS DELIVERED_ORDERS  PERCENTAGE_DELIVERED
-- 	  2016		   329			  267				  81.16
-- 	  2017		   45101		43428				  96.29
-- 	  2018		   54011		52783				  97.73
        


-- ===============================
-- 3. REVENUE
-- ===============================


SELECT 
    ROUND(SUM(oi.price), 2) AS product_revenue
FROM order_items_clean oi
JOIN orders_clean o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered';
-- TOTAL REVENUE: 13 221 498.11€ (orders delivered)

SELECT 
    DATE_FORMAT(o.order_purchase_datetime, '%Y-%m') AS order_month,
    ROUND(SUM(oi.price), 2) AS product_revenue
FROM order_items_clean oi
JOIN orders_clean o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY order_month
ORDER BY order_month;

-- TOTAL REVENUE
-- MONTH     REVENUE
-- 2016-09		134.97
-- 2016-10	 40 325.11
-- 2016-12	     10.9
-- 2017-01	111 798.36
-- 2017-02	234 223.4
-- 2017-03	359 198.85
-- 2017-04	340 669.68
-- 2017-05	489 338.25
-- 2017-06	421 923.37
-- 2017-07	481 604.52
-- 2017-08	554 699.7
-- 2017-09	607 399.67
-- 2017-10	648 247.65
-- 2017-11	987 765.37
-- 2017-12	726 033.19
-- 2018-01	924 645
-- 2018-02	826 437.13
-- 2018-03	953 356.25
-- 2018-04	973 534.09
-- 2018-05	977 544.69
-- 2018-06	856 077.86
-- 2018-07	867 953.46
-- 2018-08	838 576.64

-- most revenue month: 2017-11 -> 987 765.37€


select avg(price) from order_items_clean;
-- average item price: 120.65€ 


SELECT 
    DATE_FORMAT(o.order_purchase_datetime, '%Y-%m') AS order_month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS product_revenue
FROM orders_clean o
JOIN order_items_clean oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY order_month
ORDER BY order_month;

-- the months with the highest number of orders don't correspond to the months with the most revenue which means 
-- that the months that had higher revenue should have orders with more expensive items 

-- ===============================
-- 4. Products / Categories
-- ===============================


select product_category_name, round(sum(price),2) as prod_revenue
    from (
		select   ord.*,
				prod.product_category_name, o.order_status
		from order_items_clean ord
		join products_clean prod
			on ord.product_id = prod.product_id 
		join orders_clean o
			ON ord.order_id = o.order_id) as cat_ord
	WHERE order_status = 'delivered'
	group by product_category_name
    order by sum(price) desc
    limit 10;

-- TOP 10 categories per revenue
-- health_beauty			1 233 131.72
-- watches_gifts			1 166 176.98
-- bed_bath_table			1 023 434.76
-- sports_leisure			  954 852.55
-- computers_accessories	  888 724.61
-- furniture_decor			  711 927.69
-- housewares				  615 628.69
-- cool_stuff				  610 204.1
-- auto						  578 966.65
-- toys						  471 286.48



select product_category_name, count(product_id) as total_items_sold
    from (
		select   ord.*,
				prod.product_category_name, o.order_status
		from order_items_clean ord
		join products_clean prod
			on ord.product_id = prod.product_id
		join orders_clean o
			ON ord.order_id = o.order_id) as cat_ord
	WHERE order_status = 'delivered'
	group by product_category_name
    order by count(product_id) desc
    limit 10;
    
-- TOP 10 categories per items sold
-- bed_bath_table			10953
-- health_beauty			 9465
-- sports_leisure			 8431
-- furniture_decor		 	 8160
-- computers_accessories	 7644
-- housewares				 6795
-- watches_gifts			 5859
-- telephony				 4685
-- garden_tools				 4268
-- auto						 4140


select product_category_name, round(avg(price),2) as avg_revenue
    from (
		select   ord.*,
				prod.product_category_name, o.order_status
		from order_items_clean ord
		join products_clean prod
			on ord.product_id = prod.product_id 
		join orders_clean o
			ON ord.order_id = o.order_id) as cat_ord
	WHERE order_status = 'delivered'
	group by product_category_name
    order by avg(price) desc
    limit 5;
-- TOP 5 categories with the highest average item price
-- computers							   1062.76
-- small_appliances_home_oven_and_coffee	638.21
-- home_appliances_2						467.33
-- agro_industry_and_commerce				342.55
-- musical_instruments						283.13


select product_category_name, round(avg(price),2) as avg_revenue
    from (
		select   ord.*,
				prod.product_category_name, o.order_status
		from order_items_clean ord
		join products_clean prod
			on ord.product_id = prod.product_id 
		join orders_clean o
			ON ord.order_id = o.order_id) as cat_ord
	WHERE order_status = 'delivered'
	group by product_category_name
    order by avg(price) asc
    limit 5;

-- TOP 5 categories with the lowest average item price
-- flowers				33.64
-- diapers_and_hygiene	40.56
-- cds_dvds_musicals	52.14
-- food_drink			55.55
-- electronics			56.81

select product_category_name, count(distinct(product_id)) as num_prods
    from (
		select   ord.*,
				prod.product_category_name
		from order_items_clean ord
		join products_clean prod
			on ord.product_id = prod.product_id ) as cat_ord
	group by product_category_name
    order by count(distinct(product_id)) desc
    limit 5;
    
-- TOP 5 categories with more distinct products
-- bed_bath_table	3029
-- sports_leisure	2867
-- furniture_decor	2657
-- health_beauty	2444
-- housewares		2335

select prod.product_id, product_category_name, count(prod.product_id) as total_items_sold, round(sum(price),2) as prod_revenue
		from order_items_clean ord
		join products_clean prod
			on ord.product_id = prod.product_id
		JOIN orders_clean o
			ON ord.order_id = o.order_id
	WHERE o.order_status = 'delivered'
	group by prod.product_id, product_category_name
    order by count(prod.product_id)  desc
    limit 5;
    
-- TOP 5 products sold
-- 			product_id 				|| product_category_name || total_items_sold || prod_revenue
-- aca2eb7d00ea1a7b8ebd4e68314663af	    furniture_decor				520				37 104.3
-- 422879e10f46682990de24d770e7f83d	    garden_tools				484				26 577.22
-- 99a4788cb24856965c36a24e339b6058  	bed_bath_table				488				43 025.56
-- 389d119b48cf3043d311335e499d9c6b	    garden_tools				392				21 440.59
-- 368c6c730842d78016ad823897a372db	    garden_tools				388				21 056.8


SELECT 
    prod.product_id, 
    prod.product_category_name, 
    COUNT(*) AS total_items_sold, 
    ROUND(SUM(ord.price), 2) AS prod_revenue
FROM order_items_clean ord
JOIN products_clean prod
    ON ord.product_id = prod.product_id 
JOIN orders_clean o
    ON ord.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY prod.product_id, prod.product_category_name
ORDER BY prod_revenue DESC
LIMIT 5;
    
-- TOP 5 products per revenue
-- 		product_id 					|| product_category_name || total_items_sold || prod_revenue
-- bb50f2e236e5eea0100680137654686c		health_beauty				194				  63560
-- 6cdd53843498f92890544667809f1595		health_beauty				153				  53652.3
-- d6160fb7873f184099d9bc95e30376af		computers					 33				  45949.35
-- d1c427060a0f73f6b889a5c7c61f2ac4		computers_accessories		332				  45620.56
-- 99a4788cb24856965c36a24e339b6058		bed_bath_table				477				  42049.66


SELECT 
    prod.product_id, 
    prod.product_category_name, 
    COUNT(*) AS total_items_sold, 
    ROUND(SUM(ord.price), 2) AS prod_revenue
FROM order_items_clean ord
JOIN products_clean prod
    ON ord.product_id = prod.product_id 
JOIN orders_clean o
    ON ord.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY prod.product_id, prod.product_category_name
ORDER BY total_items_sold ASC
LIMIT 5;
-- 5 products less sold 
-- 		product_id 					|| product_category_name || total_items_sold || prod_revenue
-- 27287c7af954c885df547dcf11fa77a6		health_beauty					1				43.9
-- 4a9389b1a1ad7d52963f24ce0391a08f		sports_leisure					1				89
-- 141a1bbd15437e6ce4765f29d126ef67		sports_leisure					1			   200.36
-- b512f3c014a02179181951e048ed73cb	f	urniture_decor					1				69.79
-- bfd57168007502796abdf43ece7d8dd3		health_beauty					1				65.6


-- ===============================
-- 5. Customers / Geography
-- ===============================


select customer_state, COUNT(DISTINCT customer_unique_id) num_cust
from customers_clean
group by customer_state
order by COUNT(DISTINCT customer_unique_id) desc
limit 5;

-- TOP 5 states with the most customers
-- state || customers
-- SP		40302
-- RJ		12384
-- MG		11259
-- RS		 5277
-- PR		 4882

select customer_state, COUNT(DISTINCT order_id) AS total_orders
    from (
		select   ord.*,
				cust.customer_state
		from customers_clean cust
		join orders_clean ord
			on ord.customer_id = cust.customer_id ) as cat_ord
	group by customer_state
    order by count(order_id)  desc
    limit 5;
-- TOP 5 states per orders
-- state || total_orders
-- SP		  41746
-- RJ		  12852
-- MG		  11635
-- RS		   5466
-- PR		   5045


SELECT 
    cust.customer_state,
    COUNT(DISTINCT ord.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS product_revenue,
    ROUND(SUM(oi.price) / COUNT(DISTINCT ord.order_id), 2) AS avg_revenue_per_order
FROM customers_clean cust
JOIN orders_clean ord
    ON cust.customer_id = ord.customer_id
JOIN order_items_clean oi
    ON ord.order_id = oi.order_id
WHERE ord.order_status = 'delivered'
GROUP BY cust.customer_state
ORDER BY product_revenue DESC
limit 5;

-- TOP 5 states per product revenue
-- state || total_orders || prod_revenue
--  SP		  40501			5067633.16
--  RJ		  12350			1759651.13
--  MG		  11354			1552481.83
--  RS		  5345			 728897.47
--  PR		  4923			 666063.51

SELECT 
    cust.customer_state,
    COUNT(DISTINCT ord.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS product_revenue,
    ROUND(SUM(oi.price) / COUNT(DISTINCT ord.order_id), 2) AS avg_ticket
FROM customers_clean cust
JOIN orders_clean ord
    ON cust.customer_id = ord.customer_id
JOIN order_items_clean oi
    ON ord.order_id = oi.order_id
WHERE ord.order_status = 'delivered'
GROUP BY cust.customer_state
ORDER BY avg_ticket desc
limit 5;
-- TOP 5 states by average product ticket
-- state || orders || prod_revenue || avg_ticket 
-- PB	   517		   112586.82		217.77
-- AP		67			13374.81		199.62
-- AC		80			15930.97		199.14
-- AL	   397			78855.72		198.63
-- RO	   243			45682.76		187.99


SELECT 
    cust.customer_state,
    ROUND(SUM(oi.price), 2) AS product_revenue,
    ROUND(SUM(oi.price) / (SELECT 
                    SUM(oi2.price)
                FROM
                    customers_clean cust2
                        JOIN
                    orders_clean ord2 ON cust2.customer_id = ord2.customer_id
                        JOIN
                    order_items_clean oi2 ON ord2.order_id = oi2.order_id
                WHERE
                    ord2.order_status = 'delivered') * 100,
            2) AS revenue_percentage
FROM
    customers_clean cust
        JOIN
    orders_clean ord ON cust.customer_id = ord.customer_id
        JOIN
    order_items_clean oi ON ord.order_id = oi.order_id
WHERE
    ord.order_status = 'delivered'
GROUP BY cust.customer_state
ORDER BY product_revenue DESC
limit 5;

-- TOP 5 states with the highest revenue percentage
-- state || prod_revenue || revenue_percentage
-- SP		5067633.16			38.33
-- RJ		1759651.13			13.31
-- MG		1552481.83			11.74
-- RS		728897.47			 5.51
-- PR		666063.51			 5.04


SELECT 
    cust.customer_state,
    COUNT(DISTINCT ord.order_id) AS total_orders,
    COUNT(DISTINCT CASE 
        WHEN ord.order_status = 'canceled' THEN ord.order_id 
    END) AS canceled_orders
FROM customers_clean cust
JOIN orders_clean ord
    ON cust.customer_id = ord.customer_id
GROUP BY cust.customer_state
ORDER BY canceled_orders DESC
LIMIT 5;
-- TOP 5 states with the most number of canceled orders
-- state || total_orders || canceled_orders
-- SP	      41746				327
-- RJ		  12852				 86
-- MG		  11635			 	 64
-- RS		   5466				 25
-- PR		   5045				 22


-- ===============================
-- 6. SELLERS
-- ===============================


select seller_state, count(distinct(seller_id)) as num_sell
	from sellers_clean
    group by seller_state
    order by num_sell desc
    limit 5;
    
-- TOP 5 states with the most number of sellers
-- state || num_seller
-- SP		1849
-- PR		 348
-- MG		 244
-- SC		 190
-- RJ		 170


select seller_id, count(distinct(order_id)) as num_orders
	from order_items_clean
    group by seller_id
    order by num_orders desc
    limit 5;
-- TOP 5 sellers with the most orders
-- seller_id 						|| num_orders
-- 6560211a19b47992c3666cc44a7e94c0		1854
-- 4a3ca9315b744ce9f8e9374361493884		1806
-- cc419e0650a3c5ba77189a1882b7556a		1706
-- 1f50f920176fa81dab994f9023523100		1404
-- da8622b14eb17ae2831f4ac5b9dab84a		1314


select seller_id, round(sum(price),2) as revenue
	from order_items_clean
    group by seller_id
    order by revenue desc
    limit 5;
-- TOP 5 sellers with the most revenue
-- seller_id 						  || revenue
-- 4869f7a5dfa277a7dca6462dcf3b52b2		229472.63
-- 53243585a1d6dc2643021fd1853d8905		222776.05
-- 4a3ca9315b744ce9f8e9374361493884		200472.92
-- fa1c13f2614d7b5c4749cbc52fecda94		194042.03
-- 7c67e1448b00f6e969d365cea6b010ab		187923.89


SELECT 
    seller_id,
    COUNT(*) AS total_reviews,
    ROUND(AVG(review_score), 2) AS avg_review
FROM (
    SELECT DISTINCT
        oi.seller_id,
        oi.order_id,
        rev.review_score
    FROM order_items_clean oi
    JOIN reviews_clean rev
        ON oi.order_id = rev.order_id
) AS seller_reviews
GROUP BY seller_id
HAVING total_reviews > 10
ORDER BY avg_review DESC
LIMIT 5;
-- TOP 5 sellers with the best reviews (with more than 10 reviews)

-- 			seller_id     			 ||  total reviews ||  avg_review
-- 48efc9d94a9834137efd9ea76b065a38			  33			5.00
-- 2addf05f476d0637864454e93ba673d5			  12			5.00
-- 41c2bad7229b0c25e6becf179ebf63ff			  20			4.95
-- 1fecf4da1fa2689bccffa0121953643			  19			4.95
-- 9d681c7e12db302cb261e721040dde65			  13			4.92


SELECT 
    seller_id,
    COUNT(*) AS total_reviews,
    ROUND(AVG(review_score), 2) AS avg_review
FROM (
    SELECT DISTINCT
        oi.seller_id,
        oi.order_id,
        rev.review_score
    FROM order_items_clean oi
    JOIN reviews_clean rev
        ON oi.order_id = rev.order_id
) AS seller_reviews
GROUP BY seller_id
HAVING total_reviews > 10
ORDER BY avg_review ASC 
LIMIT 5;
-- TOP 5 sellers with the worst reviews (with more than 10 reviews)

-- 			seller_id     			 || total_reviews ||  avg_review
-- 4342d4b2ba6b161468c63a7e7cfce593			19				1.26
-- b1b3948701c5c72445495bd161b83a4c			18				1.72
-- ffff564a4f9085cd26170f4732393726			20				2.10
-- 1ca7077d890b907f89be8c954a02686a		   114				2.33
-- fa74b2f3287d296e9fbd2cc80f2d1cf1			11				2.36


WITH seller_orders AS ( SELECT DISTINCT seller_id, order_id
    FROM order_items_clean
)
SELECT   
    sel.seller_id,
    COUNT(*) AS total_orders,
    SUM( CASE 
            WHEN ord.order_delivered_customer_datetime > ord.order_estimated_delivery_datetime 
            THEN 1 
            ELSE 0 
        END) AS delayed_orders,
    ROUND( SUM( CASE 
                WHEN ord.order_delivered_customer_datetime > ord.order_estimated_delivery_datetime 
                THEN 1 
                ELSE 0 
            END
        ) / COUNT(*) * 100, 2) AS delay_rate
FROM seller_orders sel
JOIN orders_clean ord
    ON sel.order_id = ord.order_id
WHERE ord.order_status = 'delivered'
  AND ord.order_delivered_customer_datetime IS NOT NULL
  AND ord.order_estimated_delivery_datetime IS NOT NULL
GROUP BY sel.seller_id
HAVING total_orders >= 20
ORDER BY delay_rate DESC
LIMIT 5;

-- TOP 5 sellers with the highest delay rate on the orders
-- seller_id   						|| total_orders || delayed_orders || delay_rate
-- 821fb029fc6e495ca4f08a35d51e53a5			24				 9				37.50
-- f76a3b1349b6df1ee875d1f3fa4340f0			24			 	 9				37.50
-- ede0c03645598cdfc63ca8237acbe73d			43				15				34.88
-- ad781527c93d00d89a11eecd9dcad7c1			38				12				31.58
-- 835f0f7810c76831d6c7d24c7a646d4d			42				13				30.95



-- ===============================
-- 7. PAYMENTS
-- ===============================


select payment_type, count(pay.order_id)
	from payments_clean pay
    JOIN orders_clean o
    ON pay.order_id = o.order_id
WHERE o.order_status = 'delivered'
    group by payment_type
    order by count(pay.order_id) desc;

-- number of times each payment method was used
-- credit_card		74586
-- boleto			19191
-- voucher			 5493
-- debit_card		 1486



select payment_type, round(sum(payment_value),2)
	from payments_clean pay
        JOIN orders_clean o
    ON pay.order_id = o.order_id
WHERE o.order_status = 'delivered'
    group by payment_type
    order by round(sum(payment_value),2) desc;

-- total value per payment type
-- credit_card		12101094.88
-- boleto			 2769932.58
-- voucher			  343013.19
-- debit_card		  208421.12



SELECT pay.payment_type, COUNT(DISTINCT pay.order_id) AS total_orders, ROUND(SUM(pay.payment_value), 2) AS total_payment_value,
    ROUND(SUM(pay.payment_value) / COUNT(DISTINCT pay.order_id), 2) AS avg_ticket
FROM payments_clean pay
JOIN orders_clean ord
    ON pay.order_id = ord.order_id
WHERE ord.order_status = 'delivered'
GROUP BY pay.payment_type
ORDER BY avg_ticket DESC;

-- average ticket per payment method
-- payment_type || total_orders || total_payment_value || avg_ticket
-- credit_card		74304			12101094.88				162.86
-- boleto			19191			 2769932.58				144.33
-- debit_card		1485			  208421.12				140.35
-- voucher			3679			  343013.19				 93.24



SELECT
    ROUND(AVG(payment_installments), 2) AS avg_installments
FROM payments_clean;

-- average number of installments
-- 2.85

SELECT
    pay.order_id,
    pay.payment_type,
    pay.payment_installments,
    ROUND(pay.payment_value, 2) AS payment_value
FROM payments_clean pay
JOIN orders_clean ord
    ON pay.order_id = ord.order_id
WHERE ord.order_status = 'delivered'
ORDER BY pay.payment_installments DESC, pay.payment_value DESC
LIMIT 10;

-- orders paid with the highest number of installments
-- order_id 						  || payment_type || installments || value
-- f60ce04ff8060152c83c7c97e246d6a8		credit_card			24			1440.1
-- fcbb6af360b31b05460c2c8e524588c0		credit_card			24			1194.38
-- d74fca7ee2ce7587c45eefb0fea95ed8		credit_card			24			1099
-- 63dbe0c8e63e5f1b4deec09d4f044a7f		credit_card			24			771.69
-- ff36cbc44b8f228e0449c92ef089c843		credit_card			24			756.49
-- ef71772d55431467890fda2f45c7bdde		credit_card			24			629.64
-- ffb18bf111fa70edf316eb0390427986		credit_card			24			617.24
-- 859f516f2fc3f95772e63c5757ab0d5b		credit_card			24			609.56
-- d8d5cc8b2d42cce90b7ea35e5691a7b1		credit_card			24			599.18
-- 90f864fe19d11549fa01eb81c4dd87e3		credit_card			24			588.58



SELECT
    pay.payment_installments,
    COUNT(DISTINCT pay.order_id) AS total_orders,
    ROUND(AVG(pay.payment_value), 2) AS avg_payment_value
FROM payments_clean pay
JOIN orders_clean ord
    ON pay.order_id = ord.order_id
WHERE ord.order_status = 'delivered'
GROUP BY pay.payment_installments
ORDER BY avg_payment_value DESC;

-- relation between number of installments and average payment value 

-- installments || orders || avg_payment_value
-- 20				16			641.78
-- 24				18			610.05
-- 18				27			486.48
-- 15				72			431.13
-- 10				5137		410.54
-- 12				128			324.41
-- 8				4122		306.29
-- 16				5			292.69
-- 21				3			243.7
-- 23				1			236.48
-- 22				1			228.71
-- 6				3800		208.54
-- 9				618			197.97
-- 7				1560		185.95
-- 5				5090		182.3
-- 17				7			174.52
-- 14				14			169.36
-- 4				6882		163.64
-- 13				15			151.83
-- 3				10147		142
-- 2				12052		126.59
-- 11				   22		125.6
-- 1				47586		111.69
-- 0					2		 94.32

-- we can see that the more expensive payments had higher number of installments but it is not that linear

SELECT payment_type, COUNT(*) AS total_payments,
    ROUND(
        COUNT(*) / (SELECT COUNT(*) FROM payments_clean) * 100,
        2
    ) AS payment_percentage
FROM payments_clean
GROUP BY payment_type
ORDER BY payment_percentage DESC;

-- percentage of payments with each type
-- payment_type || total || percentage 
-- credit_card	   76795	73.92
-- boleto		   19784	19.04
-- voucher			5775	5.56
-- debit_card		1529	1.47
-- not_defined		   3	0.00




-- ===============================
-- 8. REVIEWS / Satisfaction
-- ===============================


select review_score, COUNT(*) AS total_reviews, ROUND(COUNT(*) / (SELECT COUNT(*) FROM reviews_clean) * 100, 2) AS review_percentage
from reviews_clean
group by review_score
order by review_percentage desc;

-- reviews distribution
-- review_score || total || percentage
-- 5			   57328	 57.78
-- 4			   19141	 19.29
-- 1			   11424	 11.51
-- 3			    8179	 8.24
-- 2			    3151	 3.18


select round(avg(review_score),2) as avg_score
from reviews_clean
order by avg_score desc;

-- The average review score is 4.09


select product_category_name,  COUNT(rev.review_score) AS total_reviews, round(avg(review_score),2) as avg_rev
	from reviews_clean rev
    join order_items_clean oi
		on rev.order_id = oi.order_id
	join products_clean prod
		on oi.product_id = prod.product_id
group by product_category_name
HAVING total_reviews >= 20
order by avg_rev desc
limit 5;

-- TOP 5 categories with the highest average rating
-- 		category 			|| total || average
-- books_general_interest		549		4.45
-- flowers						 31		4.42
-- books_imported				 60		4.40
-- books_technical				266		4.37
-- food_drink					279		4.32



SELECT 
    prod.product_category_name, COUNT(oi.product_id) AS total_items_sold, COUNT(rev.review_score) AS total_reviews,
    ROUND(AVG(rev.review_score), 2) AS avg_review
FROM reviews_clean rev
JOIN order_items_clean oi
    ON rev.order_id = oi.order_id
JOIN products_clean prod
    ON oi.product_id = prod.product_id
GROUP BY prod.product_category_name
HAVING total_items_sold >= 1000
ORDER BY avg_review ASC
LIMIT 10;

-- Categories with high number of items sold and lowest average rating
-- Category 		|| total_items_sold|| total_reviews || avg_review
-- office_furniture			1687			1687			3.49
-- furniture_decor			8331			8331			3.90
-- bed_bath_table		   11137		   11137			3.90
-- computers_accessories	7849			7849			3.93
-- telephony				4779			4779			3.93
-- baby						3047			3047			4.01
-- watches_gifts			5950			5950			4.02
-- consoles_games			1127			1127			4.02
-- electronics				2749			2749			4.04
-- garden_tools				4329			4329			4.04


SELECT
    rev.review_score,
    COUNT(DISTINCT rev.order_id) AS total_orders,
    ROUND(AVG(order_values.order_value), 2) AS avg_order_value
FROM reviews_clean rev
JOIN (
    SELECT
        order_id,
        SUM(price) AS order_value
    FROM order_items_clean
    GROUP BY order_id
) AS order_values
    ON rev.order_id = order_values.order_id
GROUP BY rev.review_score
ORDER BY rev.review_score desc
;

-- relation review score and order_value
-- score || total orders || avg_order_value
-- 5		57006			  134.49
-- 4		19064			  132.28
-- 3		 8107			  127.63
-- 2		 3086		      145.29
-- 1		10854			  166.56
-- orders with lower scores tend to have higher average order values


SELECT COUNT(*) AS total_reviews, SUM(CASE WHEN review_score IN (1, 2) THEN 1 ELSE 0 END) AS negative_reviews,
    ROUND( SUM(CASE WHEN review_score IN (1, 2) THEN 1 ELSE 0 END) / COUNT(*) * 100,2 ) AS negative_review_percentage
FROM reviews_clean;

-- percentage of negative reviews
-- total 	|| negative reviews || percentage 
-- 99223			14575			14.69


SELECT COUNT(*) AS total_reviews, SUM(CASE WHEN review_score IN (4, 5) THEN 1 ELSE 0 END) AS positive_reviews,
    ROUND( SUM(CASE WHEN review_score IN (4, 5) THEN 1 ELSE 0 END) / COUNT(*) * 100,2 ) AS positive_review_percentage
FROM reviews_clean;

-- percentage of positive reviews
-- total 	|| positive reviews || percentage 
-- 99223			76469			77.07



-- ===============================
-- 9. Delivery / Logistics
-- ===============================


SELECT
    ROUND(
        AVG(DATEDIFF(order_delivered_customer_datetime, order_purchase_datetime)),
        2
    ) AS avg_delivery_days
FROM orders_clean
WHERE order_status = 'delivered'
  AND order_delivered_customer_datetime IS NOT NULL;
  
  -- average delivery days
  -- 12.50
  
  
SELECT
    ROUND(
        AVG(TIMESTAMPDIFF(HOUR, order_purchase_datetime, order_approved_datetime)),
        2
    ) AS avg_hours_purchase_to_approval
FROM orders_clean
WHERE order_status = 'delivered'
  AND order_approved_datetime IS NOT NULL
  AND order_purchase_datetime IS NOT NULL;
  
  -- average time for purchase approval 
  -- 9.92 hours
  
  
  SELECT
    ROUND(
        AVG(DATEDIFF(order_delivered_carrier_datetime, order_approved_datetime)),
        2
    ) AS avg_sent_days
FROM orders_clean
WHERE order_status = 'delivered'
  AND order_delivered_carrier_datetime IS NOT NULL
  AND order_approved_datetime IS NOT NULL;
  
-- average time between the approval and the order being sent is 
-- 2.70 days



  SELECT
    ROUND(
        AVG(DATEDIFF(order_delivered_customer_datetime, order_delivered_carrier_datetime)),
        2
    ) AS avg_delivery_days
FROM orders_clean
WHERE order_status = 'delivered'
  AND order_delivered_customer_datetime IS NOT NULL
  AND order_delivered_carrier_datetime IS NOT NULL;
  
-- average time for delivery of order after being sent 
-- 9.28 days

SELECT
    COUNT(*) AS total_delivered_orders,

    SUM(CASE 
        WHEN DATE(order_delivered_customer_datetime) < DATE(order_estimated_delivery_datetime)
        THEN 1 ELSE 0 
    END) AS delivered_before_estimate,

    SUM(CASE 
        WHEN DATE(order_delivered_customer_datetime) = DATE(order_estimated_delivery_datetime)
        THEN 1 ELSE 0 
    END) AS delivered_on_estimate,

    SUM(CASE 
        WHEN DATE(order_delivered_customer_datetime) > DATE(order_estimated_delivery_datetime)
        THEN 1 ELSE 0 
    END) AS delivered_after_estimate
FROM orders_clean
WHERE order_status = 'delivered'
  AND order_delivered_customer_datetime IS NOT NULL
  AND order_estimated_delivery_datetime IS NOT NULL;
  
  SELECT
    COUNT(*) AS total_delivered_orders,
    ROUND(SUM(CASE 
        WHEN date(order_delivered_customer_datetime) < date(order_estimated_delivery_datetime) 
        THEN 1 ELSE 0 
    END) / COUNT(*) * 100, 2) AS before_estimate_percentage,

    ROUND(SUM(CASE 
        WHEN DATE(order_delivered_customer_datetime) = DATE(order_estimated_delivery_datetime)
        THEN 1 ELSE 0 
    END) / COUNT(*) * 100, 2) AS on_estimate_percentage,

    ROUND(SUM(CASE 
        WHEN date(order_delivered_customer_datetime) > date(order_estimated_delivery_datetime) 
        THEN 1 ELSE 0 
    END) / COUNT(*) * 100, 2) AS after_estimate_percentage
FROM orders_clean
WHERE order_status = 'delivered'
  AND order_delivered_customer_datetime IS NOT NULL
  AND order_estimated_delivery_datetime IS NOT NULL;
  
-- orders delivered before, after or on the estimate time
-- orders delivered || before estimate || on estimate || after estimate ||
-- 		96470			88644(91.89%)	  1292(1.34%)		6534(6.77%)


select round( avg(datediff(order_delivered_customer_datetime,order_estimated_delivery_datetime)),2) as avg_delay_days
	from orders_clean
where order_status = 'delivered'
  and order_delivered_customer_datetime is not null
  and order_estimated_delivery_datetime is not  null
  and date(order_delivered_customer_datetime) > date(order_estimated_delivery_datetime);
	
-- average delay time is 
-- 10.62 days


SELECT
    cust.customer_state,
    COUNT(DISTINCT ord.order_id) AS total_orders,
    ROUND(
        AVG(DATEDIFF(ord.order_delivered_customer_datetime, ord.order_purchase_datetime)),
        2
    ) AS avg_delivery_days
FROM orders_clean ord
JOIN customers_clean cust
    ON ord.customer_id = cust.customer_id
WHERE ord.order_status = 'delivered'
  AND ord.order_delivered_customer_datetime IS NOT NULL
  AND ord.order_purchase_datetime IS NOT NULL
GROUP BY cust.customer_state
HAVING total_orders >= 50
ORDER BY avg_delivery_days ASC
LIMIT 10;

-- states with the faster deliveries
-- state || total orders || avg delivery days
--  SP		  40494				8.70
--  PR		   4923			   11.94
--  MG		  11354			   11.95
--  DF		   2080			   12.90
--  SC		   3546			   14.90
--  RJ		  12350		  	   15.24
--  RS		   5344			   15.25
--  GO		   1957			   15.54
--  MS		    701			   15.54
--  ES		   1995			   15.72


SELECT
    cust.customer_state,
    COUNT(DISTINCT ord.order_id) AS total_orders,
    ROUND(
        AVG(DATEDIFF(ord.order_delivered_customer_datetime, ord.order_purchase_datetime)),
        2
    ) AS avg_delivery_days
FROM orders_clean ord
JOIN customers_clean cust
    ON ord.customer_id = cust.customer_id
WHERE ord.order_status = 'delivered'
  AND ord.order_delivered_customer_datetime IS NOT NULL
  AND ord.order_purchase_datetime IS NOT NULL
GROUP BY cust.customer_state
HAVING total_orders >= 50
ORDER BY avg_delivery_days DESC
LIMIT 10;

-- states with the slowest deliveries
-- state || total orders || avg delivery days
--  AP			67				27.18
--  AM		   145				26.36
--  AL		   397				24.50
--  PA		   946				23.73
--  MA		   717				21.51
--  SE		   335				21.46
--  CE		  1279				21.20
--  AC			80				21.00
--  PB		   517				20.39
--  PI		   476				19.40

SELECT
    CASE
        WHEN DATE(ord.order_delivered_customer_datetime) > DATE(ord.order_estimated_delivery_datetime)
            THEN 'Delayed'
        ELSE 'On time or early'
    END AS delivery_status,
    COUNT(DISTINCT ord.order_id) AS total_orders,
    ROUND(AVG(rev.review_score), 2) AS avg_review_score
FROM orders_clean ord
JOIN reviews_clean rev
    ON ord.order_id = rev.order_id
WHERE ord.order_status = 'delivered'
  AND ord.order_delivered_customer_datetime IS NOT NULL
  AND ord.order_estimated_delivery_datetime IS NOT NULL
GROUP BY delivery_status
ORDER BY avg_review_score;

-- relation between time of arrival of the order and review score
-- status 			|| total orders || avg review score
-- Delayed					6381			 2.27
-- On time or early		   89442			 4.29



