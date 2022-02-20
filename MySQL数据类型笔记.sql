#第12章_MySQL数据类型精讲
#关于属性：character set name
#创建数据库时指明字符集
create database if not exists dbtest12 character set 'utf8';
show create database dbtest12;

#创建表的时候，指明表的字符集
create table temp(
id int,
) character set 'utf8';
#创建表的时候，指明表中字段时，可以指定字段的字符集
create table temp1(
id int,
name varchar(15) character set 'gbk'
);
show create table temp1;

#2.整数数据类型
use dbtest12;
create table test_int1(
f1 tinyint,
f2 smallint,
f3 mediumint,
f4 integer,
f5 bigint
);

describe test_int1;

insert into  test_int1(f1)
values(12),(-12),(-128),(127);

select * from test_int1;

create table test_int2(
f1 int,
f2 int(5),#无意义，效果和int一样
f3 int(5) zerofill#①显示宽度为5，当insert的值不足5位时，使用0填充。②当使用zerofull时，自动会添加unsigned
);

insert into test_int2(f1,f2)
values(123,123),(123456,123456);

select * from test_int2;

insert into test_int2(f3)
values(123),(123456);

#3.浮点类型
create table test_double1(
f1 float,
f2 float(5,2),
f3 double,
f4 double(5,2)
);

desc test_double1;

insert into test_double1(f1,f2)
values(123.45,123.45);

select * from test_double1;

insert into test_double1(f3,f4)
values(123.45,123.456);#存在四舍五入

#4.定点数类型
create table test_decimal1(
f1 decimal,
f2 decimal(5,2)
);


describe test_decimal1;

insert into test_decimal1(f1)
values(123),(123.45);

select * from test_decimal1;

insert into test_decimal1(f2)
values(999.99);

insert into test_decimal1(f2)
values(67.567);#存在四舍五入

#Out of range value
insert into test_decimal1(f2)
values(1267.567);

insert into test_decimal1(f2)
values(999.995);

#5.位类型：bit
create table test_bit1(
f1 bit,
f2 bit(5),
f3 bit(64)
);

desc test_bit1;

insert into test_bit1(f1)
values(0),(1);

select * from test_bit1;

#Data too long 
insert into test_bit1(f1)
values(2);

insert into test_bit1(f2)
values(31);
select BIN(f1),BIN(f2),HEX(f1),HEX(f2)
from test_bit1;
#此时+0以后，可以以十进制的方式显示数据
select f1+0,f2+0
from test_bit1;

#6.1year类型
create table test_year(
f1 year,
f2 YEAR(4)
);

desc test_year;

insert into test_year(f1)
values('2021'),(2022);

select * from test_year;

insert into test_year(f1)
values('2155');

#Out of range value for column 'f1' at row 1
insert into test_year(f1)
values('2156');

#6.2date类型

create table test_date1(
f1 date
);

desc test_date1;

insert into test_date1
values('2020-10-01'),('20201001'),(20201001);

insert into test_date1
values('00-01-01'),('000101'),('69-10-01'),('70-01-01'),('700101'),('99-01-01'),('990101');

insert into test_date1
values(000301),(690301),(700301),(990301);#存在隐式转换

select * from test_date1;

#6.3 time类型

create table test_time1(
f1 time
);

desc test_time1;

insert into test_time1
values('2 12:30:29'),('12:40'),('2 12:40'),('1 05'),('45');

insert into test_time1
values('123520'),(124011),(1210);

insert into test_time1
values(NOW()),(current_time);

select * from test_time1;

#6.4 datetime类型

create table test_datetime1(
dt datetime
);

insert into test_datetime1
values('2021-01-01 06:50:30'),('20210101065030');

insert into test_datetime1
values('99-01-01 0:00:00'),('990101000000'),('20-01-01 00:00:00'),('200101000000');

insert into test_datetime1
values(20200101000000),(200101000000),(19990101000000),(990101000000);

insert into test_datetime1
values(CURRENT_TIMESTAMP()),(NOW());

select * from test_datetime1;

#6.5 timestamp数据类型
create table test_timestamp1(
dt datetime
);

insert into test_timestamp1
values('1999-01-01 06:50:30'),('19990101065030');

insert into test_timestamp1
values('2020@01@01@00@00');

insert into test_timestamp1
values(CURRENT_TIMESTAMP()),(NOW());

select * from test_timestamp1;
