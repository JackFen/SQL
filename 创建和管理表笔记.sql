# 第十章_创建和管理表
#1.创建和管理数据库
#1.1如何创建数据库

#方式1：
create database mytest1; #创建的此数据库使用的是默认的字符集

show create database mytest1;

#方式2：显式了指明了要创建的的数据库的字符集
create database mytest2 character set 'gbk';

show create database mytest2;

#方式3：如果要创建的数据库已经存在，则创建不成功，但不会报错
create database if not exists mytest2 character set 'utf8';

#如果要创建的数据库不存在，则创建成功
create database if not exists mytest3 character set 'utf8';

show create database mytest2;

#1.2 管理数据库
#查看当前连接中的数据库都有哪些
show databases;
#切换数据库
use mytest2;
#查看当前数据库中保存的数据表
show tables;
#查看当前使用的数据库
select DATABASE() from dual;
#查看指定数据库下保存的数据表
show tables from mysql;

#1.3 修改数据库
#更改数据库字符集
show create database mytest2;
alter database mytest2 character set'utf8';
#1.4删除数据库
#方式1：
drop database mytest1;
#方式2：推荐。如果要删除的数据库存在，则删除成功。如果不存在，则默默结束，不会报错
drop database if exists mytest1;
#2.如何创建数据表
use atguigudb;
show create database atguigudb;
show tables;
#方式1："白手起家"的方式
create table if not exists myemp1(#需要用户具备创建表的权限
id int,
emp_name varchar(15),#使用varchar来定义字符串,必须再使用varchar时指明其长度
hire_date date
);
#查看表结构
desc myemp1;
show create table myemp1;#如果创建表的时没有指明使用的字符集，则默认使用表所在的数据库的字符集
#查看表数据
select * from myemp1;
#方式2：基于现有的表，同时导入数据
create table myemp2
as
select employee_id,last_name,salary
from employees;

desc myemp2;

desc employees;

select *
from myemp2;

#说明1：查询语句中字段的别名，可以作为新创建的表的字段的名称
#说明2：此时的查询语句可以结构化比较丰富，使用前面章节讲过的各种select
create table myemp3
as
select e.employee_id emp_id,e.last_name lname,d.department_name
from employees e join departments d
on e.department_id=d.department_id;

select *
from myemp3;

desc myemp3;

#练习1：创建一个表employees_copy,实现对employees表的复制，包括表数据
create table employees_copy
as
select *
from employees;

select * from employees_copy;
#练习2：创建一个表employees_blank,实现对employees表的复制，不包括表数据
create table employees_blank
as
select *
from employees
#where department_id>10000;
where 1=2;
select * from employees_blank;

#3.修改表
desc myemp1;
#3.1添加一个字段
alter table myemp1
add salary double(10,2);#一共十位，其中小数占两位。默认添加到表的最后的一个字段的位置

alter table myemp1
add phone_number varchar(20) first;

alter table myemp1
add email varchar(45) after emp_name;
#3.1修改一个字段：数据类型、长度、默认值（略）
alter table myemp1
modify emp_name varchar(35) default 'aaa';

#3.3重命名一个字段
alter table myemp1
change salary mothly_salary double(10,2);

alter table myemp1
change email my_email varchar(50);

#3.4删除一个字段
alter table myemp1
drop column my_email;

#4.重命名表
#方式1：
rename table myemp1
to myemp11;

desc myemp11;

#方式2：
alter table myemp2
rename to myemp12;

desc myemp12;

#5.删除表
#不光将表结构删除掉，同时表中的数据也删除掉，释放表空间
drop table if exists myemp2;

drop table if exists myemp12;
#6.清空表

#清空表，表示清空表中的所有数据，但是表结构保留
select * from employees_copy;
truncate table employees_copy;
select * from employees_copy;
desc employees_copy;

#7.DCL中 commit 和 rollback
#commit:提交数据。一旦执行commit,则数据就被永久的保存在了数据库中，意味着数据不可以回滚
#rollback:回滚数据。一旦执行rollback，则可以实现数据的回滚。混滚到最近的一次commit之后。

#8.对比 truncate和delete from
#相同点：都可以实现对表中所有数据的删除，同时保留表结构
#不同点：
#       truncate table:一旦执行此操作，表数据全部清除。同时，数据是不可以回滚的。
#	delete from:一旦执行此操作，表数据可以全部清除（不带where）。同时，数据是可以实现回滚的

/*
9.DDL和DML的说明
①DDL的操作一旦执行，就不可以回滚。指令 set autocommit=false对DDL操作失效(因为在执行完DDL
 操作之后，一定会执行一次commit。而此commit操作不受set autocommit=false影响)
②DML的操作默认情况，一旦执行，也是不可以回滚的，但是，如果在执行DML之前，执行了
 set autocommit=false,则执行的DML操作就可以实现回滚了
*/
#演示：delete from
commit;

select *
from myemp3;

set autocommit=false;

delete from myemp3;

select *
from myemp3;

rollback;

select *
from myemp3;

#演示：truncate table

commit;

select *
from myemp3;

set autocommit=false;

truncate table myemp3;

select *
from myemp3;

rollback;

select *
from myemp3;

#课后练习

#练习1：
#1.创建数据库text01_office,指明字符集为utf8，并在在数据库下执行下述操作
create database if not exists text01_office character set 'utf8';
use text01_office;

#2. 创建表dept01
/*
字段   类型
id     int(7)
name   varchar(25)
*/
create table if not exists dept01(
id int(7),
`name` varchar(25)
);

#3.将表departments中的数据插入新表dept02中
create table dept02
as
select *
from atguigudb.departments;

#4.创建表emp01
/*
字段         类型
id           int(7)
first_name   varchar(25)
last_name    varchar(25)
dept_id      int(7)
*/

create table emp01(
id int(7),
first_name varchar(25),
last_name varchar(25),
dept_id int(7)
);

#5. 将列last_name的长度增加到50
alter table emp01
modify last_name varchar(50);
#6.根据表employees创建emp02
create table emp02
as
select *
from atguigudb.`employees`;
show tables;
#7.删除表emp01
drop table emp01;

show tables;
#8.将表emp02重命名为emp01
rename table emp02 to emp01;

#9.在表dept02和emp01中添加新列test_column,并检查所作的操作
alter table emp01 add test_column varchar(10);
desc emp01;
alter table dept02 add test_column varchar(10);
desc dept02;
#10.直接删除表emp01中的列department_id
alter table emp01
drop column department_id;

#练习2：
#1.创建数据库test02_market
create database if not exists test02_market character set 'utf8';
use test02_market;

#2.创建数据表customers
create table if not exists customers(
c_num int,
c_name varchar(50),
c_contact varchar(50),
c_city varchar(50),
c_birth date
);
#3.将c_contact 字段移动到c_birth字段后面
alter table customers
modify c_contact varchar(50) after c_birth;
desc customers;
#4.将c_name字段数据类型改为varchar(70)
alter table customers
modify c_name varchar(70);
#5.将c_contact字段改名为c_phone
alter table customers
change c_contact c_phone varchar(50);
#6.增加c_gender字段到c_name后面，数据类型为char(1)
alter table customers
add c_gender CHAR(1) after c_name;
#7.将表名改为customers_info
rename table customers
to customers_info;
#8.删除字段c_city
alter table customers_info
drop column c_city;
#练习3：
#1.创建数据库test03_company
create database if not exists test03_company character set 'utf8';
use test03_company;
#2.创建表offices
create table if not exists offices(
officeCode int,
city varchar(30),
address varchar(50),
country varchar(50),
postalCode varchar(25)
);
desc offices;
#3.创建表employees
create table if not exists employees(
empNum int,
lastName varchar(50),
firstName varchar(50),
mobile varchar(25),
`code` int,
jobTitle varchar(50),
birth date,
note varchar(255),
sex varchar(5)
);
desc employees;
#4.将表employees的mobile字段修改到code字段后面
alter table employees
modify mobile varchar(20) after `code`;
#5.将表employeees的birth字段改名为birthday
alter table employees
change birth birhday date;
desc employees;
#6.修改sex字段，数据类型为char(1)
alter table employees
modify sex CHAR(1);
#7.删除字段note
alter table employees
drop column note;
#8.增加字段名favoriate_activity，数据类型为varchar(100)
alter table employees
add favoriate_activity varchar(100);
#9.将表employees的名称修改为employees_info
rename table employees
to employees_info;
desc employees_info;