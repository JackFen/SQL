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