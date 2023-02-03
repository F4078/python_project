
---	SQL PROJECT 



---Analyze the data by finding the answers to the questions below

--1.Find the top 3 customers who have the maximum count of orders.
--(Maksimum sipariþ sayýsýna sahip ilk 3 müþteriyi bulun)

SELECT TOP 3 Cust_ID, Customer_Name ,Order_Quantity
FROM dbo.e_commerce_data
ORDER BY Order_Quantity DESC ; 

--2. Find the customer whose order took the maximum time to get shipping.
--( Sipariþinin kargoya ulaþmasý en uzun süreyi alan müþteriyi bulun.)

SELECT TOP 1 *
FROM dbo.e_commerce_data
ORDER BY DaysTakenForShipping DESC 

---2.solutýon 

SELECT TOP 1  * ,
    MAX(DaysTakenForShipping) OVER (ORDER BY DaysTakenForShipping DESC ) AS max_shipping 
     
FROM dbo.e_commerce_data


--3.Count the total number of unique customers in January and how many of them came back every month over the entire year in 2011
---(Ocak ayýndaki toplam benzersiz müþteri sayýsýný ve kaç tanesini sayýn 2011'de tüm yýl boyunca her ay geri geldi) 

select count( DISTINCT Cust_ID) as total_came_back_every_2011
FROM dbo.e_commerce_data
where DATEPART(MONTH, Order_Date) = 1 AND DATEPART(YEAR , Order_Date) = 2011


--4. Write a query to return for each user the time elapsed between the first purchasing and the third purchasing, in ascending order by Customer ID.
--(satýn alma ve üçüncü satýn alma, Müþteri Kimliðine göre artan sýrada.) 

SELECT *
FROM dbo.e_commerce_data
WHERE Order_Quantity BETWEEN 1 AND 3 
ORDER BY Cust_ID --- default olarak ascending 

--5.Write a query that returns customers who purchased both product 11 and product 14, as well as the ratio of these products to the total number of products purchased by the customer.
--(Hem 11. ürünü hem de 14. ürünü satýn alan müþterileri ve bu ürünlerin müþterinin satýn aldýðý toplam ürün sayýsýna oranýný döndüren bir sorgu yazýn.


 WITH T1 AS 
 ( SELECT Prod_ID, Cust_ID  
FROM dbo.e_commerce_data
WHERE Prod_ID = 'Prod_14' )
,T2 AS (
 SELECT d.Cust_ID 
 FROM dbo.e_commerce_data AS d , T1
WHERE d.Cust_ID = t1.Cust_ID
AND d.Prod_ID = 'Prod_11' 	)
, T3 AS 
(SELECT DISTINCT T2.Cust_ID , 
       COUNT(Prod_ID) over (PARTITION BY T2.Cust_ID) as total_product
FROM dbo.e_commerce_data D, T2 
WHERE D.Cust_ID = T2.Cust_ID )

SELECT DISTINCT D1.Cust_ID,  CAST((1.0*2 / T3.total_product) AS DECIMAL(3,2)) as ratýo_product 
FROM dbo.e_commerce_data D1 , T3
WHERE T3.Cust_ID = D1.Cust_ID


---Customer Segmentation

--1.Create a “view” that keeps visit logs of customers on a monthly basis. (For each log, three field is kept: Cust_id, Year, Month)
---(Aylýk olarak müþterilerin ziyaret günlüklerini tutan bir "görünüm" oluþturun. (Ýçin her günlükte üç alan tutulur: Cust_id, Year, Month)




CREATE VIEW vw_monthly_visit
as 
SELECT DISTINCT Cust_ID, 
       DATEPART(YEAR, Order_Date) AS Year,
	   DATEPART(MONTH, Order_Date) AS Month
FROM dbo.e_commerce_data

SELECT * 
FROM vw_monthly_visit

---2.Create a “view” that keeps the number of monthly visits by users. (Show separately all months from the beginning business)
--(Kullanýcýlarýn aylýk ziyaret sayýsýný tutan bir "görünüm" oluþturun. (Göstermek baþlangýçtan itibaren tüm aylar ayrý ayrý)


CREATE VIEW vw_seperate_month 
as 
SELECT * FROM ( SELECT DISTINCT Cust_ID, 
      DATENAME(M, Order_Date) as month_of_year 
FROM dbo.e_commerce_data ) T

PIVOT ( 
     COUNT(Cust_ID)
	 FOR month_of_year IN([January], [February ], [March ], [April ],[May], [June], [July ],[August ], [September],[October ], [November ],[December ] )
	 )  as pvt 

select * from vw_seperate_month
GO


---3.For each visit of customers, create the next month of the visit as a separate column.
---(müþterilerin her ziyaretinde sonra gelecek ziyareti için ayrý bir sutun oluþturun) 

with t1 as(
SELECT  Cust_ID, Order_date,
      LEAD(Order_Date) OVER(PARTITION BY Cust_ID ORDER BY Order_date) AS two_visit 
FROM dbo.e_commerce_data )

SELECT DISTINCT t1.Cust_ID,     
      FIRST_VALUE(two_visit) OVER(PARTITION BY t1.Cust_ID ORDER BY t1.Order_date) as two_visit_date
FROM dbo.e_commerce_data D1
 inner join t1 on D1.Cust_ID = t1.Cust_ID
 ORDER BY t1.Cust_ID


 ---4.Calculate the monthly time gap between two consecutive visits by each customer
 ---(Her iki ardýþýk ziyaret arasýndaki aylýk zaman aralýðýný hesaplayýn her müþteri için) 

with t1 as (
 SELECT Cust_ID, Order_Date,
      MIN(Order_Date) OVER (PARTITION BY Cust_ID ORDER BY Order_Date) AS first_order,
	  LEAD(order_date) OVER (PARTITION BY Cust_ID ORDER BY Order_Date) AS two_order
FROM dbo.e_commerce_data)
, t2 as (
select  *,
    DATEDIFF(MONTH, first_order, two_order) AS dýfferent_výsýt 
from t1 ) 

SELECT DISTINCT Cust_ID,
    FIRST_VALUE(dýfferent_výsýt) over(PARTITION BY Cust_ID order by Order_date) as dýfferent_výsýt_month 
FROM t2


---5.Categorise customers using average time gaps. Choose the most fitted labeling model for you.

----For example:
-------1. Labeled as churn if the customer hasn't made another purchase in the months since they made their first purchase.

-------2. Labeled as regular if the customer has made a purchase every month.
go

with t11 as (
 SELECT Cust_ID, Order_Date,
      MIN(Order_Date) OVER (PARTITION BY Cust_ID ORDER BY Order_Date) AS first_order1,
	  LEAD(order_date) OVER (PARTITION BY Cust_ID ORDER BY Order_Date) AS two_order1
FROM dbo.e_commerce_data)
, t22 as (
select  *,
    DATEDIFF(MONTH, first_order1, two_order1) AS dýfferent_výsýt1 
from t11 ) 

,t33 as (

SELECT *,
    FIRST_VALUE(dýfferent_výsýt1) over(PARTITION BY Cust_ID order by Order_date) as dýfferent_výsýt_month1 
FROM t22 )

SELECT DISTINCT Cust_ID,
  CASE 
    WHEN dýfferent_výsýt_month1 = 0 THEN 'regular' ELSE 'churn' END AS customer_status 
FROM t33
ORDER BY Cust_ID


    /*           Month-Wise Retention Rate
 Find month-by-month customer retention ratei since the start of the business.
There are many different variations in the calculation of Retention Rate. But we will
try to calculate the month-wise retention rate in this project.

So, we will be interested in how many of the customers in the previous month could
be retained in the next month.

Proceed step by step by creating “views”. You can use the view you got at the end of
      the Customer Segmentation section as a source.

                   1. Find the number of customers retained month-wise. (You can use time gaps)

                   2. Calculate the month-wise retention rate.

Month-Wise Retention Rate = 1.0 * Number of Customers Retained in The Current Month / Total
Number of Customers in the Current Month   */


with t1 as (
select *, January + [February ]  + [March ] + [April ] + May + June + [July ] +[August ] + September + [October ] + [November ] + [December ] AS total_number_of_customer
from vw_seperate_month ) 

SELECT CAST(January * 1.0 / total_number_of_customer AS DECIMAL(10,3)) AS January_ratio,
       CAST([February ] * 1.0 / total_number_of_customer AS DECIMAL(10,3)) AS February_ratio,
	   CAST([March ] * 1.0 / total_number_of_customer AS DECIMAL(10,3)) AS March_ratio,
	   CAST([April ] * 1.0 / total_number_of_customer AS DECIMAL(10,3)) AS April_ratio,
       CAST(May * 1.0 / total_number_of_customer AS DECIMAL(10,3)) AS May_ratio,
       CAST(June * 1.0 / total_number_of_customer AS DECIMAL(10,3)) AS June_ratio,
	   CAST([July ] * 1.0 / total_number_of_customer AS DECIMAL(10,3)) AS July_ratio,
	   CAST([August ] * 1.0 / total_number_of_customer AS DECIMAL(10,3)) AS August_ratio,
	   CAST(September * 1.0 / total_number_of_customer AS DECIMAL(10,3)) AS September_ratio,
	   CAST([October ] * 1.0 / total_number_of_customer AS DECIMAL(10,3)) AS October_ratio,
	   CAST([November ]  * 1.0 / total_number_of_customer AS DECIMAL(10,3)) AS November_ratio,
	   CAST([December ] * 1.0 / total_number_of_customer AS DECIMAL(10,3)) AS December_ratio
FROM t1







