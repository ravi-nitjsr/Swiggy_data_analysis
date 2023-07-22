-- Q1) FIND THE CUSTOMERS WHO HAVE NEVER ORDERED ?   

SELECT name from Users 
WHERE user_id NOT IN (SELECT user_id FROM ORDERS )

#------------------------------------------------------------------------------------------------------------

-- Q2) FIND THE AVERAGE PRICE OF EACH DISC ?

SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
select f.f_name , avg(price) AS "Avg PRICE"
FROM menu m
join food f
on m.f_id = f.f_id
group by m.f_id ;

#-------------------------------------------------------------------------------------------------------

-- Q3) FIND THE TOP RESTURANTS IN TERMS OF NUMBER OF ORDERS FOR A GIVEN MONTHS ?
             
# I have to extract months from date column 

-- SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
select r.r_name ,count(*) as "month"
from orders o
JOIN restaurants r
ON o.r_id = r.r_id
where monthname(date) like 'June'
group by o.r_id 
order by count(*) desc limit 1 ;

#------------------------------------------------------------------------------------------------------

/* Q4 ) RESTURANTS WITH MONTHLY SALE > 500 */

select r_id , sum(amount) AS 'revenue'
from orders 
where monthname(date) like 'june'
group by r_id
having revenue>500 

As the above code only gives the resturant id  so i have to join 
resturants table with the orders table 
  
  
 -- select r.r_name , sum(amount) AS 'revenue'
 from orders o
 join restaurants r
 on o.r_id=r.r_id
 where monthname(date) like 'june'
 group by o.r_id
 having revenue>500 

#------------------------------------------------------------------------------------------------------------------

/* Q5) SHOW ALL ORDERS WITH ORDER DETAIL FOR A PARTICULAR CUSTOMER
      IA A PARTICULAR DATE RANGE ?
 
i.e i have to select one particular customer and print his order detail.
*/

select * from orders 
where 
user_id=(select user_id from users where name like "Ankit")
and date> "2022-06-10" and date < "2022-07-10"

/* but i have to include resturants name and the food that he ordered */

Select o.order_id , r.r_name , f.f_name
from orders o
join restaurants r 
ON r.r_id = o.r_id
join order_details od 
on o.order_id = od.order_id
join food f
on f.f_id = od.f_id
where user_id=(select user_id from users where name like "Ankit")
and date> "2022-06-10" and date < "2022-07-10"

#---------------------------------------------------------------------------------------------------------------------


/* Q6) FIND THE RESTAURANTS WITH MAX REPEATED CUSTOMERS ? */

select r.r_name , count(*) as 'Repeated_customer'
from (
select r_id , user_id , count(*) as 'visits'
from orders
group by r_id , user_id
having visits >1 
)t
join restaurants r 
on r.r_id = t.r_id
group by t.r_id
order by Repeated_customer desc limit 1 ;

#-----------------------------------------------------------------------------------------------------------------

/* Q7) Months over months revenue growth of swiggy ? 

 for the above ques. i have to calculate the growth rate month by month
 and groupby on month column followed by 
 sum as a aggregate function on amount column .*/
 
 
 
 select month ,((revenue - prev)/prev)*100 from 
 (
	WITH sales as 
    (
		 select monthname(date) as 'month' , sum(amount) as 'revenue'
		 from orders 
		 group by month
		 order by month(date)
    )
    select month , revenue , lag(revenue ,1) over 
	(order by revenue) as prev from sales 
  )t


#------------------------------------------------------------------------------------------------------------------
 
 /* Q8) PRINT THE NAME OF EACH CUSTOMERS AND HIS FAVOURITE FOOD 
 */

WITH temp as 
(
	select o.user_id , od.f_id , count(*) as frequency 
    from orders o 
    join order_details od
    on o.order_id=od.order_id
    group by o.order_id , od.f_id
)

select u.name, f.f_name from
temp t1 
join users u
on u.user_id = t1. user_id
join food f 
on f.f_id = t1.f_id 
where t1.frequency = ( select
	     max(frequency) from temp t2 where
         t2.user_id = t1.user_id )

#-------------------------------------------------------------------------------------------------------------------------------------------





 