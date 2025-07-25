select * from track;
select distinct email,first_name,last_name from customer as c
join invoice as n on c.customer_id = n.customer_id
join invoice_line as l on n.invoice_id = l.invoice_line_id
where track_id in(select track_id from track as t join genre as g on t.genre_id = g.genre_id where g.name like'ROCK')
order by email;
 /*2*/SELECT artist.artist_id ,artist.name ,count(artist.artist_id) as number_of_song from track
join album on album.album_id = track.album_id
join artist on artist.artist_id= album.artist_id
join genre on genre.genre_id =track.genre_id
where genre.name like'rock'
group by artist.artist_id ,artist.name  order by number_of_song desc limit 10;
/*2*/SELECT  artist.name ,count(artist.artist_id) as number_of_song from track
join album on album.album_id = track.album_id
join artist on artist.artist_id= album.artist_id
join genre on genre.genre_id =track.genre_id
where genre.name like'rock'
group by artist.name  order by number_of_song desc limit 10;

/*3. Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the 
longest songs listed first */
 select milliseconds,name from track where milliseconds >(select avg(milliseconds) as avg_track_lenth from track) order by milliseconds desc;



/*4. Who is the best customer? The customer who has spent the most money will be 
declared the best customer. Write a query that returns the person who has spent the 
most money*/
select * from invoice;
select c.customer_id ,c.first_name,c.last_name,sum(n.total) as sum_total  from customer  as c 
join invoice as n on c.customer_id =n.customer_id group by c.customer_id,c.first_name,c.last_name order by sum_total desc  limit 1;
select customer.customer_id, customer.first_name, customer.last_name, sum(invoice.total)as total_v from customer
join invoice on  customer.customer_id = invoice.customer_id 
group by customer.customer_id ,customer.first_name, customer.last_name 
ORDER BY total_v desc

LIMIT 1;
SELECT c.customer_id, MAX(n.total) AS max_total 
FROM customer AS c 
JOIN invoice AS n ON c.customer_id = n.customer_id 
GROUP BY c.customer_id 
ORDER BY max_total 


  /*5. We want to find out the most popular music Genre for each country. We determine the 
most popular genre as the genre with the highest amount of purchases. Write a query 
that returns each country along with the top Genre. For countries where the maximum 
number of purchases is shared return all Genres */
with popular_music as (
select count(*) as purchases, customer.country ,g.name,g.genre_id,
row_number() over(partition by customer.country  order by count(n.quantity)desc) as rowno from invoice_line as n
join invoice as i  on i.invoice_id =n.invoice_id
join customer on customer.customer_id = i.customer_id
join track as t on t.track_id =n.track_id
join genre as g on g.genre_id = t.genre_id
group by 2,3,4
order by 2 ) ,
 max_genre_per_country as 
(select max(purchases) as max_genre_number ,country from 
popular_music
group by 2
order by 2)
select popular_music .* from popular_music
join max_genre_per_country  on max_genre_per_country.country =popular_music.country
where popular_music.purchases =max_genre_per_country.max_genre_number;
WITH genre_purchases AS (
    SELECT 
        c.country, g.name AS genre,  COUNT(il.quantity) AS total_purchases FROM  invoice_line il 
  JOIN  invoice i ON i.invoice_id = il.invoice_id
    JOIN customer c ON c.customer_id = i.customer_id
    JOIN  track t ON t.track_id = il.track_id
    JOIN genre g ON g.genre_id = t.genre_id
    GROUP BY c.country, g.name), max_purchases AS ( SELECT  country, MAX(total_purchases) AS max_purchases
    FROM  genre_purchases GROUP BY   country)SELECT  gp.country, gp.genreFROM 
    genre_purchases gp
JOIN 
    max_purchases mp ON gp.country = mp.country AND gp.total_purchases = mp.max_purchases
ORDER BY 
    gp.country, gp.genre;



/*6 Write a query that determines the customer that has spent the most on music for each 
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
  
  

  
