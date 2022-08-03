# some data insights on CableTv Company were drawn from the following file on Kaggle : https://www.kaggle.com/datasets/amansaxena/cabletv-subscriber-data
# additional file was added with randomly populated cities related to ID


select * from 
cabletvsubscribersdata;

#number of customers
select count(*) as NumberCustomers
from 
cabletvsubscribersdata;

select distinct count(customer_Id) as DistinctCustomers
from 
cabletvsubscribersdata;

#take a look at the average age of our viewers

select round(avg(age),1) as Avg_age_of_Viewers
from cabletvsubscribersdata;

#take a look at percentage of male vs female Viewers

select gender, concat(count(gender)/300*100,"%") as Viewer_Gender_Percent
from cabletvsubscribersdata
group by gender;

# take a look at the average age of male viewers and average age of female viewers

select gender, round(avg(age),1) as Viewer_Avg_AGE
from cabletvsubscribersdata
group by gender;

#let's check how many of our customer have kids

select count(customer_id) as CustomersWithKids
from cabletvsubscribersdata
where kids >=1;

# who is the customer with the most additional members(kids)

select customer_id, income
from cabletvsubscribersdata
where kids = (select max(kids) from cabletvsubscribersdata);

 #percentage of customers with no kids
 
select concat(count(customer_id)/300 * 100,"%") as Percent_Viewers_NO_Kids
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
order by Avg_Income_perGender desc;

#average income of viewers with certain number of kids

select kids as NumberOfKids, round(avg(income)) as Average_income
from cabletvsubscribersdata
group by kids
order by kids desc;

#how many of our viewers are subscribed to our TV and how many are not

select round(count(customer_ID)/300 * 100,1) as Percent_Viewers_NonSub,
(100-(round(count(customer_ID)/300 * 100,1))) as Percent_Viewers_Sub
from cabletvsubscribersdata
where subscribe = 'subNo';

# Non subscriber per Gender

select gender,round(count(customer_ID)/300 * 100,1) as Percent_Viewers_NonSub
from cabletvsubscribersdata
where subscribe = 'subNo'
group by gender;

#subscribers per gender which are subscribed but do not own a home

select gender,round(count(customer_ID)/300 * 100,1) as Percent_Viewers_NonSub
from cabletvsubscribersdata
where subscribe = 'subYes' and ownHome = 'ownNo'
group by gender;


# how many Viewers own a Home
select concat(count(customer_ID)/300 * 100,'%') as Own_Home
from cabletvsubscribersdata
where ownHome = 'ownYes';

# how many Viewers who own a home and are subscribed to us

select count(customer_ID)/300*100 as OwnHouseAreSub_Percentage
from cabletvsubscribersdata
where ownHome = 'ownYes' and subscribe = 'subYes';


#selecting customers and labeling them depending on the the amount of salary earned

select customer_id,income,
case
	when avg(income) between 0 and 30000 then "Low Income"
    when avg(income) between 31000 and 50000 then "Middle Income"
    else "High Income" end as IncomeSituation
from cabletvsubscribersdata
group by customer_id;


# load in a table with customer IDs and respective cities they live in 
select * from
cabletvcity;

#check the number of customers in each city, Wien has the most customers...

select city, count(city) as CustomerCount
from cabletvcity
group by city
order by CustomerCount desc;

 # average age of viewers is highest in Graz and lowest in Linz
 
select city, round(avg(age),1) as avg_age
from cabletvsubscribersdata as main
inner join cabletvcity as c
on main.customer_id = c.customer_id
group by city
order by avg_age desc;

# average income in Wien by gender

select city, gender,round(avg(income),0) as Average_Income
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
