select * from employees;
select employee_id,last_name,salary
from employees;
select employee_id emp_id,last_name AS lname,department_id "部门id" from
employees; 
select distinct department_id from
employees;
select employee_id,salary "月工资",salary*(1+IFNULL(commission_pct,0))*12 "年工资"
from employees;
select * from `order`;
select "jack", employee_id,department_id 
from employees;
describe employees;
#12.过滤数据
#练习：查询90号部门的员工信息
select * 
from employees
#过滤条件，声明在FROM结构的后面
where department_id=90;
#练习：查询last_name为'King'的员工信息
select *
from employees
where last_name='King';
#03章_基本的select语句的课后练习
#1.查询员工12个月的工资总和，并起别名为ANNUAL SALARY
select employee_id,last_name,salary*(1+IFNULL(commission_pct,0))*12 "ANNUAL SALARY"
from employees;
#2.查询employees表中去除重复的job_id以后的数据
select distinct job_id
from employees;
#3.查询工资大于12000的员工姓名和工资
select last_name,salary
from employees
where salary>12000;
#4.查询员工号为176的员工的姓名和部门号
select last_name,department_id
from employees
where employee_id=176;
#5.显示表departments的结构，并查询其中的全部数据
desc departments;
select *
from departments;