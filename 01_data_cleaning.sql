RENAME TABLE olist_orders_dataset TO orders;
RENAME TABLE olist_order_items_dataset TO order_items;
RENAME TABLE olist_products_dataset TO products;
RENAME TABLE olist_order_payments_dataset TO payments;
RENAME TABLE olist_order_reviews_dataset TO reviews;
RENAME TABLE olist_sellers_dataset TO sellers;
rename table olist_geolocation_dataset to geolocation;
rename table olist_customers_dataset to customers;
rename table product_category_name_translation to cat_trans;


-- REMOVE DUPLICATES 
DROP TABLE IF EXISTS orders_clean;
	SELECT *
FROM
    orders_clean;

CREATE TABLE orders_clean AS SELECT * FROM
    orders;

select * from(
 select *, row_number() over(
 Partition by order_id, customer_id, order_status, order_purchase_timestamp, order_approved_at, order_delivered_carrier_date, order_delivered_customer_date, order_estimated_delivery_date) as row_num
 from orders_clean) as duplicate_rows
 where row_num > 1;
 

		-- there are no duplicates on orders
	DROP TABLE IF EXISTS order_items_clean;
	SELECT *
FROM
    order_items;
CREATE TABLE order_items_clean AS SELECT * FROM
    order_items;


select * from(
 select *, row_number() over(
 Partition by order_id, order_item_id, product_id, seller_id, shipping_limit_date, price, freight_value) as row_num
 from order_items_clean)  as duplicate_rows
 where row_num > 1;
 
		-- there are no duplicates on order_items

DROP TABLE IF EXISTS prodcuts_clean;
	SELECT *
FROM
    products;
CREATE TABLE products_clean AS SELECT * FROM
    products;

select * from(
	select *, row_number() over(
 Partition by product_id, product_category_name, product_name_lenght, product_description_lenght, product_photos_qty, product_weight_g, product_length_cm, product_height_cm, product_width_cm) as row_num
	from products_clean) as duplicate_rows
 where row_num > 1;
 
		-- there are no duplicates on products
        
       DROP TABLE IF EXISTS payments_clean; 
	SELECT 
    *
FROM
    payments;
CREATE TABLE payments_clean AS SELECT * FROM
    payments;

select * from(
	select *, row_number() over(
 Partition by order_id, payment_sequential, payment_type, payment_installments, payment_value) as row_num
	from payments_clean) as duplicate_rows
 where row_num > 1;

		-- there are no duplicates on payments
	
    DROP TABLE IF EXISTS reviews_clean;
SELECT *
FROM
    reviews;
CREATE TABLE reviews_clean AS SELECT * FROM
    reviews;

select * from(
	select *, row_number() over(
 Partition by review_id, order_id, review_score, review_comment_title, review_comment_message, review_creation_date, review_answer_timestamp) as row_num
	from reviews_clean) as duplicate_rows
 where row_num > 1;
 
		-- there are no duplicates on reviews
    DROP TABLE IF EXISTS sellers_clean;
    
SELECT *
FROM
    sellers;
CREATE TABLE sellers_clean AS SELECT * FROM
    sellers;

select * from(
	select *, row_number() over(
 Partition by seller_id, seller_zip_code_prefix, seller_city, seller_state) as row_num
	from sellers_clean) as duplicate_rows
 where row_num > 1;
 
		-- there are no duplicates on sellers
	
drop table if exists geolocation_clean;
SELECT *
FROM
    geolocation;
CREATE TABLE geolocation_clean AS SELECT * FROM
    geolocation;

select * from(
	select *, row_number() over(
 Partition by geolocation_zip_code_prefix, geolocation_lat, geolocation_lng, geolocation_city, geolocation_state) as row_num
	from geolocation_clean) as duplicate_rows
 where row_num > 1;

drop table if exists geolocation_clean;
CREATE TABLE geolocation_clean AS SELECT DISTINCT * FROM
    geolocation;

		-- there were duplicates on geolocation table who have been deleted

DROP TABLE IF EXISTS customers_clean;
	SELECT *
FROM
    customers;
CREATE TABLE customers_clean AS SELECT * FROM
    customers;


select * from(
	select *, row_number() over(
 Partition by customer_id, customer_unique_id, customer_zip_code_prefix, customer_city, customer_state) as row_num
	from customers_clean) as duplicate_rows
 where row_num > 1;
 
		-- there are no duplicates on customers
    
SELECT *
FROM
    cat_trans;

ALTER TABLE cat_trans
RENAME COLUMN ï»¿product_category_name to product_category_name;

drop table if exists cat_trans_clean;
CREATE TABLE cat_trans_clean AS SELECT * FROM
    cat_trans;

select * from(
	select *, row_number() over(
 Partition by product_category_name, product_category_name_english) as row_num
	from cat_trans_clean) as duplicate_rows
 where row_num > 1;
    
    
		-- there are no duplicates on cat_trans table but I had to change the first column name which had strange characters
        
-- all duplicates removed, there were only duplicates on geolocation table and also changed the name of a column on the category translation table


-- Standardize Data

select distinct order_status from orders_clean;
select * from orders_clean;

select distinct(order_item_id) from order_items_clean;
select * from order_items_clean;

	-- nothing to standardize on orders_clean
    
select distinct(product_category_name) from products_clean;

 update products_clean
 set product_category_name = "telefonia"
 where product_category_name like "telefonia%";
 
update products_clean
 set product_category_name = "casa_conforto"
 where product_category_name like "casa_conforto%";
 
 update products_clean
 set product_category_name = "construcao_ferramentas"
 where product_category_name like "construcao_ferramentas%";
 
update products_clean
set product_category_name = "artes"
where product_category_name like "artes%";

update products_clean
set product_category_name = "pcs"
where product_category_name like "pc%";

	-- categories standardized on products_clean
    
select distinct(payment_installments) from payments_clean;

-- nothing to standardize on payments_clean

select * from reviews_clean;

-- nothing to standardize on reviews_clean

select distinct(seller_city) from sellers_clean;

update sellers_clean
set seller_city = "auriflama"
where seller_city like "auriflama%";

update sellers_clean
set seller_city = "angra dos reis"
where seller_city like "angra dos reis%";

update sellers_clean
set seller_city = "balneario camboriu"
where seller_city like "bal%";

update sellers_clean
set seller_city = "barbacena"
where seller_city like "barbacena%";

update sellers_clean
set seller_city = "cascavel"
where seller_city like "cascav%";

update sellers_clean
set seller_city = "ferraz de vasconcelos"
where seller_city like "ferraz%";

update sellers_clean
set seller_city = "jacarei"
where seller_city like "jacarei%";

update sellers_clean
set seller_city = "lages"
where seller_city like "lages%";

update sellers_clean
set seller_city = "maua"
where seller_city like "maua%";

update sellers_clean
set seller_city = "mogi das cruzes"
where seller_city like "mogi%";

update sellers_clean
set seller_city = "pinhais"
where seller_city like "pinhais%";

update sellers_clean
set seller_city = "ribeirao preto"
where seller_city like "ribeirao pret%";

update sellers_clean
set seller_city = "rio de janeiro"
where seller_city like "rio de janeiro%";

update sellers_clean
set seller_city = "santa barbara d oeste"
where seller_city like "santa barbara%";

update sellers_clean
set seller_city = "sao bernardo do campo"
where seller_city like "sao bernardo do ca%";

update sellers_clean
set seller_city = "sao miguel do oeste"
where seller_city like "sao miguel d%";

update sellers_clean
set seller_city = "sao paulo"
where seller_city like "sao pa%";

update sellers_clean
set seller_city = "sp"
where seller_city like "sp%";

delete from sellers_clean where seller_city like "vendas@%";
delete from sellers_clean where seller_city like "0448%";

select distinct(seller_state) from sellers_clean;

	-- on the sellers_clean many values on the seller_city column had to be standardized due to some city names were included the state, some misspellings, or contained invalid values

select distinct(geolocation_city) from geolocation_clean;

UPDATE geolocation_clean
SET geolocation_city =REPLACE(
					REPLACE(
					REPLACE(
					REPLACE(
					REPLACE(
                    REPLACE(
                    REPLACE(
                    REPLACE(
                    REPLACE(geolocation_city, 'Ã£', 'a'),
                                      'Ã¡', 'a'),
                                      'Ã©', 'e'),
                                      'Ã­', 'i'),
                                      'Ã³', 'o'),
                                      'Ã§', 'c'),
                                      "Ã¢","a"),
                                      'Ãµ',"o"),
                                      'Ã´',"o")
WHERE geolocation_city REGEXP 'Ã';

UPDATE geolocation_clean
SET geolocation_city = REPLACE(geolocation_city, 'Â£', 'a')
WHERE geolocation_city REGEXP 'Â';

update geolocation_clean
set geolocation_city = "sao paulo"
where geolocation_city like "%paulo";

update geolocation_clean
set geolocation_city = "embu guaco"
where geolocation_city like "%guacu";

update geolocation_clean
set geolocation_city = "guarulhos"
where geolocation_city like "guarulhos%";

update geolocation_clean
set geolocation_city = "mogi das cruzes"
where geolocation_city like "mogi%";

update geolocation_clean
set geolocation_city = "biritiba mirim"
where geolocation_city like "biritiba-mirim";

select distinct(geolocation_state) from geolocation_clean;

		-- on the geolocation_clean table had to do standardize many values from the geolocation_city column, some due to invalid characters, others due to misspelling 


select distinct(customer_city) from customers_clean;

update customers_clean
set customer_city = "arraial d ajuda"
where customer_city like "%d'ajuda";

update customers_clean
set customer_city = "arraial d oeste"
where customer_city like "%d'oeste";

update customers_clean
set customer_city = "dias d avila"
where customer_city like "%d'avila";

	-- on the customers_clean table had to standardize some values from the customer_city column 
    
    
    
-- NULL AND BLANK VALUES

select * from orders_clean;

		-- on the orders_clean table the blank values are justified by the order_status

select * from order_items_clean;
		-- there are no blank/null values on the order_items_clean table 

select * from products_clean;
		-- there are no blank/null values on the products_clean table
        
select * from payments_clean;
		-- there are no blank/null values on the payments_clean table
        
select * from reviews_clean;
		-- the blank values on the reviews_clean table correspond to reviews without title or without comment message,  but there are no null/blank values on the review_score so they remain viable
	
select * from sellers_clean;
		-- there are no blank/null values on the sellers_clean table

select * from geolocation_clean;
		-- there are no blank/null values on the geolocation_clean table
        
select * from customers_clean;
		-- there are no blank/null values on the customer_clean table

select * from cat_trans_clean;
		-- there are no blank/null values on the cat_tras_clean table
        
select * from order_items_clean
where price <= 0
or freight_value <= 0;

SELECT *
FROM payments_clean
WHERE payment_value <= 0;
	
		-- the payments that have value 0 were payed with vouchers or are not defined
        
SELECT *
FROM reviews_clean
WHERE review_score < 1 OR review_score > 5;

SELECT *
FROM products_clean
WHERE product_weight_g <= 0
   OR product_length_cm <= 0
   OR product_height_cm <= 0
   OR product_width_cm <= 0;
   
-- We can conclud that there are no weird values so we can proceed with the EDA


select * from orders_clean;

ALTER TABLE orders_clean
ADD COLUMN order_purchase_datetime DATETIME,
ADD COLUMN order_approved_datetime DATETIME,
ADD COLUMN order_delivered_carrier_datetime DATETIME,
ADD COLUMN order_delivered_customer_datetime DATETIME,
ADD COLUMN order_estimated_delivery_datetime DATETIME;

UPDATE orders_clean
SET 
    order_purchase_datetime = STR_TO_DATE(NULLIF(order_purchase_timestamp, ''), '%Y-%m-%d %H:%i:%s'),
    order_approved_datetime = STR_TO_DATE(NULLIF(order_approved_at, ''), '%Y-%m-%d %H:%i:%s'),
    order_delivered_carrier_datetime = STR_TO_DATE(NULLIF(order_delivered_carrier_date, ''), '%Y-%m-%d %H:%i:%s'),
    order_delivered_customer_datetime = STR_TO_DATE(NULLIF(order_delivered_customer_date, ''), '%Y-%m-%d %H:%i:%s'),
    order_estimated_delivery_datetime = STR_TO_DATE(NULLIF(order_estimated_delivery_date, ''), '%Y-%m-%d %H:%i:%s');
    
SELECT 
order_purchase_timestamp,
order_purchase_datetime
FROM orders_clean
LIMIT 20;

ALTER TABLE orders_clean
DROP COLUMN order_purchase_timestamp,
DROP COLUMN order_approved_at,
DROP COLUMN order_delivered_carrier_date,
DROP COLUMN order_delivered_customer_date,
DROP COLUMN order_estimated_delivery_date;




DROP TABLE IF EXISTS reviews;

CREATE TABLE reviews (
    review_id VARCHAR(50),
    order_id VARCHAR(50),
    review_score INT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date VARCHAR(50),
    review_answer_timestamp VARCHAR(50)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_order_reviews_dataset.csv'
INTO TABLE reviews
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
ESCAPED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

SHOW VARIABLES LIKE 'secure_file_priv';


UPDATE products_clean prod
JOIN cat_trans tra
    ON prod.product_category_name = tra.product_category_name
SET prod.product_category_name = tra.product_category_name_english;

