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
#7.3 内连接 vs 外连接

#内连接：合并具有同一列的两个以上的表的行，结果集中不包含一个表与另一个表不匹配的行
select employee_id,department_name
from employees e,departments d
where e.`department_id`=d.`department_id`;
#外连接：合并具有同一列的两个以上的表的行，结果集中除了包含一个表与另一个表不匹配的行之外，
#         还查询到了左表或右表中不匹配的行
#外连接的分类：左外连接、右外连接、满外连接
#左外连接：两个表在连接过程中除了返回满足连接条件的行以外还返回左表中不满足条件的行，这种连接称为左外连接
#右外连接：两个表在连接过程中除了返回满足连接条件的行以外还返回右表中不满足条件的行，这种连接称为右外连接

#查询所有的员工的last_name,department_name信息（所有==>外连接）
select employee_id,department_name
from employees e,departments d
where e.`department_id`=d.`department_id`; #需要使用左外连接

#SQL92语法实现内连接：见上，略
#SQL92语法实现外连接：使用 + -----MySQL不支持SQL92语法中外连接的写法
#左外连接
select employee_id,department_name
from employees e,departments d
where e.`department_id`=d.`department_id`(+);

#右外连接
select employee_id,department_name
from employees e,departments d
where e.`department_id`(+)=d.`department_id`;

#SQL99语法中使用join...on的方法实现多表的查询。这种方法也能解决外连接的问题。MYSQL是支持此种方法的

#SQL99语法实现内连接：
select employee_id,department_name
#from employees e inner join departments d
from employees e join departments d
on e.`department_id`=d.`department_id`;

#SQL99语法实现外连接：
#查询所有的员工的last_name,department_name信息（所有==>外连接）
select employee_id,department_name
from employees e left outer join departments d
on e.`department_id`=d.`department_id`;

#右外连接：
select employee_id,department_name
from employees e right outer join departments d
on e.`department_id`=d.`department_id`;

#满外连接：mysql不支持full outer join
select employee_id,department_name
from employees e full outer join departments d
on e.`department_id`=d.`department_id`;

#8.union 和 union all 的使用
#union:会执行去重的操作
#union all:不会执行去重操作
#结论：如果明确知道合并数据后结果数据不存在重复数据，则使用union all语句来提高数据

#两集合去除中间共同部分和右集合
select employee_id,department_name
from employees e left join departments d
on e.`department_id`=d.`department_id`
where d.department_id is null;

#两集合去除中间共同部分和左集合
select employee_id,department_name
from employees e right join departments d
on e.`department_id`=d.`department_id`
where e.`department_id` is null;

#满外连接
select employee_id,department_name
from employees e left join departments d
on e.`department_id`=d.`department_id`
union all
select employee_id,department_name
from employees e right join departments d
on e.`department_id`=d.`department_id`
where e.`department_id` is null;
#或
select employee_id,department_name
from employees e right join departments d
on e.`department_id`=d.`department_id`
union all
select employee_id,department_name
from employees e left join departments d
on e.`department_id`=d.`department_id`
where d.`department_id` is null;

#两集合全集除去中间共同部分
select employee_id,department_name
from employees e left join departments d
on e.`department_id`=d.`department_id`
where d.department_id is null
union all
select employee_id,department_name
from employees e right join departments d
on e.`department_id`=d.`department_id`
where e.`department_id` is null;

#10.SQL99语法的新特性1：自然连接
select employee_id,last_name,department_name
from employees e join departments d
on e.`department_id`=d.`department_id`
and e.`manager_id`=d.`manager_id`;

#natural join : 它会帮你自动查询两张连接表中‘所有相同的字段’，然后执行‘等值连接’
select employee_id,last_name,department_name
from employees e natural join departments d;

#11.SQL99语法的新特性2：using
select employee_id,last_name
from employees e join departments d
on e.`department_id`=d.`department_id`;

select employee_id,last_name
from employees e join departments d
using (department_id);