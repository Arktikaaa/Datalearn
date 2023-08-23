### **Модуль 2 - Домашняя работа** :smile:
--------------------------------------------
#### **2.2 Что такое базы данных и как они помогают при работе с данными**
--------------------------------------------
1. Установить базу данных к себе на компьютер.    
Установлена база данных Postgres. 

#### **2.3 Подключение к Базам Данных и SQL**
-----------------------------------------
1. Установить клиента SQL для подключения базы данных.  
Установлен DBeaver.
2. Создание 3х таблиц и загрузка данных из Superstore Excel файл в локальную базу данных.  
Таблицы созданы и заполнены данными, скрипты  сохранены на GitHub ([orders](https://github.com/Arktikaaa/Datalearn/blob/main/de101/module02/orders.sql), [people](https://github.com/Arktikaaa/Datalearn/blob/main/de101/module02/people.sql), [returns](https://github.com/Arktikaaa/Datalearn/blob/main/de101/module02/returns.sql)).
3. Написание запросов в соответсвии с задачими [Модуля 01](https://github.com/Data-Learn/data-engineering/tree/master/DE-101%20Modules/Module01/DE%20-%20101%20Lab%201.1#%D0%B0%D0%BD%D0%B0%D0%BB%D0%B8%D1%82%D0%B8%D0%BA%D0%B0-%D0%B2-excel), сохранение запросов на GitHub.
###### Total Sales
select sum(sales) as Total_Sales
from orders o 
left join "returns" r on r.order_id = o.order_id 
where r.order_id is null;

###### Total Profit
select sum(profit) as Total_Profit
from orders o 
left join "returns" r on r.order_id = o.order_id 
where r.order_id is null;

###### Profit per Order
select o.order_id, SUM(profit)
from orders o 
left join "returns" r on r.order_id = o.order_id 
where r.order_id is null
group by o.order_id; 

###### Sales per Customer 
select customer_id, SUM(sales)
from orders o 
left join "returns" r on r.order_id = o.order_id 
where r.order_id is null
group by customer_id;


###### Avg_Discount
select round(AVG(discount) * 100,2) as Avg_Discount
from orders o 
left join "returns" r on r.order_id = o.order_id 
where r.order_id is null

###### Monthly Sales by Segment
select segment, date_part('year',order_date) as year, date_part('month',order_date) as month, round( SUM(sales),2) as SUM
from orders o 
left join "returns" r on r.order_id = o.order_id 
where r.order_id is null
group by segment, year, month
order by segment, year, month

###### Monthly Sales by Product Category
select category, date_part('year',order_date) as year, date_part('month',order_date) as month, round( SUM(sales),2) as SUM
from orders o 
left join "returns" r on r.order_id = o.order_id 
where r.order_id is null
group by category, year, month
order by category, year, month

###### Sales by Product Category over time
select category, date_part('year',order_date) as year, round( SUM(sales),2) as SUM
from orders o 
left join "returns" r on r.order_id = o.order_id 
where r.order_id is null
group by category, year
order by category, year

###### Sales and Profit by Customer
select customer_id, round(SUM(sales)) as sales, round(sum(profit)) as profit
from orders o 
left join "returns" r on r.order_id = o.order_id 
where r.order_id is null
group by customer_id

###### Customer Ranking

###### Sales per region
