#05_排序与分页

#1.排序

#1.1基本使用

#如果没有使用排序操作，默认情况下查询返回的数据是按照添加数据的顺序显示的

#使用order by 对查询到的数据进行排序操作
#升序 asc(ascend)
#降序 desc(descend)

#练习：按照salary从高到低的顺序显示员工信息
select employee_id,last_name,salary
from employees
order by salary desc;

#练习：按照salary从低到高的顺序显示员工信息
select employee_id,last_name,salary
from employees
order by salary asc;

select employee_id,last_name,salary
from employees
order by salary;#如果在order by后面没有显式指明排序的方式的话，则默认按照升序排列

#2.我们可以使用列的别名，进行排列
select employee_id,salary,salary*12 annual_sal
from employees
order by annual_sal;

#列的别名只能在order by中使用，不能在where中使用
#如下操作会报错
select employee_id,salary,salary*12 annual_sal
from employees
where annual_sal>8000;

#3.强调格式：where 需要声明在from后，order by之前
select employee_id,salary
from employees
where department_id in(50,60,70)
order by department_id desc;

#4.二级排序

#练习：显示员工信息，按照department_id的降序排列，salary的升序排列
select employee_id,salary,department_id
from employees
order by department_id desc,salary asc;

#2.分页
#2.1 mysql使用limit实现数据的分页显示
#需求1： 每页显示20条记录，此时显示第一页
select employee_id,last_name
from employees
limit 0,20;

#需求2： 每页显示20条记录，此时显示第二页
select employee_id,last_name
from employees
limit 20,20;

#需求3： 每页显示20条记录，此时显示第三页
select employee_id,last_name
from employees
limit 40,20;

#需求：每页显示pageSize条记录，此时显示第pageNo页
#公式：limit(pageNo-1)*pageSize,pageSize;

#2.2where...order...limit...声明顺序如下：

#limit的格式：严格来说：limit 位置偏移量,条目数
#结构"limit 0,条目数"等价于”limit 条目数“
select employee_id,last_name,salary
from employees
where salary>6000
order by salary desc
#limit 0,10;
limt 10;

#练习：表里有107条数据，我们只想要显示第32,33条数据怎么办?
select employee_id,last_name
from employees
limit 31,2;

#2.3 mysql8.0新特性：limit...offset...

#练习：表里有107条数据，我们只想要显示第32,33条数据怎么办?
select employee_id,last_name
from employees
limit 2 offset 31;

#练习：查询员工表中工资最高的员工信息

select employee_id,last_name,salary
from employees
order by salary desc
limit 1;

#课后练习

#1.查询员工的姓名、部门号和年薪，按年薪降序，姓名升序显示
select last_name,department_id,salary*12 annual_sal
from employees
order by annual_sal desc,last_name asc;

#2.选择工资不在8000到17000的员工的姓名和工资，按工资降序，显示第21到第40位置的数据
select last_name,salary
from employees
where salary not between 8000 and 17000
order by salary desc
limit 20,20;
#3.查询邮箱中包含e的员工信息，并先按邮箱的字节数降序，再按部门号升序
select *
from employees
#where email like '%e%'
where email regexp '[e]'
order by LENGTH(email) desc,department_id asc;