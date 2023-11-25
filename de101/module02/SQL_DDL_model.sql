-- создаю схему таблицы и заполняют таблицу данными, просматриваю результат
CREATE TABLE shipping_dim
(
 ship_id   int NOT NULL,
 ship_mode varchar(14) NOT NULL,
 CONSTRAINT PK_Shipping PRIMARY KEY ( ship_id )
);

insert into shipping_dim 
select 100+row_number() over(), ship_mode
from (select distinct ship_mode from orders) a;

select *
from shipping_dim sd;


-- создаю схему таблицы и заполняют таблицу данными, просматриваю результат
CREATE TABLE product_dim
(
 product_id_add int NOT NULL,
 product_id     varchar(15) NOT NULL,
 category       varchar(15) NOT NULL,
 subcategory    varchar(22) NOT NULL,
 segment        varchar(11) NOT NULL,
 product_name   varchar(127) NOT NULL,
 CONSTRAINT PK_product PRIMARY KEY ( product_id_add )
);

insert into product_dim 
select 100+row_number() over(),product_id, category,  subcategory, segment, product_name
from (select distinct product_id, category,  subcategory, segment, product_name 
from orders) a;

select *
from product_dim


-- создаю схему таблицы и заполняют таблицу данными, просматриваю результат
CREATE TABLE geography_dim
(
 geo_id      int NOT NULL,
 country     varchar(13) NOT NULL,
 city        varchar(17) NOT NULL,
 "state"       varchar(20) NOT NULL,
 postal_code int NULL,
 region      varchar(7) NOT NULL,
 CONSTRAINT PK_geography PRIMARY KEY ( geo_id )
);

insert into geography_dim
select 100+row_number () over(order by region, city), country, city,state, postal_code, region
from (select distinct country, city, state, postal_code, region from orders) a

select *
from geography_dim


-- создаю схему таблицы и заполняют таблицу данными, просматриваю результат
CREATE TABLE customer_dim
(
 customer_id   varchar(8) NOT NULL,
 customer_name varchar(22) NOT NULL,
 CONSTRAINT PK_customer PRIMARY KEY ( customer_id )
);

insert into customer_dim
select distinct customer_id, customer_name
from orders

select*
from customer_dim


-- создаю схему таблицы и заполняют таблицу данными, просматриваю результат
CREATE TABLE calendar_dim
(
 year       int NOT NULL,
 quarter    varchar(5) NOT NULL,
 month      int NOT NULL,
 week       int NOT NULL,
 week_day   int NOT NULL,
 order_date date NOT NULL,
 ship_date  date NOT NULL,
 CONSTRAINT PK_calendar PRIMARY KEY ( order_date, ship_date )
);

insert into calendar_dim
select distinct  date_part('year',order_date) as year, date_part ('quarter',order_date) as quarter, date_part('month',order_date) as month,
date_part ('week',order_date) as week, (extract (dow from order_date))+1 as weekday, order_date, ship_date 
 from orders
 
 select *
 from calendar_dim
 

-- создаю схему таблиц
CREATE TABLE sales_fact_dw
(
 row_id         int NOT NULL,
 order_id       varchar(14) NOT NULL,
 sales          numeric(9,4) NOT NULL,
 quantity       int NOT NULL,
 discount       numeric(4,2) NOT NULL,
 profit         numeric(21,16) NOT NULL,
 geo_id         int NOT NULL,
 ship_id        int NOT NULL,
 order_date     date NOT NULL,
 ship_date      date NOT NULL,
 customer_id    varchar(8) NOT NULL,
 product_id_add int NOT NULL,
 CONSTRAINT PK_sales_fact PRIMARY KEY ( row_id ),
 CONSTRAINT FK_5 FOREIGN KEY ( order_date, ship_date ) REFERENCES calendar_dim ( order_date, ship_date ),
 CONSTRAINT FK_3 FOREIGN KEY ( customer_id ) REFERENCES customer_dim ( customer_id ),
 CONSTRAINT FK_4 FOREIGN KEY ( geo_id ) REFERENCES geography_dim ( geo_id ),
 CONSTRAINT FK_5_2 FOREIGN KEY ( product_id_add ) REFERENCES product_dim ( product_id_add ),
 CONSTRAINT FK_5_1 FOREIGN KEY ( ship_id ) REFERENCES shipping_dim ( ship_id )
);

CREATE INDEX FK_calendar ON sales_fact_dw
(
 order_date,
 ship_date
);

CREATE INDEX FK_customer ON sales_fact_dw
(
 customer_id
);

CREATE INDEX FK_geo ON sales_fact_dw
(
 geo_id
);

CREATE INDEX FK_sales_fact_dw ON sales_fact_dw
(
 product_id_add
);

CREATE INDEX FK_shipping ON sales_fact_dw
(
 ship_id
);


/* запрос для заполнения sales_fact*/
insert into sales_fact_dw
select distinct o.row_id, o.order_id, o.sales, o.quantity, o.discount, o.profit, g.geo_id, sd.ship_id, cd.order_date,
cd.ship_date, c.customer_id, pr.product_id_add
from orders o 
inner join geography_dim g on 
o.country = g.country and
o.city = g.city and
o.state = g.state and
o.postal_code = g.postal_code or o.postal_code is null and g.postal_code is null -- дополнительное условие для значений null столбца postal_code
and
o.region = g.region 
inner join shipping_dim sd on o.ship_mode = sd.ship_mode 
inner join calendar_dim cd on o.order_date = cd.order_date and o.ship_date = cd.ship_date
inner join customer_dim c on o.customer_id = c.customer_id
inner join product_dim pr on o.product_name = pr.product_name and 
o.product_id = pr.product_id and
o.category = pr.category and
o.subcategory = pr.subcategory and
o.segment = pr.segment 

--добавление значения postal_code  в таблицу geography и orders
update geography_dim
set postal_code = '05401'
where city = 'Burlington'  and postal_code is null;
update orders
set postal_code = '05401'
where city = 'Burlington'  and postal_code is null;

select *
from sales_fact_dw sf 


-- проверка sales_fact на количество строк
select count(*)
from sales_fact_dw sf 
inner join geography_dim g on 
sf.geo_id = g.geo_id 
inner join shipping_dim sd on sf.ship_id = sd.ship_id
inner join calendar_dim cd on sf.order_date = cd.order_date and sf.ship_date = cd.ship_date
inner join customer_dim c on sf.customer_id = c.customer_id
inner join product_dim pr on sf.product_id_add = pr.product_id_add 
