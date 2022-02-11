#06_多表查询

#1.熟悉常见的几个表
desc employees;
desc departments;
desc locations;

#2.多表的查询如何实现？

#错误的实现方式：每个员工都与每个部门匹配了一遍
#出现了笛卡尔积的错误
#错误的原因：缺少了多表的连接条件
select employee_id,department_name
from employees,departments;#查询出2889条记录
#或
select employee_id,department_name
from employees cross join departments;#查询出2889条记录

select *
from employees;#107条记录
select *
from departments;#27条记录
#27*107=2889

#3.多表查询的正确方式：需要有连接条件

select employee_id,department_name
from employees,departments
#两个表的连接条件
where employees.`department_id`=departments.`department_id`;

#4.如果查询语句中出现了多个表中都存在的字段，则必须指明此字段所在的表。
select employees.employee_id,departments.department_name,employees.`department_id`
from employees,departments
where employees.`department_id`=departments.`department_id`;

#建议：从sql优化的角度，建议多表查询时，每个字段前都指明其所在的表

#5.可以给表起别名，在select和where中使用表的别名。
select emp.employee_id,dept.department_name,emp.`department_id`
from employees emp,departments dept
where emp.`department_id`=dept.`department_id`;

#如果给表起了别名，一旦在select或where中使用表名的话，则必须使用表的别名，而不能再使用表的原名。
#如下的操作是错误的：
select emp.employee_id,dept.department_name,emp.`department_id`
from employees emp,departments dept
where emp.`department_id`=departments.`department_id`;

#6.结论：如果有n个表实现多表的查询，则需要至少n-1个连接方式
#练习：查询员工的employee_id,last_name,department_name,city
select employee_id,last_name,department_name,city
from employees e,departments d,locations l
where e.`department_id`=d.`department_id`
and d.`location_id`=l.`location_id`;

#7.多表查询的分类
/*
  角度1：等值连接 vs 非等值连接
  角度2：自连接 vs 非自连接
  角度3：内连接 vs 外连接
*/

#7.1 等值连接 vs 非等值连接

#非等值连接的例子

select *
from job_grades;

select last_name,salary,grade_level
from employees e,job_grades j
where e.`salary` between j.`lowest_sal` and j.`highest_sal`;

#7.2 自连接 vs 非自连接

#自连接的例子
#练习：查询员工id,员工姓名及其管理者的id和姓名

select emp.employee_id,emp.last_name,mgr.employee_id,mgr.last_name
from employees emp,employees mgr
where emp.`manager_id`=mgr.`employee_id`