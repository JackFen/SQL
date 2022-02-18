# 第11章_数据处理之增删改

#0.储存工作

use atguigudb;

create table if not exists emp1(
id int,
`name` varchar(15),
hire_date date,
salary double(10,2)
);

select *
from emp1;
#1.添加数据

#方式1：一条一条的添加数据

#①
#正确的
insert into emp1
values(1,'Tom','2000-12-21',3400);#注意：一定要按照声明字段的先后顺序添加
#错误的
insert into emp1
values(2,'2000-12-21',3400,'Jerry');

#②指明要添加的字段
insert into emp1(id,hire_date,salary,`name`)
values(2,'1999-09-09',4000,'jerry');

#③
insert into emp1(id,`name`,salary)
values
(3,'Jim',5000),
(4,'danny',5500);
#方式2：将查询结果插入到表中

select *
from emp1;

insert into emp1(id,`name`,salary,hire_date)
#查询语句
select employee_id,last_name,salary,hire_date#查询的字段一定要与添加到表的字段一一对应
from employees
where department_id in(70,60);

#说明：emp1表中要添加数据的字段的长度不能低于employees表中查询的字段的长度
#如果emp1表中要添加数据的字段的长度低于employees表中查询字段的长度的话，就有添加不成功的风险

#2.更新数据（或修改数据）
#update...set...where...
#可以实现批量修改数据
update emp1
set hire_date=CURDATE()
where id=4;

select *
from emp1;

#同时修改一条数据的多个字段
update emp1
set hire_date=CURDATE(),salary=6000
where id=3;

#题目：将表中姓名中包含字母a的提薪20%
update emp1
set salary=salary*1.2
where `name` like '%a%';

#修改数据时，是可能存在不成功的情况的。（可能是由于约束造成的）
update employees
set department_id=10000
where employee_id=102;

#3.删除数据 delete from...where...
delete from emp1
where id=1;
#在删除数据时，也有可能因为约束的影响，导致删除失败
#小结：DML操作默认情况下，执行完以后都会自动提交数据。
#如果希望执行完以后不自动提交数据，则需要使用set autocommit=false。

#MySQL8的新特性：计算列
use atguigudb;

create table test1(
a int,
b int,
c int generated always as(a+b) virtual
);

insert into test1(a,b)
values(10,20);

select * from test1;

update test1
set a=100;
#5.综合案例
#1.创建数据库test01_library
create database test01_library character set 'utf8';
use test01_library;
#2.创建表books,
create table if not exists books(
id int,
`name` varchar(50),
authors varchar(100),
price float,
pubdate year,
note varchar(100),
num int
);
select * from books;
#3.向books表插入记录

#1）不指明字段名称，插入第一条记录
insert into books
values(1,'Tal of AAA','Dickes',23,'1995','novel',11);
#2）指明所有字段名称，插入第二条记录
insert into books(id,name,authors,price,pubdate,note,num)
values(2,'EmmaT','Jane lura',35,'1993','joke',22);
#3）同时插入多条记录（剩下的所有记录）
insert into books(id,name,authors,price,pubdate,note,num)
values
(3,'Story of Jane','Jane Tim',40,'2001','novel',0),
(4,'Lovely Day','George Blade',30,'2005','novel',0),
(5,'Old land','Honere Blade',30,'2010','law',0),
(6,'The Battle','Upton Sara',30,'1999','medicine',40),
(7,'Pose Hood','Richard haggard',28,'2008','cartoon',28);
#4.将小说类型(novel)的书的价格都增加5
update books
set price=price+5
where note='novel';
#5.将名称为EmmaT的书的价格改为40，并将说明改为drama
update books
set price=40,note='drama'
where name='EmmaT';
#6.删除库存为0的记录
delete from books
where num=0;
#7.统计书名中包含a字母的书
select name
from books
where name like '%a%';

#8.统计书名中包含a字母的书的数量和库存总量
select COUNT(*),SUM(num)
from books
where name like '%a%';

#9.找出'novel'类型的书，按照价格降序排列

select name,note,price
from books
where note='novel'
order by price desc;

#10.查询图书信息，按照库存量降序排列，如果库存量相同的按照note升序排列
select *
from books
order by num desc,note asc;
#11.按照note分类统计书的数量
select note,COUNT(*)
from books
group by note;
#12.按照note分类统计书的库存量，显示库存量超过30本的
select note,SUM(num)
from books
group by note
having SUM(num)>30;
#13.查询所有图书，每页显示5本，显示第二页
select *
from books
limit 5,5;
#14.按照note分类统计书的库存量，显示库存量最多的
select note,SUM(num) sum_num
from books
group by note
order by sum_num desc
limit 0,1;
#15.查询书名达到10个字符的书，不包括里面的空格
select name
from books
where CHAR_LENGTH(REPLACE(name,' ',''))>=10;
#16.查询书名和类型，其中note值为novel显示小说，law显示法律，medicine显示医药，cartoon显示卡通
select name "书名",note,case note when 'novel' then '小说'
				  when 'law' then '法律'
				  when 'medicine' then '医药'
				  when 'cartoon' then '卡通'
				  when 'joke' then '笑话'
				  else '其它'
				  end "类型"
from books;
#17.查询书名，库存，其中num值超过30本的，显示滞销，大于0并且低于10的，显示畅销，为0的显示需要无货
select name as "书名",num as "库存",case when num>30 then '滞销'
					 when num>0 and num<10 then '畅销'
					 when num=0 then '无货'
					 else '正常'
					 end "显示状态"
from books;

#18.统计每一种note的库存量，并合计总量
select IFNULL(note,'合计库存总量')as note,SUM(num)
from books
group by note with rollup;
#19.统计每一种note的数量，并合计总量
select IFNULL(note,'合计库存总量')as note,COUNT(num)
from books
group by note with rollup;
#20.统计库存量前三名的图书
select *
from books
order by num desc
limit 0,3;
#21.找出最早出版的一本书
select *
from books
order by pubdate asc
limit 0,1;
#22.找出novel中价格最高的一本书
select *
from books
where note ='novel'
order by price desc
limit 0,1;
#23.找出书名字数最多的一本书，不含空格
select *
from books
order by CHAR_LENGTH(REPLACE(name,' ','')) desc
limit 0,1;

#课后练习
#练习1：

#1.创建数据库detest11
create database if not exists dbtest11 character set 'utf8';
#运行一下脚本创建表my_employees
use dbtest11;
create table my_employees(
id int(10),
first_name varchar(10),
last_name varchar(10),
userid varchar(10),
salary double(10,2)
);
create table users(
id int,
userid varchar(10),
department_id int
);
#3.显示表my_employees的结构
desc my_employees;
#4.向my_employees表中插入下列数据
insert into my_employees
values(1,'patel','Palth','Rpatel',895);

insert into my_employees
values
(2,'Dancs','Betty','Bdancs',860),
(3,'Biri','Ben','Bbiri',1100),
(4,'Newman','Chad','Cnewman',750),
(5,'Ropeburn','Audrey','Aropebur',1550);

#5.向users表中插入数据
insert into users
values
(1,'Rpatel',10),
(2,'Bdancs',10),
(3,'Bbiri',20),
(4,'Cnewman',30),
(5,'Aropebur',40);


select * from users;
#6.将3号员工的last_name修改为 drelxer
update my_employees
set last_name='drelxer'
where id=3;
#7.将所有工资少于900的员工的工作修改为1000
update my_employees
set salary=1000
where salary<900;
#8.将userid为Bbiri的user表和my_employees表的记录全部删除
#方式1：
delete from my_employees
where userid='Bbiri';
delete from users
where userid='Bbiri';
#方式2：
delete m,u
from my_employees m
join users u
on m.userid=u.userid
where m.`userid`='Bbiri';
#9.删除my_employees、users表所有数据
delete from my_employees;
delete from users;
#10.检查所有修正
select * from my_employees;
select * from users;
#11.清空表my_employees
truncate table my_employees;

#练习2：

#1.使用现有的数据库detest11
use dbtest11;
#2.创建表格pet
create table pet(
name varchar(20),
owner varchar(20),
species varchar(20),
sex CHAR(1),
birth year,
death year
);
#3.添加记录
insert into pet
values
('Fluffy','harold','Cat','f','2003','2010'),
('Claws','gwen','Cat','m','2004',null),
('Buffy',null,'Dog','f','2009',null),
('Fang','benny','Dog','m','2000',null),
('bowser','diane','Dog','m','2003','2009'),
('Chirpy',null,'Bird','f','2008',null);

select * from pet;
#4.添加字段：主人的生日owner_birth date类型
alter table pet
add owner_birth date;
#5.将名称为Claws的猫的主人改为kevin
update pet
set owner='kevin'
where name='Claws' and species='Cat';
#6.将没有死的狗的主人改为duck
update pet
set owner='duck'
where death is null and species='Dog';

#7.查询没有主人的宠物的名字；
select name
from pet
where owner is null;
#8.查询已经死了的cat的姓名，主人，已经去世时间
select name,owner,death
from pet
where death is not null;
#9.删除已经死亡的狗
delete from pet
where death is not null
and species='Dog';

#练习3：
#1.使用已有的数据库dbtest11
use dbtest11;
#2.创建表employee,并添加记录
create table employee(
id int,
name varchar(15),
sex CHAR(1),
tel varchar(25),
addr varchar(35),
salary double(10,2)
);
insert into employee values
(10001,'张一一','男','13456789000','山东青岛',1001.58),
(10002,'刘小红','女','13454319000','河北保定',1202.21),
(10003,'李四','男','0751-1234567','广东佛山',1004.11),
(10004,'刘小强','男','0755-555555','广东深圳',1501.23),
(100005,'王艳','男','020-1232133','广东广州',1405.16);
select * from employee;
#3.查询出薪资在1200~1300之间的员工信息
select *
from employee
where salary between 1200 and 1300;
#4.查询出姓刘的员工的工号，姓名，家庭住址
select id,name,addr
from employee
where name like '刘%';
#5.将李四的家庭住址改为广东韶关
update employee
set addr='广东韶关'
where name='李四';
#6.查询出名字中带小的员工
select *
from employee
where name like '%小%';