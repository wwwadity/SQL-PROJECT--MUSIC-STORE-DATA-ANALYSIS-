/* Write a query that determines the customer that has spent the most on music for each 
country. Write a query that returns the country along with the top customer and how 
much they spent. For countries where the top amount spent is shared, provide all 
customers who spent this amount */
select*  from invoice;
  with recursive
  customer_with_country as(
  select  c.customer_id , first_name,last_name, billing_country,
  sum(total) as total_spending from invoice as n
  join customer as c on c.customer_id =n.customer_id
  group by 1,2,3,4 order by 1,5 desc
  ),
  max_count_spending as (
  select billing_country, max(total_spending) as max_speding
  from customer_with_country
  group by 1)
  select cc.billing_country,cc.total_spending, cc.first_name ,cc.last_name ,cc.customer_id
  from customer_with_country  as cc
  join max_count_spending as ms 
  on cc.billing_country =ms.billing_country
  order by 1 ;
  
  

  