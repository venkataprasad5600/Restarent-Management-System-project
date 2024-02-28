# creating a database with RESTARENT_MANAGEMENT
create database RESTARENT_MANAGEMENT ;

use restarent_management;

# creating table about restarent menu
create table Restarent_Menu
(Item_Id int auto_increment,Item_Name varchar(30),Item_Price int ,Item_Type enum('veg','status','main course','cool drink')
,primary key(Item_Id));

# inserting the data of menu details into restarent_menu
insert into restarent_menu values(1,'veg biriyani',170,'veg');
insert into restarent_menu values(2,'egg biriyani',180,'main course'),
								(3,'chicken biriyani',200,'main course'),
                                (4,'bone less biriyani',220,'main course'),
                                (5,'chicken noodles',170,'main course'),
                                (6,'veg noodle',130,'veg'),
                                (7,'chicken fried rice',160,'main course'),
                                (8,'checken 65',190,'status'),
                                (9,'chilly chicken',200,'status'),
                                (10,'chicken lolipops',290,'status'),
                                (11,'gobi fried rice',160,'veg'),
                                (12,'thumsup',10,'cool drink'),
                                (13,'spite',10,'cool drink');
# retriving all details in restarent_menu
select * from restarent_menu;                                

# creating table about staff details
create table staff_details(delivered_id int,name varchar(30),contact_details varchar(10),primary key(delivered_id));

# inserting data of staff credentials into staff_details							
insert into staff_details values(1,'rajesh',8989347833),
								(2,'teja',9892377823),
                                (3,'praveen',8723278322),
                                (4,'deekshith',7343498438);
# retriving all details in staff_details
select * from staff_details;


# creating table about booking details 
create table booking_details
(customer_id int ,table_booked int ,booking_status varchar(20),booking_time datetime,primary key(customer_id));
# creating table about customer details

#Inserting data into booking_details
insert into booking_details values(1,4,'approved',now());
insert into booking_details values(2,6,'approved','2024-02-27 16:57:25'),											
									(3,1,'approved','2024-02-27 16:59:45'),
                                    (4,3,'approved','2024-02-27 17:05:50'),
                                    (7,4,'canceled','2024-02-27 16:5:58'),
                                    (5,5,'approved','2024-02-27 16:12:29'),
                                    (6,2,'approved','2024-02-27 16:14:19'),
                                    (8,3,'canceled','2024-02-27 17:15:50'),
                                    (9,1,'approved','2024-02-27 17:59:40'),
                                    (10,3,'approved','2024-02-27 18:02:13'),
                                    (11,6,'approved','2024-02-27 16:57:08'),
                                    (15,1,'canceled','2024-02-27 18:02:01'),
                                    (12,5,'approved','2024-02-27 16:57:19'),
                                    (13,4,'approved','2024-02-27 18:23:32'),
                                    (14,5,'approved','2024-02-27 18:57:10'),
                                    (16,2,'approved','2024-02-27 19:02:24'),
                                    (17,4,'approved','2024-02-27 18:30:21');

# retriving the data from booking_details
select * from booking_details;

create table customer_details
(customer_id int  ,Item_Id int ,Item_Type  enum('veg','status','main course','cool drink'),
bill decimal(10,2),payment_method varchar(20),visit_date date,delivered_id int,foreign key(customer_id) references booking_details(customer_id)
,foreign key(Item_Id) references Restarent_Menu(Item_Id),foreign key(delivered_id) references staff_details(delivered_id)) ;
											
# inserting the data into customer_details
insert into customer_details values(1,3,'main course',200,'online',date(now()),1),
									(2,4,'main course',220,'cash',date(now()),1),
                                    (3,3,'main course',200,'credit card',date(now()),2),
                                    (1,12,'cool drink',10,'online',date(now()),4),
                                    (3,8,'status',190,'credit card',date(now()),2),
                                    (2,10,'status',290,'cash',date(now()),3),
                                    (2,13,'cool drink',10,'cash',date(now()),1),
                                    (5,6,'veg',130,'online',date(now()),2),
                                    (6,4,'main course',220,'cash',date(now()),4),
                                    (6,9,'status',200,'cash',date(now()),3),
                                    (9,1,'veg',170,'online',date(now()),2),
                                    (10,2,'main course',180,'credit card',date(now()),1),
                                    (10,10,'status',290,'credit card',date(now()),4),
                                    (9,13,'cool drink',10,'online',date(now()),1),
                                    (11,9,'status',200,'cash',date(now()),2),
                                    (11,13,'cool drink',10,'cash',date(now()),3),
                                    (12,11,'veg',160,'online',date(now()),4),
                                    (13,5,'main course',170,'credit card',date(now()),1),
                                    (14,5,'main course',170,'online',date(now()),2),
                                    (15,7,'main course',160,'online',date(now()),2),
                                    (14,7,'main course',160,'online',date(now()),2),
                                    (13,10,'status',290,'credit card',date(now()),4),
                                    (14,12,'cool drink',10,'online',date(now()),3),
                                    (16,7,'main course',160,'online',date(now()),3),
                                    (16,12,'cool drink',10,'cash',date(now()),1),
                                    (17,4,'main course',220,'cash',date(now()),3),
                                    (17,10,'status',200,'cash',date(now()),4);
# retriving the customer_details
# changing the column name 
alter table
customer_details 
rename column bill to amount;
select * from customer_details;

# 1) find the total number of items in restarent menu 
select 
count(*) as total_items 
from restarent_menu;

# 2)find the total amount spent by each customer in desc 
select 
customer_id,sum(amount) as total_amount 
from customer_details 
group by customer_id 
order by total_amount desc;

# 3)find the customer who made first booking 
select *,
min(booking_time) as first_booking 
from booking_details 
group by customer_id limit 1;

# 4)find the item which has never ordered
select 
r.item_id,r.item_name 
from restarent_menu as r 
where r.item_id not in
(select distinct item_id from customer_details);

# 5)find the customers who made more than one booking in  a day 
select 
customer_id ,count(*) 
from booking_details 
group by customer_id 
having count(*)>=1;

# 6)calculate the days difference of each customer first and latest order
select 
customer_id ,datediff(max(visit_date),min(visit_date)) as days_difference
from customer_details group by customer_id;

# 7)rank the items based on total amount spent by customers on each item
select * from customer_details;
select 
c.item_id,r.item_name,sum(amount) as total_amount,
rank() over( order by sum(amount) desc) as rank_on_item from customer_details  as c
left join restarent_menu as r on c.item_id=r.item_id group by r.item_name,c.item_id; 

# 8)find the 3 customers who paid most amount
select 
customer_id,sum(amount) as total_amount 
from customer_details 
group by customer_id 
order by total_amount desc limit 3;

# 9)count the customers who tryed to book the table in restarent 
select 
count(*) 
from booking_details;

# 10)count the customers whose booking is approved 
select 
count(*) 
from booking_details 
where booking_status='approved';

# 11)count the customers whose booking is cancelled
select 
count(*) 
from booking_details 
where booking_status<>'approved';

# 12)retrive the customer details who made a booking  which is approved
select
customer_id,booking_time,booking_status
from booking_details 
where customer_id in  
(select customer_id from booking_details where booking_status='approved');

# 13)retrive the customer details who made a booking  which is cancelled
select
customer_id,booking_time,booking_status
from booking_details 
where customer_id not in  
(select customer_id from booking_details where booking_status='approved');

# 14)find the no.of item sold by each item type
select item_type,
count(*) as no_of_item_sold
from customer_details 
group by item_type;

# 15)rank customers based on total amount spent 
select customer_id,
sum(amount) as total_spent, rank() over( order by sum(amount) desc) as rank_on_total_spent 
from customer_details group by customer_id;

# 16)retrive the customer details who made booking and order 
select distinct c.customer_id
from booking_details as c 
join booking_details as b 
on c.customer_id=b.customer_id 
join customer_details as d
on d.customer_id=c.customer_id;

# 17)list the items ordered and their prices including the customer details 
select 
r.item_id,r.item_name,c.customer_id 
from restarent_menu as r 
left join customer_details as c 
on r.item_id=c.item_id 
join booking_details as b 
on b.customer_id=c.customer_id;

# 18)find the customer who orderd less than 3 items
select
customer_id,count(*) as ordered_items 
from customer_details 
group by customer_id 
having count(*)>=3;

# 19)find the customers who made a booking but it's canceled using join 
select 
b.customer_id 
from booking_details as b 
join booking_details as c 
on b.customer_id=c.customer_id 
and b.booking_status='canceled';

# views 
# 20)create a view as showing the confirmed booking 
create view booking_confirmed 
as (select * from booking_details where booking_status='approved');
select * from booking_confirmed;

# 21)create a view on total sales by item type in any order 
create view sales_by_item as (
select 
item_type,
sum(amount) as total_amount 
from customer_details 
group by item_type 
order by total_amount desc );
select * from sales_by_item;

# 22)find the item id,item name which maximum sales occured by item type
select 
item_type,sum(amount) as maxsales_by_item 
from customer_details 
group by item_type limit 1;  

# 23)write a query to find the total sales by each item type in desc
select 
item_type,
sum(amount) as total_amount 
from customer_details 
group by item_type 
order by total_amount desc ;

# 24) find the no.of customer details paid through different payment methods
select 
payment_method ,count(*) as no_of_payements 
from customer_details 
group by payment_method;




