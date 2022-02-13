#07_单行函数
#1.数值函数 略
#单行函数可以嵌套

#2.字符串函数

select ASCII('abc'),CHAR_LENGTH('hello'),CHAR_LENGTH('我们'),LENGTH('hello'),LENGTH('我们')
from dual;

#xxx worked for yyy
select CONCAT(emp.last_name,'worked for',mgr.last_name) "detail"
from employees emp join employees mgr
where emp.`manager_id`=mgr.`employee_id`;

select CONCAT_WS('-','hello','world')
from dual;
#字符串的索引是从1开始的！
select INSERT('helloworld',2,3,'aaaaa'),REPLACE('hello','ll','mmm')
from dual;

select UPPER('hello'),LOWER('HELLO')
from dual;

select LEFT('hello',2),RIGHT('hello',3),RIGHT('hello',13)
from dual;

#LPAD:实现右对齐效果
#RPAD:实现左对齐效果
select employee_id,last_name,LPAD(salary,10,'*')
from employees;

#LTRIM 去掉字符串左边的空格
#RTRIM 去掉字符串右边的空格
select TRIM('    h e l lo   ')#去掉首尾的空格
,TRIM('oo'from 'oohello')
from dual;

select REPEAT('hello',4),LENGTH(SPACE(5)),STRCMP('abc','abd')
from dual;

select SUBSTR('hello',2,2),LOCATE('111','hello')
from dual;

select ELT(2,'a','b','c','d'),FIELD('mm','gg','jj','mm','dd','mm'),
FIND_IN_SET('mm','gg,jj,mm,dd,mm')
from dual;

select employee_id,NULLIF(LENGTH(first_name),LENGTH(last_name)) "compare"
from employees;

#3.日期和时间函数

#3.1 获取日期、时间
select CURDATE(),CURRENT_TIME(),CURTIME(),NOW(),SYSDATE(),UTC_DATE(),UTC_TIME()
from dual;

#3.2 日期与时间戳的转换
select UNIX_TIMESTAMP(),UNIX_TIMESTAMP('2021-10-01 12:12:32'),
FROM_UNIXTIME(1644656079)
from dual;

#3.3 获取月份、星期、星期数、天数等函数
select YEAR(CURDATE()),MONTH(CURDATE()),DAY(CURDATE()),
HOUR(CURTIME()),MINUTE(NOW()),SECOND(SYSDATE())
from dual;

select MONTHNAME('2022-02-12 16:54:39'),DAYNAME('2022-02-12'),WEEKDAY('2022-02-12'),
QUARTER(CURDATE()),WEEK(CURDATE()),DAYOFYEAR(NOW()),
DAYOFMONTH(NOW()),DAYOFWEEK(NOW())
from dual;

#3.4 日期的操作函数

select EXTRACT(second from NOW())
from dual;

#3.5 时间和秒钟转换的函数
select TIME_TO_SEC(CURTIME()),
SEC_TO_TIME(83355)
from dual;

#3.6 计算日期和时间的函数

select NOW(),DATE_ADD(NOW(),interval 1 year),

from dual;

#3.7 日期的格式化与解析
#格式化：日期-->字符串
#解析：字符串-->日期

#此时我们谈的是日期的显示格式化
#之前，我们接触的是日期的隐式格式
select *
from employees
where hire_date='1993-01-13';

#格式化：
select DATE_FORMAT(CURDATE(),'%Y-%M-%D'),
DATE_FORMAT(NOW(),'%Y-%m-%d'),TIME_FORMAT(CURTIME(),'%H:%i:%S'),
DATE_FORMAT(NOW(),'%Y-%M-%D %h:%i:%s %W %w %T %r')
from dual;

#解析：格式化逆过程
select STR_TO_DATE('2022-February-13th 03:59:41 Sunday 0','%Y-%M-%D %h:%i:%s %W %w')
from dual;

select GET_FORMAT(date,'USA')
from dual;

select DATE_FORMAT(CURDATE(),GET_FORMAT(date,'USA'))
from dual;

#4.流程控制函数
#4.1 if(value,balue1,value2)

select last_name,salary,IF(salary>=6000,'高工资','低工资') "details"
from employees;

select last_name,commission_pct,IF(commission_pct is not null,commission_pct,0) "details",
salary *12*(1+IF(commission_pct is not null,commission_pct,0)) "annual_sal"
from employees;

#4.2 ifnull(value1,value2):看作是if(value,value1,value2)的特殊情况
select last_name,commission_pct,IFNULL(commission_pct,0) "details"
from employees;

#4.3 case when...then...when...then...else...end
#类似于java的if...else if...else if...else
select last_name,salary,case when salary>=15000 then '白骨精'
                              when salary>=1000 then '潜力股'
                              when salary>=8000 then '屌丝'
                              else '草根' end "details","details",department_id
from employees;

#4.4case...when...then...when...then...else...end
/*
练习1：
查询部门号为10，20，30的员工信息
若部门号为10，则打印其工资的1.1倍
20号部门，则打印其工资的1.2倍
30号部门，打印其工资的1.3倍
其它部门，打印其工资的1.4倍
*/
select employee_id,last_name,department_id,salary,case department_id when 10 then salary*1.1
                                                                     when 20 then salary*1.2
                                                                     when 30 then salary*1.3
                                                                     else salary*1.4 end "details"
from employees;
/*
练习1：
查询部门号为10，20，30的员工信息
若部门号为10，则打印其工资的1.1倍
20号部门，则打印其工资的1.2倍
30号部门，打印其工资的1.3倍
*/
select employee_id,last_name,department_id,salary,case department_id when 10 then salary*1.1
                                                                     when 20 then salary*1.2
                                                                     when 30 then salary*1.3
                                                                     end "details"
from employees
where department_id in(10,20,30);

#5. 加密于解密的函数
# password()、encode()、decode()在MySQL.0中已弃用。
select PASSWORD('mysql')
from dual;

select MD5('mysql'),SHA('mysql')
from dual;

#6. MySQL信息函数

select VERSION(),CONNECTION_ID(),DATABASE(),SCHEMA(),
USER(),CURRENT_USER(),CHARSET('尚硅谷'),COLLATION('尚硅谷')
from dual;

#7.其它函数
#如果n的值小于或者等于0，则只保留到整数部分
select FORMAT(123.123,2),FORMAT(123.123,0),FORMAT(123.123,-2)
from dual;

select CONV(16,10,2),CONV(888,10,16),CONV(null,10,2)
from dual;

select INET_ATON('192.168.1.100'),INET_NTOA(3232235876)
from dual;

#benchmark()用于测试表达式的执行效率
select BENCHMARK(100000,MD5('mysql'))
from dual;

select CHARSET('atguigu'),CHARSET(CONVERT('atguigu'using 'gbk'))
from dual;

#课后练习

#1.显示系统时间（注：日期+时间）
select now(),sysdate(),current_timestamp(),localtime(),localtimestamp()
from dual;
#2.查询员工号，姓名，工资，以及工资提高20%后的结果（new salary）
select employee_id,last_name,salary,salary*1.2 "new salary"
from employees;
#3.将员工的姓名按首字母排序，并写出姓名的长度（length）
select last_name,length(last_name) "length"
from employees
order by last_name asc;
#4.查询员工id,last_name,salary,并作为一个列输出，别名为out_put
select concat(employee_id,',',last_name,',',salary) "out_put"
from employees;
#5.查询公司各员工工作的年数、工作的天数、并按工作年数的降序排序
select employee_id,datediff(curdate(),hire_date)/365 "worked_years",DATEDIFF(CURDATE(),hire_date) "worked_days"
from employees
order by worked_years desc;
#6.查询员工姓名，hire_date,department_id,满足一下条件：雇佣时间在1997年之后，department_id
# 为80或者110，commission_pct不为空
select last_name,hire_date,department_id
from employees
where department_id in(80,90,110)
and commission_pct is not null
#and hire_date>='1997-01-01';#存在着隐式转换
#and date_format(hire_date,'%Y-%m-%d')>='1997-01-01';#显示转换操作，格式化操作，日期-->字符串
and hire_date>=str_to_date('1997-01-01','%Y-%m-%d');#显示转换操作，解析操作，字符串-->日期

#7.查询公司中入职超过10000天的员工姓名、入职时间
select last_name,hire_date
from employees
where datediff(curdate(),hire_date)>=10000;
#8.做一个查询，产生下面的结果
#<last_name> earns<salary> monthly but wants <salary*3>

select concat(last_name,' earns ',truncate(salary,0),' monthly but wants ',truncate(salary*3,0)) "Dream salary"
from employees;

#9.使用case-when,按照下面的条件：
/*
job                grade
AD_PRES             A
ST_MAN              B
IT_PROG             C
SA_REP              D
ST_CLERK            E
产生下面的结果：last_name  Job_id  Grade
*/
select last_name "Last_name",job_id "Job_id",case job_id when 'AD_PRES' then 'A'
                                                         when 'ST_MAN' then 'B'
                                                         when 'IT_PROG 'then'C'
                                                         when 'SA_REP ' then 'D'
                                                         when 'ST_CLERK ' then 'E'
                                                         else 'undefined'                                                         
                                                         end "Grade"
from employees;