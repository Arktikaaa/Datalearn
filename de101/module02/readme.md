### **Модуль 2 - Домашняя работа** :smile:
--------------------------------------------
#### **2.2 Что такое базы данных и как они помогают при работе с данными**
--------------------------------------------
1. Установить базу данных к себе на компьютер.    
> Установлена база данных Postgres. 

#### **2.3 Подключение к Базам Данных и SQL**
-----------------------------------------
1. Установить клиента SQL для подключения базы данных.  
> Установлен DBeaver.
2. Создание 3х таблиц и загрузка данных из Superstore Excel файл в локальную базу данных.  
> Таблицы созданы и заполнены данными, скрипты  сохранены на GitHub ([orders](https://github.com/Arktikaaa/Datalearn/blob/main/de101/module02/orders.sql), [people](https://github.com/Arktikaaa/Datalearn/blob/main/de101/module02/people.sql), [returns](https://github.com/Arktikaaa/Datalearn/blob/main/de101/module02/returns.sql)).
3. Написание запросов в соответсвии с задачими [Модуля 01](https://github.com/Data-Learn/data-engineering/tree/master/DE-101%20Modules/Module01/DE%20-%20101%20Lab%201.1#%D0%B0%D0%BD%D0%B0%D0%BB%D0%B8%D1%82%D0%B8%D0%BA%D0%B0-%D0%B2-excel), сохранение запросов на GitHub.
> Ниже написаны запросы в соответсвии с задачами Модля 01.
###### Total Sales
```sql
select sum(sales) as Total_Sales
from orders o 
left join "returns" r on r.order_id = o.order_id 
where r.order_id is null;
```

###### Total Profit
```sql
select sum(profit) as Total_Profit
from orders o 
left join "returns" r on r.order_id = o.order_id 
where r.order_id is null;
```

###### Profit per Order
```sql
select o.order_id, SUM(profit)
from orders o 
left join "returns" r on r.order_id = o.order_id 
where r.order_id is null
group by o.order_id;
```

###### Sales per Customer 
```sql
select customer_id, SUM(sales)
from orders o 
left join "returns" r on r.order_id = o.order_id 
where r.order_id is null
group by customer_id;
```

###### Avg_Discount
```sql
select round(AVG(discount) * 100,2) as Avg_Discount
from orders o 
left join "returns" r on r.order_id = o.order_id 
where r.order_id is null
```

###### Monthly Sales by Segment
```sql
select segment, date_part('year',order_date) as year, date_part('month',order_date) as month, round( SUM(sales),2) as SUM
from orders o 
left join "returns" r on r.order_id = o.order_id 
where r.order_id is null
group by segment, year, month
order by segment, year, month;
```

###### Monthly Sales by Product Category
```sql
select category, date_part('year',order_date) as year, date_part('month',order_date) as month, round( SUM(sales),2) as SUM
from orders o 
left join "returns" r on r.order_id = o.order_id 
where r.order_id is null
group by category, year, month
order by category, year, month;
```

###### Sales by Product Category over time
```sql
select category, date_part('year',order_date) as year, round( SUM(sales),2) as SUM
from orders o 
left join "returns" r on r.order_id = o.order_id 
where r.order_id is null
group by category, year
order by category, year;
```

###### Sales and Profit by Customer
```sql
select customer_id, round(SUM(sales)) as sales, round(sum(profit)) as profit
from orders o 
left join "returns" r on r.order_id = o.order_id 
where r.order_id is null
group by customer_id;
```

###### Sales per region
```sql
select region, round(SUM(sales)) as sales
from orders o 
left join "returns" r on r.order_id = o.order_id 
where r.order_id is null
group by region;
```

###### Customer Ranking


#### **2.4 Модели Данных**
1. Необходимо нарисовать модель данных для файла Superstore: концептуальную, логическую, физическую
Концептуальная модель
![alt-текст]( https://github.com/Arktikaaa/Datalearn/blob/main/de101/module02/%D0%9A%D0%BE%D0%BD%D1%86%D0%B5%D0%BF%D1%82%D1%83%D0%B0%D0%BB%D1%8C%D0%BD%D0%B0%D1%8F%20%D0%BC%D0%BE%D0%B4%D0%B5%D0%BB%D1%8C%20Superstore.PNG "Концептуальная модель")

Логическая модель
![alt-текст]( https://github.com/Arktikaaa/Datalearn/blob/main/de101/module02/%D0%9B%D0%BE%D0%B3%D0%B8%D1%87%D0%B5%D1%81%D0%BA%D0%B0%D1%8F%20%D0%BC%D0%BE%D0%B4%D0%B5%D0%BB%D1%8C%20Superstore.PNG "Логическая модель")

Физическая модель
![alt-текст](https://github.com/Arktikaaa/Datalearn/blob/main/de101/module02/%D0%A4%D0%B8%D0%B7%D0%B8%D1%87%D0%B5%D1%81%D0%BA%D0%B0%D1%8F%20%D0%BC%D0%BE%D0%B4%D0%B5%D0%BB%D1%8C%20Superstore.PNG "Физическая модель")

2. Необходимо написать запросы на создание и наполнение таблиц Dimensions и таблицы Sales Fact.
>Запросы созданы ([запросы DDL+INSERT](https://github.com/Arktikaaa/Datalearn/blob/main/de101/module02/SQL_DDL_model.sql)).





Практика

    Вам необходимо создать учетную запись в AWS. Это бесплатно. Если вы запускаете сервис в AWS, не забудьте его удалить, когда он не нужен, а то могут и денюшку списать.
    Используя сервис AWS Lightsail или AWS RDS (смотрите инструкцию) создайте БД Postgres и активируйте Public access
    Подключитесь к новой БД через SQL клиент (например DBeaver)
    Загрузите данные из модуля 2.3 (Superstore dataset) в staging (схема БД stg) и загрузите dimensional model (схема dw). Вы можете использовать мой пример SQL для этого упражнения:

    Staging stg.orders.sql
    Business Layer from_stg_to_dw.sql

    Попробуйте выполнить свои запросы из предыдущих упражнений. Не забудьте указать схему перед название таблицы. Например, public.orders или stg.orders.
