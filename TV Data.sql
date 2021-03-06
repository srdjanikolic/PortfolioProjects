
# some data insights on CableTv Company were drawn from the following file on Kaggle : https://www.kaggle.com/datasets/amansaxena/cabletv-subscriber-data
# additional file was added with randomly populated cities related to ID


select * from 
cabletvsubscribersdata;

#number of customers
select count(*)
from 
cabletvsubscribersdata;

select distinct count(income)
from 
cabletvsubscribersdata;

#take a look at the average age of our viewers

select avg(age) as Avg_age_of_Viewers
from cabletvsubscribersdata;

#take a look at percentage of male vs female Viewers

select gender, round(count(gender)/300*100) as Viewer_Gender_Percent
from cabletvsubscribersdata
group by gender;

# take a look at the average age of male viewers and average age of female viewers

select gender, avg(age) as Viewer_Avg_AGE
from cabletvsubscribersdata
group by gender;

#let's check how many of our customer have kids

select count(customer_id)
from cabletvsubscribersdata
where kids >=1;

# who is the customer with the most additional members(kids)

select customer_id, income
from cabletvsubscribersdata
where kids = (select max(kids) from cabletvsubscribersdata);

 #who are the customers that have most kids(additional members)
 
select round(count(customer_id)/300 * 100) as Percent_Viewers_NO_Kids
from cabletvsubscribersdata
where kids < 1;

# average salary of our viewers

select round(avg(income)) as Avg_Income
from cabletvsubscribersdata
order by income desc;

#average income by gender

select gender, round(avg(income)) as Avg_Income_perGender
from cabletvsubscribersdata
group by gender
order by income desc;

#average income of viewers with certain number of kids

select kids, round(avg(income))
from cabletvsubscribersdata
group by kids
order by kids desc;

#how many of our viewers are subscribed to our TV and how many are not

select round(count(customer_ID)/300 * 100,1) as Percent_Viewers_NonSub,
(100-(round(count(customer_ID)/300 * 100,1))) as Percent_Viewers_Sub
from cabletvsubscribersdata
where subscribe = 'subNo';

# Subscriber vs Non subscriber per Gender

select gender,round(count(customer_ID)/300 * 100,1) as Percent_Viewers_NonSub,
(100-(round(count(customer_ID)/300 * 100,1))) as Percent_Viewers_Sub
from cabletvsubscribersdata
where subscribe = 'subNo'
group by gender;

# how many Viewers own a Home
select concat(count(customer_ID)/300 * 100,'%') as Own_Home
from cabletvsubscribersdata
where ownHome = 'ownYes'
;

# how many Viewers who own a home and are subscribed to us

select concat(count(customer_ID),'%') as OwnHouse_AreSub
from cabletvsubscribersdata
where ownHome = 'ownYes' and subscribe = 'subYes';

#how many Travelers are not subscribed to us

select subscribe, count(Segment)
from cabletvsubscribersdata
where Segment = 'Travelers'
group by subscribe;

# load in a table with customer IDs and respective cities they live in 
select * from
cabletvcity;

#check the number of customers in each city, Wien has the most customers...

select city, count(city)
from cabletvcity
group by city
order by count(city) desc; 

 # average age of viewers is highest in Graz and lowest in Linz
 
select city, round(avg(age),1) as avg_age
from cabletvsubscribersdata as main
inner join cabletvcity as c
on main.customer_id = c.customer_id
group by city
order by avg_age desc;

# average income in Wien by gender

select city, gender,avg(income)
from cabletvsubscribersdata as main
inner join cabletvcity as city
on main.customer_id = city.customer_id
where city.city = 'Wien'
group by gender; 


 # min and max age of customers in each of the cities earning at least 40000 per year
 
select city, max(age) as Oldest_Customer, min(age) as Youngest_Customer
from cabletvcity as city
inner join cabletvsubscribersdata as main 
on city.customer_id = main.customer_id
where income > 40000
group by city;




	













