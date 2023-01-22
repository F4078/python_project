---RDB&SQL Assignment-2 SOLUTION---

--1. Product Sales

---You need to create a report on whether customers who purchased the product named '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD' buy the product below or not.

---1. 'Polk Audio - 50 W Woofer - Black' -- (other_product)



with t1 as
(SELECT distinct A.customer_id
FROM product.product p, sale.order_item oi, sale.orders o, sale.customer A
WHERE p.product_id = oi.product_id and oi.order_id = o.order_id and o.customer_id = A.customer_id
and p.product_name = 'Polk Audio - 50 W Woofer - Black')

SELECT distinct c.customer_id, c.first_name, c.last_name,
   CASE 
   WHEN t1.customer_id = c.customer_id THEN 'Yes' ELSE 'No' END AS Other_project  
FROM product.product p, sale.order_item oi, sale.orders o, sale.customer c, t1
WHERE p.product_id = oi.product_id and oi.order_id = o.order_id and o.customer_id = c.customer_id
and p.product_name = '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'
order by  c.customer_id 


---- 2.question solution --

CREATE TABLE ECommerce (	Visitor_ID INT IDENTITY (1, 1) PRIMARY KEY,	Adv_Type VARCHAR (255) NOT NULL,	Action1 VARCHAR (255) NOT NULL);
INSERT INTO ECommerce (Adv_Type, Action1)VALUES ('A', 'Left'),('A', 'Order'),('B', 'Left'),('A', 'Order'),('A', 'Review'),('A', 'Left'),('B', 'Left'),('B', 'Order'),('B', 'Review'),('A', 'Review');



WITH T1 AS 
( 
SELECT	adv_type, COUNT (Action1) as adv_type_total 
FROM	ECommerce
GROUP BY 
		adv_type  
), T2 AS
( 
SELECT	adv_type, COUNT (Action1) as total_order
FROM	ECommerce
WHERE	Action1 = 'Order' 
GROUP BY 
		adv_type 
) 
SELECT	T1.adv_type, CAST (ROUND (1.0*T2. total_order / T1.adv_type_total , 2) AS decimal(3,2)) AS Conversion_Rate 
FROM	T1, T2 
WHERE	T1.adv_type = T2.adv_type ; 