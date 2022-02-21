#第13章_约束

/*
1.3 约束的分类：

角度1：约束的字段个数
单列约束vs多列约束

角度2：约束的作用范围

列级约束：将此约束声明在对应字段的后面
表级约束：在表中所有字段都声明完，在所有字段的后面声明的约束

角度3：约束的作用（或功能）

①not null(非空约束)
②unique(唯一性约束)
③primary key(主键约束)
④foreign key(外键约束)
⑤check(检查约束)
⑥default(默认值约束)

1.4 添加\删除约束

create table时添加约束

alter table时增加约束、删除约束
*/

#2.如何查看表中的约束
select * from information_schema.`TABLE_CONSTRAINTS`
where table_name='employees';

#3.not null(非空约束)
#3.1 在create table时添加约束

create database dbtest13;
use dbtest13;

create table test1(
id int not null,
last_name varchar(15) not null,
email varchar(25),
salary decimal(10,2)
);

desc test1;

insert into test1(id,last_name,email,salary)
values(1,'Tom','tom@126.com',3400);

#错误:Column 'id' cannot be null
insert into test1(id,last_name,email,salary)
values(null,'Tom','tom@126.com',3400);

#错误：Column 'last_name' cannot be null
insert into test1(id,last_name,email,salary)
values(1,null,'tom@126.com',3400);

#错误：Field 'last_name' doesn't have a default value
insert into test1(id,email)
values(2,'abc@126.com');

update test1
set last_name=null
where id=1;

#3.2 在alter table时添加约束

alter table test1
modify email varchar(25) not null;

#3.3 在alter table时删除约束
alter table test1
modify email varchar(25) null;

#4.unique（唯一性约束）

#4.1在create table时添加约束
create table test2(
id int unique,#列级约束
last_name varchar(15),
email varchar(25),
salary decimal(10,2),

#表级约束

constraint uk_test2_email unique(email)
);

desc test2;

#在创建唯一性约束的时候，如果不给唯一约束命名，就默认和列名相同。


insert into test2(id,last_name,email,salary)
values(1,'Tom','tom@126.com',4600);

#可以向声明为unique的字段上添加null值。而且可以多次添加null值
insert into test2(id,last_name,email,salary)
values(2,'Tom',null,4600);

select * from test2;

#4.2 在alter table时添加约束

update test2
set salary=5000
where id=2;
#方式1：
alter table test2
add constraint uk_test2_sal unique(salary);
#方式2：
alter table test2
modify last_name varchar(15) unique;

#4.3 复合的唯一性约束

create table USER(
id int,
`name` varchar(15),
`password` varchar(25),

#表级约束
constraint uk_user_name_pwd unique(`name`,`password`)
);
insert into user
values(1,'Tom','abc');
insert into user
values(1,'Tom1','abc');

select * from user;

#案例：复合的唯一性约束的案例
#学生表
create table student(
sid int,#学号
sname varchar(20),#姓名
tel CHAR(11) unique key,#电话
cardid CHAR(18) unique key#身份证号
);
#课程表
create table course(
cid int,#课程编号
cname varchar(20)#课程名称
);
#选课表
create table student_course(
id int,
sid int,#学号
cid int,#课程编号
score int,
unique key(sid,cid)#复合唯一
);
insert into student 
values
(1,'张三','13710011002','101223199012015623'),
(2,'李四','13710011003','101223199012015624');
insert into course
values
(1001,'java'),
(1002,'MySQL');
select * from student;
select * from course;

insert into student_course
values
(1,1,1001,89),
(2,1,1002,90),
(3,2,1001,88),
(4,2,1002,56);

select * from student_course;

#4.4 删除唯一性约束
/*
--添加唯一性约束的列会自动创建唯一索引。
--删除唯一约束只能通过删除唯一索引的方式删除
--删除时需要指定唯一索引名，唯一索引名就和唯一约束名一样
--如果创建唯一约束时未指定名称，如果是单列，就默认和列名相同；
--如果是组合列，那么默认和（）中排在第一个的列名相同，也可以自定义唯一性约束名。
*/
select * from information_schema.`TABLE_CONSTRAINTS`
where table_name='student_course';

select * from information_schema.`TABLE_CONSTRAINTS`
where table_name='test2';
#如何删除唯一性索引
alter table test2
drop index uk_test2_sal;

#5.primary key(主键约束)
#5.1在create table时添加约束

#一个表中最多只能有一个主键约束。

#错误：Multiple primary key defined
create table test3(
id int primary key,#列级约束
last_name varchar(25) primary key,
salary decimal(10,2),
email varchar(25)
);

#主键约束特征：非空且唯一，用于唯一的标识表中的一条记录。
create table test4(
id int primary key,#列级约束
last_name varchar(25),
salary decimal(10,2),
email varchar(25)
);

#MySQL的主键名总是primary,就算自己命名了主键约束名也没用。
create table test5(
id int,#列级约束
last_name varchar(25),
salary decimal(10,2),
email varchar(25),
#表级约束
constraint pk_test5_id primary key(id)#没必要起名字
);

select * from information_schema.table_constraints
where table_name='test5';

insert into test5(id,last_name,salary,email)
values(1,'Tom',4500,'tom@126.com');

#Duplicate entry '1' for key 'test5.PRIMARY'
insert into test5(id,last_name,salary,email)
values(1,'Tom',4500,'tom@126.com');

#Column 'id' cannot be null
insert into test5(id,last_name,salary,email)
values(null,'Tom',4500,'tom@126.com');

select * from test5;

create table user1(
id int,
name varchar(15),
password varchar(25),

primary key(name,password)
);
#如果时多列组合的复合主键约束，那么这些列都不允许为空值，并且组合的值不允许重复
insert into user1
values(1,'Tom','abc');

insert into user1
values(1,'Tom1','abc');

#错误：Column 'name' cannot be null
insert into user1
values(1,null,'abc');
select * from user1;

#4.2在alter table时添加约束
create table test6(
id int,
last_name varchar(25),
salary decimal(10,2),
email varchar(25)
);

desc test6;
alter table test6
add primary key(id);

#4.3 如何删除主键约束(在实际开发中根本不会去删除主键约束！)
alter table test6
drop primary key;

#6.1自增长列： AUTO_INCREMENT
#6.1在create table时添加
create table test7(
id int primary key auto_increment,
last_name varchar(25)
);
#开发中，一旦主键作用的字段上声明有auto_increment,则我们在添加数据时就不会给主键对应的字段去赋值了
insert into test7(last_name)
values('Tom');

select * from test7;

insert into test7(last_name)
values('Tom');

#当我们向主键（含auto_increment）的字段上添加0或者null时，实际上会自动的往上添加指定的字段的数值
insert into test7(id,last_name)
values(0,'Tom');

insert into test7(id,last_name)
values(null,'Tom');

insert into test7(id,last_name)
values(10,'Tom');

insert into test7(id,last_name)
values(-10,'Tom');

#6.1在alter table时添加
create table test8(
id int primary key,
last_name varchar(25)
);

alter table test8
modify id int auto_increment;

#6.3在alter table时删除

alter table test8
modify id int;

#6.4MySQL8.0新特性-自增变量的持久化

#8.check约束
#MySQL5.7不支持check约束，MySQL8.0支持check约束
create table test10(
id int,
last_name varchar(10),
salary decimal(10,2) check(salary>2000)
);

insert into test10
values(1,'Tom',2500);
#添加失败
insert into test10
values(1,'Tom',1500);

#9.default约束
create table test11(
id int,
last_name varchar(15),
salary decimal(10,2) default 2000
);

desc test11;

insert into test11(id,last_name,salary)
values(1,'Tom',3000);

insert into test11(id,last_name)
values(1,'Tom1');

select * from test11;

#9.2 在alter table时添加约束
create table test12(
id int,
last_name varchar(15),
salary decimal(10,2)
);

desc test12;

alter table test12
modify salary decimal(8,2) default 2500;

#9.3 在alter table时删除约束

alter table test12
modify salary decimal(8,2);

#课后练习

#练习1：
create database test04_emp;
use test04_emp;
create table emp2(
id int,
emp_name varchar(15)
);

create table dept2(
id int,
dept_name varchar(15)
);

#1.向表emp2的id列中添加primary key约束
alter table emp2
add constraint pk_emp2_id primary key(id);

#2.向表dept2的id列中添加primary key约束
alter table dept2
add primary key(id);

#向表emp2中添加dept_id，并在其中定义foreign key约束，与之相关的列是dept2表中的id列

alter table emp2
add dept_id int;

desc emp2;

alter table emp2
add constraint fk_emp2_deptid foreign key(dept_id) references dept2(id);

#练习2：

use test01_library;

desc books;

#根据题目要求给books表中的字段添加约束
#方式1：
alter table books
add primary key(id);

alter table books
modify id int auto_increment;
#方式2：
alter table books
modify id int primary key auto_increment;

#针对于非di字段的操作
alter table books
modify name varchar(50) not null;

alter table books
modify authors varchar(100) not null;

alter table books
modify price float not null;

alter table books
modify pubdate year not null;

alter table books
modify num int not null;

#练习3：
#1.创建数据库test04_company
create database if not exists test04_company character set 'utf8';

use test04_company;
#2.按照下表给出的表结构在test04_company数据库中创建两个数据表offices和employees
create table if not exists offices(
officeCode int(10) primary key,
city varchar(50) not null,
address varchar(50),
country varchar(50)not null,
postalCode varchar(15),
constraint uk_off_poscode unique(postalCode)
);

desc offices;
create table employees(
employeeNumber int primary key auto_increment,
lastName varchar(50) not null,
firstName varchar(25) unique,
mobile varchar(25) unique,
officeCode int(10) not null,
jobTitle varchar(50) not null,
birth datetime not null,
note varchar(255),
sex varchar(5),
constraint fk_emp_offcode foreign key(officeCode) references offices(officeCode)
);

desc employees;

#3.将表employees的mobile字段修改到officeCode 字段后面
alter table employees
modify mobile varchar(25) after officeCode;
#4.将表employees的birth字段改名为employee_birth
alter table employees
change birth employee_birth datetime;
#5.修改sex字段，数据类型为char(1)，非空约束
alter table employees
modify sex CHAR(1) not null;

#6.删除字段note
alter table employees
drop column note;

#7.增加字段名favoriate_activity,数据类型为varchar(100)
alter table employees
add favoriate_activity varchar(100);

#8.将表employees名称修改为employees_info
rename table employees
to employees_info;
#错误：Table 'test04_company.employees' doesn't exist
desc employees;
#正确
desc employees_info;