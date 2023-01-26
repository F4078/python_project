----Discount Effects

----Generate a report including product IDs and discount effects on whether the increase in the discount rate positively impacts the number of orders for the products.

with t1 as (
select *,
      sum(quantity) over( partition by product_id, discount) as min_discount_quantity 
from sale.order_item
where discount = ( select min(discount) 
                   from sale.order_item )
) , t2 as (
select * ,  
       sum(quantity) over( partition by product_id, discount) as max_discount_quantity 
	   from sale.order_item
	   where discount = ( select max(discount)
	                      from sale.order_item)
) 
select distinct t1.product_id, 
      case 
	    when t2.max_discount_quantity  > t1.min_discount_quantity then 'Pozitive'
		when t2.max_discount_quantity  = t1.min_discount_quantity then 'Neutral'
		else 'Negative' end as Discount_effect 
from t1 
   inner join t2 
         on t1.product_id = t2.product_id
order by t1.product_id