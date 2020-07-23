#排序查询
/*
语法
select 查询列表
from 表
where 筛选条件
order by 排序列表 DESC/ASC（不写默认是ASC）

#order by后面可接单个字段、多个字段、表达式、函数
#order by执行顺序：一般放在查询语句的最后面
#但是limit子句除外



*/


SELECT *
FROM employees
ORDER BY salary DESC;

SELECT *
FROM employees
ORDER BY salary ASC;


SELECT *
FROM employees
WHERE department_id >= 90
ORDER BY hiredate ASC;


#按照表达式排序
#order by后面也支持别名

SELECT *, salary*12*(1+IFNULL(commission_pct,0)) AS 年薪
FROM employees
ORDER BY salary*12*(1+IFNULL(commission_pct,0)) DESC;


SELECT *, salary*12*(1+IFNULL(commission_pct,0)) AS 年薪
FROM employees
ORDER BY 年薪 DESC;

#按照姓名长度显示（按长度排序）
SELECT LENGTH(last_name) 字节长度, last_name, salary
FROM employees
ORDER BY 字节长度;

#按照多个字段排序，用逗号分隔条件即可
SELECT *
FROM employees
ORDER BY salary ASC, employee_id DESC;


#查询邮箱中包含e的员工信息，并按照邮箱字节数降序，再按照部门号升序
SELECT *
FROM employees
WHERE email LIKE '%e%'
ORDER BY LENGTH(email) DESC, department_id ASC;


/*
常见函数
格式：
select 函数名(实参列表)
from 表

分类：
1，单行函数
	concat, length,ifnull等
2，分组函数(又成为统计函数、聚集函数)

	


*/

#####字符函数：
#length()表示获取字节数，所以中文是6
SELECT LENGTH('join');
SELECT LENGTH('测试');
SHOW VARIABLES LIKE '%character_set%';

#concat()字符串拼接
SELECT CONCAT(last_name,'_',first_name) 姓名
FROM employees;

#upper,lower
SELECT UPPER('join');
SELECT LOWER(last_name)
FROM employees;

#substr\substring
#mysql中的索引是从1开始
SELECT SUBSTR('测试abcde中',1);#位置开始到后面所有
SELECT SUBSTR('测试abcde中',1,3);#位置开始取指定长度
SELECT CONCAT(UPPER(SUBSTR(last_name,1,1)),
	'_',
	LOWER(SUBSTR(last_name,2)))
FROM employees;

#instr:返回包含字串首次出现的首字符位置，没有返回0
SELECT INSTR('测试abcde中', 'abec');

#trim
SELECT '   test    ', TRIM('   test    ') AS 'out_put';
SELECT TRIM('a' FROM 'aaaaaaaaabaaaaa');

#lpad:用指定字符实现左填充
SELECT LPAD('test',10,'*') AS out_put;

#rpad:右填充
SELECT RPAD('test',2,'*') AS out_put;

#填充数小于字符串时，左右填充都是从左往右取字符个数

#replace
SELECT REPLACE('testtest','t','c');



#####数学函数

#round四舍五入
SELECT ROUND(1.65);
SELECT ROUND(1.657,2);#保留两位

#cell向上取整,返回大于等于的最小整数
SELECT CEIL(1.002);
SELECT CEIL(1.00);

#floor向下取整，返回小于等于的最大整数
SELECT FLOOR(-9);

#truncate截断
SELECT TRUNCATE(1.65,1);

#mod取模，正负号取决于被除数
SELECT MOD(10,3);



#####日期函数

#now返回当前系统日期时间
SELECT NOW();


#curdate返回当前日期，没有时间
SELECT CURDATE();

#curtime返回当前时间，没有日期
SELECT CURTIME();

#获取指定年月日时分秒
SELECT YEAR(NOW()) AS 年;
SELECT YEAR('1919-9-9') 年;

SELECT MONTH(NOW()) AS 月;
SELECT MONTHNAME(NOW()) AS 月名字

#str_to_date：将字符转为日期
SELECT STR_TO_DATE('9-8-2020','%m-%d-%Y');
/*
%Y：四位年份
%y：两位年份
%m：两位月份，单数补零
%c：月份
%d：两位日期
%H：小时(24)
%h：小时(12)
%i：两位分钟
%s：两位秒

*/

SELECT *
FROM employees
WHERE hiredate = STR_TO_DATE('4-3-1992','%c-%d-%Y');

#date_format:日期转化为字符
SELECT DATE_FORMAT(NOW(), '%y年-%m月-%d日') AS out_put;
SELECT last_name, DATE_FORMAT(hiredate, '%y年-%m月-%d日') AS 入职
FROM employees;


####其他函数

SELECT VERSION();#版本号
SELECT DATABASE();
SELECT USER();


####流程控制函数：if-else
#if
SELECT IF(10 > 5, 'big','small');
SELECT last_name, commission_pct,
	IF(commission_pct IS NULL, 'none','has')
FROM employees;

#case使用一：switch-case
/*
case 变量或表达式
when 常量1 then 要显示的值或(语句;)//在select中只能用值，用值不放分号，语句才放
when 常量2...
...
else 要执行的语句
end

*/

SELECT salary, department_id,
	CASE department_id
	WHEN 30 THEN salary*1.1
	WHEN 40 THEN salary*1.2
	ELSE salary
	END AS 新工资
FROM employees;

#case使用二：多重if
/*
case		//case后不加表达式
when 条件1 then 要显示的值或(语句;)
when 条件2 then 要显示的值或(语句;)
...
else 要显示的值或(语句;)
end

*/

SELECT salary,
	CASE
	WHEN salary > 20000 THEN 'A'
	WHEN salary > 10000 THEN 'B'
	ELSE 'c'
	END AS 新工资
FROM employees;


/*
分组函数/聚合函数/统计函数/组函数
传一组值，返回一个值
分类：
sum，avg，max，min，count等
以上五个分组函数都忽略了Null值


*/

SELECT SUM(salary)
FROM employees;

##字符串是可排序的
SELECT MAX(last_name), MIN(last_name)
FROM employees;

##忽略null值
SELECT COUNT(last_name)
FROM employees;

#与distinct搭配实现去重
SELECT SUM(DISTINCT salary), SUM(salary)
FROM employees;

SELECT COUNT(DISTINCT salary), COUNT(salary)
FROM employees;

#count函数支持的参数：
SELECT COUNT(salary)
FROM employees;

#统计总行数
SELECT COUNT(*)
FROM employees;

#和上一个等效，相当于每一行都插入了该常量值，然后统计函数
SELECT COUNT('测试')
FROM employees;

#效率：MYISAM引擎下count(*)效率高，INNODB中count(*)与count(1)效率相当，比count(字段)效率高

#和分组函数以同查询的函数有限制

#这样写会只有一行，所以和分组查询一同使用的查询字段必须是
#group by后的字段
SELECT SUM(salary), employee_id
FROM employees;

##日期差函数
SELECT DATEDIFF(MAX(hiredate), MIN(hiredate)) AS Diff
FROM employees;


/*
group bu语法

select 分组函数(分组的列)
from 表名
where 筛选条件
group by 分组的列
order by 子句

注意，查询表必须特殊，要求是分组函数和group by后出现的字段



*/

#查询每个工种的最高工资
SELECT MAX(salary), job_id
FROM employees
GROUP BY job_id;

#查询每个位置上的部门个数
SELECT COUNT(employees.department_id) 'num', location_id 'loc'
FROM employees JOIN departments
	ON employees.`department_id` = departments.`department_id`
GROUP BY location_id;


#查询哪个部门的员工个数大于二
SELECT department_id, COUNT(*) AS counter
FROM employees
WHERE department_id IS NOT NULL
GROUP BY department_id
HAVING COUNT(*) > 2;

#查询每个工种有奖金的员工的最高工资》12000的工种编号和最高工资
SELECT job_id, MAX(salary)
FROM employees
WHERE commission_pct IS NOT NULL
GROUP BY job_id
HAVING MAX(salary) > 12000;


SELECT manager_id, MIN(salary)
FROM employees
WHERE manager_id > 102
GROUP BY manager_id
HAVING MIN(salary) > 5000;

/*
分组查询中的筛选条件分为两类
		  数据源		位置                关键字
分组前的筛选      原始表                group by子句前面    where
分组后的筛选      分组后的结果集        group by子句后面    having

注意：分组条件一定放在having子句中
      能用分组前筛选尽量用分组前筛选
      group by 分组支持单个，多个字段分组，也支持函数分组(较少)
      orderby在最后
*/

SELECT COUNT(*), LENGTH(CONCAT(last_name,first_name)) AS len
FROM employees
GROUP BY len #mysql 中的group by，having, orderby 支持别名，但是where不支持
HAVING COUNT(*) > 5
ORDER BY COUNT(*) DESC;
#但是oracle中的group by和having不支持别名


#按照多个字段分组
SELECT AVG(salary), department_id, job_id
FROM employees
GROUP BY department_id, job_id;


