USE girls;


/*
笛卡尔集现象：没有明确的执行条件，导致全部连接
解决方法：增加连接条件

*/
SELECT NAME, boyName
FROM boys, beauty
WHERE boys.`id` = beauty.`boyfriend_id`;

/*
连接分类：
sql92标准：仅支持内连接
sql99标准(推荐)：除了全外连接都支持
按功能分：
	内连接：
		等值连接
		非等值连接
		自连接
	外连接：
		左外连接
		右外连接
		全外连接
	交叉连接：
		

*/

#等值连接
#查询员工名和对应的部门名
#为表起别名:提高语句简洁度，区分重名字段
#如果为表起了别名那么就不能用原始的名字了
SELECT last_name, department_name
FROM employees AS e, departments d
WHERE e.`department_id` = d.`department_id`;

SELECT last_name, department_name, commission_pct
FROM employees, departments
WHERE employees.`department_id` = departments.`department_id`
AND commission_pct IS NOT NULL;


#查询每个城市的部门个数
SELECT COUNT(*), city
FROM departments, locations
WHERE departments.`location_id` = locations.`location_id`
GROUP BY city;


#查询有奖金的每个部门的部门名和部门领导编号和该部门的最低工资
SELECT departments.department_name, departments.manager_id, MIN(salary)
FROM departments, employees
WHERE departments.`department_id` = employees.`department_id`
AND commission_pct IS NOT NULL
GROUP BY departments.`department_name`, departments.manager_id;


#查询每个工种的工种名和员工个数，并按照员工个数降序
SELECT job_title, COUNT(*)
FROM employees e, jobs j
WHERE e.`job_id` = j.`job_id`
GROUP BY job_title
ORDER BY COUNT(*) DESC;


SELECT last_name, department_name, city
FROM employees, departments, locations
WHERE employees.`department_id` = departments.`department_id`
AND departments.`location_id` = locations.`location_id`;

/*
1，多表连接结果为多表交集部分
2，n表连接，至少需要n-1个条件
3，多表没有顺序要求
4，一般需要为表起别名
5，可以搭配前面所有句子使用
*/


#非等值连接

#查询员工工资和工资级别
CREATE TABLE job_grades
(grade_level VARCHAR(3),
 lowest_sal  INT,
 highest_sal INT);

INSERT INTO job_grades
VALUES ('A', 1000, 2999);

INSERT INTO job_grades
VALUES ('B', 3000, 5999);

INSERT INTO job_grades
VALUES('C', 6000, 9999);

INSERT INTO job_grades
VALUES('D', 10000, 14999);

INSERT INTO job_grades
VALUES('E', 15000, 24999);

INSERT INTO job_grades
VALUES('F', 25000, 40000);


SELECT * 
FROM job_grades;

SELECT salary, grade_level
FROM employees e, job_grades g
WHERE e.`salary` BETWEEN g.`lowest_sal` AND g.`highest_sal`;


#自连接：自己连接自己
#自连接条件：

#查询员工名和领导名
SELECT e.employee_id, e.last_name, m.`employee_id`, m.last_name
FROM employees e, employees m
WHERE e.`manager_id` = m.`employee_id`;


/*
sql99语法：
内连接：(inner可省略) join
外连接：左外：left (outer可省略) join
	内外：right join
	全外：full join
交叉连接：cross join

格式：
	select 查询列表
	from 表1 别名
	join 表2 别名
	on 连接条件
	where筛选条件
	group by
	having
	order by
连接条件放在on后面提高了分离性，便于阅读

*/

#1，等值连接，与92语法的内连接一样
SELECT last_name, department_name
FROM employees e
INNER JOIN departments d
ON e.`department_id` = d.`department_id`
WHERE e.`last_name` LIKE '%e%';


SELECT COUNT(*), e.department_id
FROM employees e
INNER JOIN departments d
ON e.`department_id` = d.`department_id`
GROUP BY d.department_name
HAVING COUNT(*) > 3
ORDER BY COUNT(*);


#多表内联需要两个表连好之后去连第三个
#每两个连接表都要有连接条件
SELECT last_name, department_name, job_title
FROM employees e
INNER JOIN departments d
ON e.`department_id` = d.`department_id`
INNER JOIN jobs j
ON e.`job_id` = j.`job_id`
ORDER BY d.`department_name`;

#非等值连接
SELECT salary, grade_level
FROM employees e
JOIN job_grades g
ON e.`salary` BETWEEN g.`lowest_sal` AND g.`highest_sal`
ORDER BY e.`salary`;


#自连接
SELECT e.last_name, m.last_name
FROM employees e
JOIN employees m
ON e.`manager_id` = m.`employee_id`
WHERE e.`last_name` LIKE '%k%';


#二，外连接
#用于查询一个表有，另一个表没有的项目
#内连接方法，只能查询匹配的，主表中没有匹配的不能显示：
SELECT *
FROM beauty
JOIN boys
ON beauty.`boyfriend_id` = boys.`id`;

#外连接中，有主表和从表之分，若从表中没有与主表匹配的，则结果中有主表，从表部分小时空
#left join左边是主表，right join右边是主表，交换两个表的顺序可以实现相同效果

SELECT boys.*, beauty.`name`
FROM beauty
LEFT JOIN boys
ON beauty.`boyfriend_id` = boys.`id`
WHERE boys.`id` IS NOT NULL;

SELECT boys.*, beauty.`name`
FROM boys
RIGHT JOIN beauty
ON beauty.`boyfriend_id` = boys.`id`
WHERE boys.`id` IS NOT NULL;

SELECT boys.*, beauty.*
FROM beauty
FULL JOIN boys#mysql不支持
ON boys.`id` = beauty.`boyfriend_id`;

#全外连接的结构为内连接结果加上表一有表二没有的数据，加上表二有表一没有的数据

#交叉连接:99标准的笛卡尔乘积，92中就是逗号不加条件
SELECT boys.*, beauty.*
FROM boys
CROSS JOIN beauty;


/*
子查询：出现在其他语句中的select子句，成为子查询或内查询
子查询出现的位置：
	select后面
		标量子查询
	from后面
		表子查询
	where后
		标量子查询
		列子查询
		行子查询
	having后
		标量子查询
		列子查询
		行子查询
	exists后(相关子查询)
		表子查询
按结果集的不同：
	标量子查询：结果一列一行
	列子查询：结果一列多行
	行子查询：结果一行多列或者多行多列
	表子查询：所有结果集都可以

子查询的执行优先于主查询执行

*/

#where或having后面
#子查询一般都放在小括号内
#子查询一般放在条件的右侧
#标量子查询一般搭配单行操作符使用：<>=
#列子查询一般搭配多行操作符使用in any/some, all

SELECT *
FROM employees
WHERE salary >
(
	SELECT salary
	FROM employees
	WHERE last_name = 'Abel'
);


SELECT last_name, job_id, salary
FROM employees
WHERE job_id = (
	SELECT job_id 
	FROM employees
	WHERE employee_id = 141
)
AND salary > (
	SELECT salary 
	FROM employees
	WHERE employee_id = 143
);

SELECT last_name, salary
FROM employees
WHERE salary = (
	SELECT MIN(salary)
	FROM employees
);

SELECT department_id, MIN(salary)
FROM employees
GROUP BY department_id
HAVING MIN(salary) > (
	SELECT MIN(salary)
	FROM employees
	WHERE department_id = 50
);



#列子查询
#需要搭配多行操作符来使用
#in/not in：等于列表中的任意一个
#any/some：和子查询返回的某一个值比较
#all：和子查询返回的所有值比较

SELECT salary
FROM employees
WHERE salary > ANY(
	SELECT salary
	FROM employees
	WHERE department_id = 50
);


SELECT last_name
FROM employees
WHERE department_id IN (
SELECT DISTINCT department_id
FROM departments
WHERE location_id IN (1400, 1700)
);

#行子查询

#查询员工编号最小并且工资最高的员工信息

#非行子查询写法
SELECT * 
FROM employees
WHERE employee_id = (
	SELECT MIN(employee_id)
        FROM employees
)
AND salary = (
	SELECT MAX(salary)
	FROM employees
);

#行子查询写法
SELECT *
FROM employees
WHERE (employee_id, salary)=(
	SELECT MIN(employee_id), MAX(salary)
	FROM employees
);
#相当于将多个字段生成一个新的行，然后作为一个条件


#select后面
SELECT d.*, (
	SELECT COUNT(*)
	FROM employees
	WHERE employees.`department_id` = d.`department_id`
) counter
FROM departments d;

SELECT d.`department_name`
FROM departments d
WHERE d.`department_id` = (
	SELECT department_id
	FROM employees
	WHERE employee_id = 102
);


#from后
#子查询结果充当一张表，表必须起别名

#部门平均工资的等级
SELECT ag_dep.*, g.grade_level
FROM
(SELECT AVG(salary) AS av_sal, department_id
FROM employees
GROUP BY department_id) AS ag_dep
JOIN job_grades AS g
ON ag_dep.av_sal BETWEEN g.`lowest_sal` AND g.`highest_sal`


#exists后子查询,bool类型，有结果返回1，没有返回0
SELECT EXISTS(SELECT * FROM employees)


SELECT employee_id, last_name, salary, temp.av
FROM employees
JOIN 
(SELECT department_id, AVG(salary) AS av
FROM employees
GROUP BY department_id) AS temp
ON employees.`department_id` = temp.department_id
WHERE salary > temp.av;

/*
分页查询
当要显示的数据一页显示不全
语法：
	select 查询列表
	from 表
	join 表
	on 连接条件
	where 筛选条件
	group by 分组字段
	having 分组后筛选
	order by 排序字段
	limit offset, size
	
offset：要显示条目的起始索引(索引从0开始)
size为要显示的条目数
	

*/


SELECT *
FROM employees
LIMIT 0, 5;

SELECT *
FROM employees
LIMIT 5;#从第一条开始可以省略offset

SELECT *
FROM employees
LIMIT 1000, 15;#超过了不显示


#测试：
SELECT last_name, salary
FROM employees
JOIN
(SELECT MIN(salary), employee_id
FROM employees) AS temp
ON employees.`employee_id` = temp.employee_id;


SELECT departments.*, MIN(dsal)
FROM departments
JOIN
(SELECT AVG(salary) AS dsal, department_id
FROM employees
GROUP BY department_id) temp
ON departments.`department_id` = temp.department_id;


SELECT AVG(salary) AS avs, department_id
FROM employees
GROUP BY department_id
HAVING avs > (SELECT AVG(salary) FROM employees);


SELECT *
FROM employees
WHERE employee_id IN(
	SELECT DISTINCT manager_id FROM employees
)

SELECT MIN(maxs) FROM(
SELECT MAX(salary) AS maxs, department_id
FROM employees
GROUP BY department_id) AS temp


#联合查询：将多个查询的结果合并成一个结果
SELECT * FROM employees WHERE email LIKE '%a%'
UNION
SELECT * FROM employees WHERE department_id > 90
UNION
SELECT * FROM employees WHERE salary > 12000;

#应用场景，数据来源于多个表，多个表没有直接联系
#这些表的形式都相同()
/*
联合查询要求
1，多个表的列数是一致的
2，查询结果的字段默认 是第一个表的字段
   所以要求查询顺序是已知的
3，union默认会去重
4，不想去重使用union all

*/
