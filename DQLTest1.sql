/*
基础查询
1， select 查询列表
    from 表名；
查询列表可以是：表中的字段，常量值，表达式，函数
查询结果是一个虚拟的表格

F12，可以优化查询结构





*/
USE myemployees;
#建议在每次查询前都加上use以防出错
#查询时可以加上``符号来区分查询内容和关键字
#执行过程是选中之后F9


SELECT 
  last_name,
  `salary`,
  email 
FROM
  employees ;
  
#查询常量值
#mysql不区分字符和字符串
SELECT 100;
SELECT 'join';


#查询表达式
SELECT 100*18;

#查询函数
SELECT COUNT(last_name)
FROM employees;	

#为字段起别名，别名紧接在后面可以省略AS，别名中有空格或者关键字可以加引号，单双都可
SELECT 100%98 AS 结果;
SELECT last_name 姓, first_name 名
FROM employees;
SELECT 100 AS "out put";

#去重
SELECT DISTINCT department_id FROM employees;

#+号的作用
#员工名和姓连接到一起
SELECT last_name+first_name AS 姓名
FROM employees;
SELECT 100+90;
#结果都是0，因为两个操作都为数值型，则做加法
#若其中一方为数值型，则会试图将另一个转为数值型计算
#如果转换失败则将其转换为0再计算
#如果一方为NULL，则结果肯定为NULL
#字符拼接应该用concat函数
SELECT CONCAT('c','b','c') AS 结果;
SELECT CONCAT(first_name,last_name) AS 姓名
FROM employees;

#NULL和任何操作数操作都是NULL
#IFNUL函数可以在操作数为空时将其指定为默认值
SELECT DISTINCT IFNULL(department_id,0), department_id
FROM employees;

#条件查询
#select 查询列表 
#from 表名
#where 筛选条件;
#执行顺序是，from看有没有表，若存在测到where筛选，最后select

#允许的筛选条件
#1，条件运算符：> < = != <> >= <=
#2，逻辑运算符：&& || ！
#		and or not
#3，模糊查询：like
#	      between and
#	      in
#             is null
SELECT * 
FROM employees
WHERE salary IS NULL;

SELECT last_name, department_id
FROM employees
WHERE department_id <> 90;


SELECT last_name
FROM employees
WHERE first_name <> 'zhangsan'
#判断字符串不等使用<>

SELECT last_name
FROM employees
WHERE department_id != 100;


SELECT last_name,salary,commission_pct
FROM employees
WHERE salary > 10000 AND salary < 20000 OR department_id > 100;


/*
like关键字
1，表示包含的条件
2，%通配符，可以匹配任意多个字符，包含0
3，_通配符，表示通配一个字符
4，转义符可以是默认的\或者使用escape关键字指定
5，通配符不能表示NULL值
*/
SELECT *
FROM employees
WHERE last_name LIKE '%a_';

SELECT last_name
FROM employees
WHERE last_name LIKE '\_a\%';

SELECT last_name
FROM employees
WHERE last_name LIKE '$_a$%' ESCAPE '$';

#以下两个结果不一定一样，因为%不能表示空值
SELECT *
FROM employees;

SELECT *
FROM employees
WHERE commission_pct LIKE '%%';


#between A and B包含临界值，但是两个临界值不能调换顺序
#相当于A <= x <= B
SELECT *
FROM employees
WHERE employee_id BETWEEN 100 AND 120;


#in用于判断字段是否属于列表中的某一项
#in列表的值类型必须一致或兼容
#in
SELECT last_name, job_id
FROM employees
WHERE job_id IN ('IT_PROT','AD_VP','AD_PRES','AD_%');
#在非like语句中使用_%会被识别为普通字符


#NULL值不能使用=来运算，只能用is null或者is not null
SELECT last_name, commission_pct
FROM employees
WHERE commission_pct IS NULL;


#安全等于： <=>
#可以判断NULL值，也可以判断数值，但是可读性较低
SELECT last_name, commission_pct
FROM employees
WHERE commission_pct <=> NULL;

SELECT last_name, commission_pct
FROM employees
WHERE salary <=> 12000;






