

----------------------------------------------------------------------------------


#創db

Create database exercise;

#創表格

CREATE TABLE `exercise`.`food` (
  `id` CHAR(5) NOT NULL,
  `name` VARCHAR(30) NULL,
  `expiredate` DATETIME NULL,
  `placeid` CHAR(2) NULL,
  `price` INT UNSIGNED NULL,
  `catalog` VARCHAR(20) NULL,
  PRIMARY KEY (`id`));


CREATE TABLE `exercise`.`place` (
  `placeid` CHAR(2) NOT NULL,
  `pname` VARCHAR(20) NULL,
  PRIMARY KEY (`placeid`));
  
  
  CREATE TABLE `exercise`.`food1` (
  `id` CHAR(5) NOT NULL,
  `name` VARCHAR(30) NULL,
  `placeid` CHAR(2) NULL,
  `flat_price` INT UNSIGNED NULL,
  `category` VARCHAR(20) NULL,
  `flavor` VARCHAR(10) NULL,
  PRIMARY KEY (`id`));

use exercise;



---------------------------------------------------------------------------------

##  收資料


INSERT INTO food VALUES ('CK001', '曲奇餅乾', '2018/01/10', 'TL', 250, '點心');
INSERT INTO food VALUES ('CK002', '蘇打餅乾', '2017/10/12', 'TW', 80, '點心');
INSERT INTO food VALUES ('DK001', '高山茶', '2018/05/23', 'TW', 780, '飲料');
INSERT INTO food VALUES ('DK002', '綠茶', '2017/06/11', 'JP', 530, '飲料');
INSERT INTO food VALUES ('OL001', '苦茶油', '2019/03/16', 'TW', 360, '調味品');
INSERT INTO food VALUES ('OL002', '橄欖油', '2018/07/25', 'TL', 420, '調味品');
INSERT INTO food VALUES ('CK003', '仙貝', '2017/11/01', 'JP', 270, '點心');
INSERT INTO food VALUES ('SG001', '醬油', '2019/05/05', 'JP', 260, '調味品');
INSERT INTO food VALUES ('OL003', '葡萄子油', '2019/05/05', 'JP', 550, '調味品');
INSERT INTO food VALUES ('CK004', '鳳梨酥', '2017/10/12', 'TW', 340, '點心');
INSERT INTO food VALUES ('CK005', '太陽餅', '2017/08/27', 'TW', 150, '點心');
INSERT INTO food VALUES ('DK003', '紅茶', '2019/11/12', 'TL', 260, '飲料');
INSERT INTO food VALUES ('SG002', '醋', '2018/09/18', 'TW', 60, '調味品');

INSERT INTO place VALUES ('TW', '台灣');
INSERT INTO place VALUES ('JP', '日本');
INSERT INTO place VALUES ('TL', '泰國');
INSERT INTO place VALUES ('US', '美國');


# Query查詢

Select*from exercise.food;
Select name, expiredate, price from food;
Select name '名稱', expiredate '到期日', price '價格' from food;
select distinct catalog from food;
select name, catalog, concat(name,"  ",catalog) 'Food name & catalog' from food;


# Where條件設定

Select name, price from food where price > 400;
Select name, price from food where price between 250 and 530;
Select name, price from food where price not between 250 and 530;
Select name, price, catalog from food where catalog = '點心';
Select name, price, catalog from food where catalog = '點心' or catalog = '飲料';
Select name, price, placeid from food where placeid = 'TW' or placeid = 'JP';
Select name, price, expiredate from food where name like '%油%';
Select name, price, expiredate from food where expiredate < '2018/12/31';
Select name, price, expiredate from food where expiredate < '2019/06/30';
Select name, price, expiredate from food where expiredate between '2018/01/01' and '2018/06/30';


# Order by

Select name, expiredate, price from food order by price desc;
Select name, expiredate, price from food order by price desc limit 3;
Select name, price, catalog from food where catalog = '點心' and  price <= 250 order by price;
Select name, price, round(price*(1+0.05)) as 'New price' from food;
Select name, price, round(price*(1+0.05))-price as 'Increase' from food;

Select name, price, round(price*(1+0.05)) 'New price', 
case 
when price*(1+0.05) <= 250 then floor(price*(1+0.05)*(1+0.08)) 
when price*(1+0.05) between 251 and 500 then floor(price*(1+0.05)*(1+0.05)) 
when price*(1+0.05) >= 501 then floor(price*(1+0.05)*(1+0.03)) 
end from food;


Select name, catalog, Datediff(expiredate, curdate()) as 'expired or not', 
Datediff(curdate(), expiredate) as 'Days of expired' from food;

Select name, catalog, Datediff(expiredate, curdate()) as 'Days of expired' from food order by 'Days of expired' desc;




# Group by & Having 分組查詢

Select round(max(price)) Max from food ;
Select round(min(price)) Min from food ;
Select round(sum(price)) Sum from food ;
Select round(avg(price)) Avg from food ;

Select catalog, round(max(price)) Max from food group by catalog;
Select catalog, round(min(price)) Min from food group by catalog;
Select catalog, round(sum(price)) Sum from food group by catalog;
Select catalog, round(avg(price)) Avg from food group by catalog;

Select catalog, round(avg(price)) Avg from food group by catalog
having round(avg(price)) > 300 
order by round(avg(price)) desc;

Select catalog, placeid, count(*) from food group by catalog, placeid;


----------------------------------------------------------------------------------


# 資料合併join

Select name, pname, price from food inner join place on food.placeid = place.placeid;

Select name, pname, concat(name,"  ",pname) 'Food name & pname' from food inner join place 
on food.placeid = place.placeid;

Select name, pname, price from food inner join place on food.placeid = place.placeid where pname= '台灣';

Select name, pname, price from food inner join place on food.placeid = place.placeid 
where pname= '台灣' or pname= '日本' order by price desc;

Select name, pname, expiredate, price from food inner join place on food.placeid = place.placeid 
where pname= '台灣' order by price desc limit 3;

Select round(max(price)) Max, round(min(price)) Min, round(sum(price)) Sum, round(avg(price)) Avg, 
pname from food inner join place on food.placeid = place.placeid 
group by pname;

Select count(*), pname, catalog from food inner join place on food.placeid = place.placeid 
group by pname, catalog;


----------------------------------------------------------------------------------


#  subquery


SELECT name, expiredate, price from food
where price > (select price from food where name = '鳳梨酥'); 

SELECT name, expiredate, price, catalog from food
where price < (select price from food where name = '曲奇餅乾')
and catalog = '點心';

SELECT name, expiredate, price from food
where Year(expiredate) = (select Year(expiredate) from food where name = '鳳梨酥');

SELECT name, expiredate, price from food 
where price >  (SELECT avg(price) from food);

SELECT name, expiredate, price, pname from food inner join place on food.placeid = place.placeid
where pname = '台灣' and price < (SELECT avg(price) from food);

SELECT name, expiredate, price, catalog from food
where catalog = (select catalog from food where name = '仙貝')
and price < (select price from food where name = '仙貝');


7.	查詢所有產地和'仙貝'相同且到期日超過6個月以上的食物名稱、日期日和價格

SELECT name, expiredate, price, pname from food inner join place on food.placeid = place.placeid
where pname in (SELECT pname from place where name = '仙貝')
and where DATEDIFF(expiredate, CURDATE())%30 > 6; 

SELECT name, expiredate, price, placeid from food 
where (price, placeid) in (SELECT min(price), placeid from food group by placeid);

SELECT name, price, catalog from food 
where price in (SELECT max(price) from food group by catalog);

SELECT name, price, catalog from food
where price >ALL (SELECT price from food where catalog = '點心') 
order by price desc;

SELECT name, expiredate, price, pname from food inner join place on food.placeid = place.placeid
where (price, pname) in
(SELECT max(price), pname from food, place where food.placeid = place.placeid group by pname);


------------------------------------------------------------------------------------


#  DML


INSERT INTO food VALUES ('UK001', '可口餅乾', '2018/11/25', 'UK', 400, '點心');

INSERT INTO food (id, name, expiredate, placeid, price, catalog) 
VALUES ('FH001', '法式麵包', '2017/10/20', 'FH', 550, '開胃');

INSERT INTO place VALUES ('UK', '英國');

Update food set price = 450 where id = 'UK001';

Select name, price, round(price*(1+0.05)) 'New price', 
case 
when price <= 250 then ceiling(price*(1+0.08)) 
when price between 251 and 500 then ceiling(price*(1+0.05)) 
when price >= 501 then ceiling(price*(1+0.03)) 
end from food;

Delete from food where id = 'FH001';


-----------------------------------------------------------------------------------


#  View表格


create view food_vw as 
SELECT id, name, expiredate, pname, price from food inner join place on food.placeid = place.placeid;
SELECT*From food_vw;

create view place_vw as
Select max(price), min(price), avg(price), pname from food inner join place on food.placeid = place.placeid group by pname;
SELECT*From place_vw;

create view food_dessert_vw as
SELECT id, name, expiredate, price, catalog, pname from food inner join place on food.placeid = place.placeid where catalog = '點心';
SELECT*From food_dessert_vw;

set SQL_SAFE_UPDATES = 0;
update food_dessert_vw set price = 100 where name = '太陽餅';
SELECT*From food;


-----------------------------------------------------------------------------------

SELECT Year(expiredate) in (2017,2018) from food;



