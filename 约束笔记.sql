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