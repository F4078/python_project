---1---
---How many customers are in each city?
---Your solution should include the city name and the number of customers sorted from highest to lowest.
SELECT city, COUNT(customer_id) AS customer_total_city
FROM SampleRetail.sale.customer
GROUP BY city
ORDER BY customer_total_city DESC ;
---2---
---Find the total product quantity of the orders. Your solution should include order ids and quantity of products.
SELECT order_id , SUM(quantity) AS total_product_total
FROM SampleRetail.sale.order_item
GROUP BY order_id
---3---
 --- Find the first order date for each customer_id.
SELECT customer_id, MIN(order_date) AS fird_order_date
FROM SampleRetail.sale.orders
GROUP BY customer_id
---4---
---Find the total amount of each order.
---Your solution should include order id and total amount sorted from highest to lowest.
SELECT order_id ,SUM(list_price) AS order_total
FROM SampleRetail.sale.order_item
GROUP BY order_id
ORDER BY order_total DESC
---5---
---Find the order id that has the maximum average product price.
---Your solution should include only one row with the order id and average product price.
SELECT TOP(1) order_id ,AVG(list_price) AS ave_product_price
FROM SampleRetail.sale.order_item
GROUP BY order_id
ORDER BY ave_product_price DESC;
---6---
 ---Write a query that displays brand_id, product_id and list_price sorted first by brand_id (in ascending order)
 ---and then by list_price  (in descending order).

SElECT brand_id, product_id,list_price 
FROM SampleRetail.product.product
ORDER BY brand_id ASC,list_price DESC ;
---7---
---Write a query that displays brand_id, product_id and list_price,
---but this time sorted first by list_price (in descending order), and then by brand_id (in ascending order).
SElECT brand_id, product_id,list_price 
FROM SampleRetail.product.product
ORDER BY list_price DESC,brand_id ASC ;

---8---
-- 6. ve 7. soruya göre karþýlaþtýrma yaptýðýmýzda ORDER BY komutu öncelik sýrasýna göre çalýþýr ve o duruma göre seçme iþlemiyapar.
-- 6.soruda bize öncelik olarak brand_id sütununu sýraladý mesela brand_id sütununda '1' sayýsýna sonuna geldiðinde diðer þartýmýzý devreye girerek
-- list_price artandan azalana göre sýralama yaptý.7.sorudada bu durumun tersi gerçekleþti.

---9---
-- Write a query to pull the first 10 rows and all columns from the product table that have a list_price greater than or equal to 3000
SELECT TOP(10) * 
FROM SampleRetail.product.product
WHERE list_price >= 3000 ;

--10--
--Write a query to pull the first 5 rows and all columns from the product table that have a list_price less than 3000.
SELECT TOP(5) *
FROM SampleRetail.product.product
WHERE list_price < 3000 ;

--11--
-- Find all customer last names that start with 'B' and end with 's'.
SELECT last_name
FROM SampleRetail.sale.customer
WHERE last_name LIKE 'B%S' ;

--12--
--Use the customer table to find all information regarding customers whose address is Allen or Buffalo or Boston or Berkeley
SELECT *
FROM SampleRetail.sale.customer
WHERE city = 'Allen' OR city = 'Buffalo' OR city = 'Boston' OR city = 'Berkeley' ;