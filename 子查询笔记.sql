# 09_子查询

#需求：谁的工资比Abel的高？
#方式1：
select salary
from employees
where last_name='Abel';

select last_name,salary
from employees
where salary>11000;

#方式2：自连接 
select e2.last_name,e2.salary
from employees e1,employees e2
where e2.`salary`>e1.`salary`#多表的连接条件
and e1.`last_name`='Abel';

#方式3：子查询

select last_name,salary
from employees
where salary>(
              select salary
              from employees
              where last_name='Abel'
              );
#2.称谓的规范：外查询（或主查询）、内查询（或子查询）
/*
 子查询（内查询）在主查询之前一次执行完成。
 子查询的结果被主查询（外查询）使用
 注意事项
     子查询要包含在括号内
     将子查询放在比较条件的右侧
     单行操作符对应单行子查询，多行操作符对应多行子查询
*/
/*
 1.子查询的分类
 角度1：从内查询返回的结果的条目数
      单行子查询 vs 多行子查询
 角度2：内查询是否被执行多次
        相关子查询 vs 不相关子查询
 比如：相关子查询的需求：查询工资大于本部门平均工资的员工信息
       不相关子查询的需求：查询工资大于本公司平均工资的员工信息
*/

#4.单行子查询

#4.1 单行操作符： = != > >= < <=

#子查询的编写技巧： ① 从里往外写 ② 从外往里写 

#题目：查询工资大于149号员工工资的员工的信息

select employee_id,last_name,salary
from employees
where salary>(
             select salary
             from employees
             where employee_id=149
);

#题目:返回job_id与141号员工相同,salary比143号员工多的员工姓名,job_id和工资

select last_name,job_id,salary
from employees
where job_id=(
              select job_id
              from employees
              where employee_id=141
)
and
salary >(
              select salary
              from employees
              where employee_id=143
);

#题目:返回公司工资最少的员工的last_name,job_id和salary
select last_name,job_id,salary
from employees
where salary=(
              select MIN(salary)
              from employees
 );
 
#题目:查询与141号员工的manager_id和department_id相同的其它员工的employee_id,manager_id,department_id
#方式1:
select employee_id,manager_id,department_id
from employees
where manager_id=(
                   select manager_id
                   from employees
                   where employee_id=141
)
and
department_id=(
                   select department_id
                   from employees
                   where employee_id=141
)
and
employee_id<>141;
#方式2:
select employee_id,manager_id,department_id
from employees
where (manager_id,department_id)=(
                                  select manager_id,department_id
                                  from employees
                                  where employee_id=141
)
and employee_id<>141;

#题目:查询最低工资大于50号部门最低工资的部门id和其最低工资

select department_id,MIN(salary)
from employees
where department_id is not null
group by department_id
having MIN(salary)>=(
                     select MIN(salary)
                     from employees
                     where department_id=50
);

#题目:显示员工的employee_id,last_name和location
#其中 若员工department_id与location_id为1800的department_id相同,
#则location为'Canada',其余为'USA'
select employee_id,last_name,case department_id when (select department_id
from departments
where location_id=1800)then 'Canada'
else 'USA'end "location"
from employees

#4.2 子查询中的空值问题
select last_name,job_id
from employees
where job_id=
             (
             select job_id
             from employees
             where last_name='Hass'
             );
#4.3 非法使用子查询
select employee_id,last_name
from employees
where salary=
             (
             select MIN(salary)
             from employees
             group by department_id
             );
#5.多行子查询
#5.1多行子查询的操作符：in any all some(同any)

#5.2举例
#in:
select employee_id,last_name
from employees
where salary in
             (
             select MIN(salary)
             from employees
             group by department_id
             );
#any/all
#题目：返回其它job_id中比job_id为IT_RROG部门任一工资低的员工的员工号、姓名、job_id以及salary
select employee_id,last_name,job_id,salary
from employees
where job_id<>'IT_PROG'
and salary < any(
		select salary
		from employees
		where job_id='IT_PROG'
                );
#题目：查询平均工资最低的部门id
#MySQL中聚合函数不能嵌套
#方式1：
select department_id
from employees
group by department_id
having AVG(salary)=(
			select MIN(avg_sal)
			from(
				select department_id,AVG(salary) avg_sal
				from employees
				group by department_id
				) t_dept_avg_sal

			);
#方式2：
select department_id
from employees
group by department_id
having AVG(salary)<=all(
			select AVG(salary) avg_sal
			from employees
			group by department_id	
			);
#6.相关子查询
#回顾：查询员工中工资大于公司平均工资的员工的last_name,salary和其department_id
select last_name,salary,department_id
from employees
where salary>(
		 select AVG(salary)
		 from employees
		 );
#题目：查询员工中工资大于本部门平均工资的员工的last_name,salary和其department_id
#方式1：使用相关子查询
select last_name,salary,department_id
from employees e1
where salary>(
		 select AVG(salary)
		 from employees e2
		 where e2.department_id=e1.`department_id`
		 );
#方式2：在from 中声明子查询
select e.last_name,e.salary,e.department_id
from employees e,(
	select department_id,AVG(salary) avg_sal
	from employees
	group by department_id) t_dept_avg_sal
where e.department_id=t_dept_avg_sal.department_id
and e.`salary`>t_dept_avg_sal.avg_sal;
#题目：查询员工的id,salary,按照department_name排序
select employee_id,salary
from employees e
order by(
	select department_name
	from departments d
	where e.`department_id`=d.`department_id`
	)asc;
#结论：在select中，除了group by 和limit之外，其它位置都可以声明子查询！
#题目：若employees表中employee_id与job_history表中employee_id相同的数目不小于2，
#输出这些相同id的员工的employee_id,last_name和其job_id
select employee_id,last_name,job_id
from employees e
where 2<=(
         select COUNT(*)
         from job_history j
         where e.`employee_id`=j.`employee_id`
	);
#6.2 exists与not exists关键字

#题目：查询公司管理者的employee_id,last_name,job_id,department_id信息
#方式1：自连接
select distinct mgr.`employee_id`,mgr.`last_name`,mgr.`job_id`,mgr.`department_id`
from employees emp join employees mgr
on emp.`manager_id`=mgr.`employee_id`;
#方式2:子查询
select distinct `employee_id`,`last_name`,`job_id`,`department_id`
from employees
where employee_id in(
		select distinct manager_id
		from employees);
#方式3：使用exists
select distinct `employee_id`,`last_name`,`job_id`,`department_id`
from employees e1
where exists(
                select *
		from employees e2
		where e1.`employee_id`=e2.`manager_id`
		);
#题目：查询department表中，不存在于employees表中的部门的department_id和department_name
#方式1：
select d.department_id,d.department_name
from employees e right join departments d
on e.`department_id`=d.`department_id`
where e.`department_id` is null;

#方式2：
select department_id,department_name
from departments d
where not exists(
		select *
		from employees e
		where d.`department_id`=e.`department_id`
		);
#课后练习
#1.查询和Zlotkey相同部门的员工姓名和工资
#2.查询工资比公司平均工资高的员工的员工号，姓名和工资
#3.选择工资大于所有JOB_ID=SA_MAN的员工的工资的last_name,job_id,salary
#4.查询和姓名中包含字母u的员工在相同部门的员工的员工号和姓名‘
#5.查询在部门的location_id为1700的部门的员工的员工号
#6.查询管理者是king的员工姓名和工资
#7.查询工资最低的员工信息：last_name,salary
#8.查询平均工资最低的部门信息
#9.查询平均工资最低的的部门信息和该部门的平均工资（相关子查询）
#10.查询平均工资最高的job信息
#11.查询平均工资高于公司平均工资的部门有哪些？
#12.查询出公司中所有manager的详细信息
#13.各个部门中，最高工资中最低的那个部门，最低工资是多少？
#14.查询平均工资最高的部门的manager的详细信息：last_anme,department_id,email,salary
#15.查询部门的部门号，其中不包括job_id是ST_CLERK的部门号