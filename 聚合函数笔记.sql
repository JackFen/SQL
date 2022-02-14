# 08_聚合函数
#1.常见的几个聚合函数
#1.1avg/sum
select AVG(salary),SUM(salary),AVG(salary)*107
from employees;

#如下操作是无意义的
select SUM(last_name),AVG(last_name),SUM(hire_date)
from employees;

#1.2max/min:适用于数值类型，字符串类型，日期类型的字段
select MAX(salary),MIN(salary)
from employees;

select MAX(last_name),MIN(last_name),MIN(hire_date)
from employees;

#1.3count
#(1) 作用：计算指定字段子啊查询结构中出现的个数(不包含null值)
select COUNT(employee_id),COUNT(salary),COUNT(2*salary),COUNT(1),COUNT(2),COUNT(*)
from employees;

#如果计算表中有多少条记录，如何实现？
#方式1：count(*)
#方式2：count(1)
#方式3：count(具体字段)：不一定对！

#（1）计算指定字段出现的个数时，是不计算null值的
select COUNT(commission_pct)
from employees;

select COUNT(commission_pct)
from employees
where commission_pct is not null;

#(2)公式：avg=sum/count
select AVG(salary),SUM(salary)/COUNT(salary),
AVG(commission_pct),SUM(commission_pct)/COUNT(commission_pct),
SUM(commission_pct)/107
from employees;

#需求：查询公司平均奖金率
select SUM(commission_pct)/COUNT(IFNULL(commission_pct,0)),
AVG(IFNULL(commission_pct,0))
from employees;

#如果需要统计表中的记录数，使用count(*)、count(1)、count(具体字段) 哪个效率更高？
#如果使用的是MySQLISAM存储引擎，则三者效率相同，都是o(1)
#如果使用的是InnoDB存储引擎，则三者效率：count(*)=count(1)>count(字段)

#group by 的使用

#需求：查询各个部门的平均工资，最高工资
select department_id,AVG(salary),MAX(salary)
from employees
group by department_id;

#需求：查询各个job_id的平均工资
select job_id,AVG(salary)
from employees
group by job_id;

#需求：查询各个department_id,job_id的平均工资
select department_id,job_id,AVG(salary)
from employees
group by department_id,job_id;
#或
select job_id,department_id,AVG(salary)
from employees
group by job_id,department_id;

#错误的！

select department_id,job_id,AVG(salary)
from employees
group by department_id;
#结论1：select中出现的非组函数的字段必须声明再group by中。反之，group by中声明的字段可以不出现在select中

#结论2：group by 声明在from、where后面，order by、limit前面

#结论3：MySQL中group by中使用 with rollup
select department_id,job_id,AVG(salary)
from employees
group by department_id with rollup;#说明：with rollup会多出一行整体的函数值：此处多出一行公司整体工资的平均值
#说明：rollup 和 order by是互斥的。

#having的使用（作用：用来过滤数据）
#练习：查询各个部门中最高工资比10000高的部门信息
#错误的写法
select department_id,MAX(salary)
from employees
where MAX(salary)>10000
group by department_id;

#要求1：如果过滤条件中采用了聚合函数，则必须采用having来替换where。否则，报错
#要求2：having必须声明在group by的后面。

#正确的写法：
select department_id,MAX(salary)
from employees
group by department_id
having MAX(salary)>10000;

#练习：查询部门id为10，20，30，40部门中最高工资比10000高的部门信息
#方式1：推荐，执行效率高于方式2
select department_id,MAX(salary)
from employees
where department_id in(10,20,30,40)
group by department_id
having MAX(salary)>10000;
#方式2：
select department_id,MAX(salary)
from employees
group by department_id
having MAX(salary)>10000 and department_id in(10,20,30,40);
#结论：当过滤条件中有聚合函数时，则此过滤条件必须声明在having中。
#      当过滤条件中没有聚合函数时，则此过滤条件声明在where中或者having中都可以。但是建议大家声明在where中。
/*
where与having的对比
1.从适用范围上来讲，having的适用范围更广。
2.如果过滤条件中没有聚合函数：这种情况下，where的执行效率要高于having
*/
#4.SQL底层执行原理
#4.1 select语句的完整结构
/*
SQL92语法：
select...,...,...(存在聚合函数)
from ...,...,...
where 多表的连接条件 and 不包含聚合函数的过滤条件
group by...,...(asc/desc)
limit ...,...

SQL99语法：
select...,...,...(存在聚合函数)
from ...(left/right)join...on 多表的连接条件
(left/right)join...on ...
where 不包含聚合函数的过滤条件
group by...,...(asc/desc)
having 包含聚合函数的过滤条件
order by ...,...(asc/desc)
limit ...,...
#4.2SQL语句的执行过程：
from ...,...->on->(left/right) join->where ->group by->having ->select ->distinct->order by->limit
*/
#课后练习
#1.where子句是否可用组函数过滤
#不能
#2.查询公司员工工资最大值，最小值，平均值，总和
select MAX(salary),MIN(salary),AVG(salary),SUM(salary)
from employees;
#3.查询各job_id的员工工资的最大值，最小值，平均值，总和
select job_id,MAX(salary),MIN(salary),AVG(salary),SUM(salary)
from employees
group by job_id;
#4.选择具有各个job_id的员工人数
select job_id,COUNT(*)
from employees
group by job_id;
#5.查询员工最高工资和最低工资的差距（difference）
select MAX(salary)-MIN(salary) "difference"
from employees;
#6.查询各个管理者手下员工的最低工资，其中最低工资不能低于6000,没有管理者的员工不计算在内’
select manager_id,MIN(salary)
from employees
where manager_id is not null
group by manager_id
having MIN(salary)>=6000; 
#7.查询所有部门的名字，location_id,员工数量和平均工资，并按平均工资降序
select d.department_name,d.location_id,COUNT(employee_id),AVG(salary) avg_sal
from departments d left join employees e
on d.`department_id`=e.`department_id`
group by department_name,location_id
order by avg_sal desc;
#8.查询每个工种，每个部门的部门号，工种名和最低工资
select d.department_name,e.`job_id`,MIN(salary)
from departments d left join employees e
on d.`department_id`=e.`department_id`
group by department_name,job_id
