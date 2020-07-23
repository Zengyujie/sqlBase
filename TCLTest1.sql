/*
TCL：事务控制语言

1,事务：一个或一组sql语句组成的一个执行单元，这个执行单元
要么全部执行，要么全部不执行


事务

如果事务中的某条sql语句出现问题，则整个单元将会回滚
所有受影响的事物回到执行前的状态

存储引擎：数据的不同存储技术，也被成为表类型


#查看存储引擎
show engines;

innodb引擎支持事务，有些引擎不支持事务

事务的特性(ACID)
1，原子性(Atomicity)
	原子性是指事务一个不可分割的工作单位，要么都发生要么都不发生
2，一致性(Consistency)
	事务必须使数据库从一个一致性状态变换到另一个一致性状态
3，隔离性(Isolation)
	事务的隔离性指的是一个事物的执行不能被其他事务干扰，即一个事务内部的操作及使用的数据对并发的其他事务是隔离的，并发执行的各个事务之间不能相互干扰
4，持久性(Durability)
	一个事务一旦提交，它对数据库中数据的改变就是永久性的，接下来的其他操作和数据库故障不应该对其有任何影响

事务的创建：

1，隐式事务：事务没有明确的开启和结束标记
例如单条的insert, update, delete等

2，显式事务：有明确的开启和结束的标记
前提：必须先设置自动提交功能为禁用，否则会单条执行完自动提交

#关闭当前会话的自动提交(仅当前会话有效，下次要重新设置)
set autocommit = 0;

步骤一，开启事务
set autocommit = 0;
start transaction;（可选的）
步骤二，编写事务中的sql语句(增删改查select, insert, update, delete)，DDL语言没有事务之说，
语句1;
语句2;
...
步骤三，结束事务
commit;提交事务

rollback;回滚事务

*/

#例一
SET autocommit = 0;
START TRANSACTION;
UPDATE account SET balance = 500 WHERE username='zhang';
UPDATE account SET balance = 500 WHERE username='zhao';
commmit;

#例二
SET autocommit = 0;
START TRANSACTION;
UPDATE account SET balance = 500 WHERE username='zhang';
UPDATE account SET balance = 500 WHERE username='zhao';
ROLLBACK;

#结束之前数据都在内存中，提交之后才持久化

/*
对于同时运行的多个事务，当这些事务访问数据库中的相同数据时，如果没有必要的隔离机制，就会导致以下并发问题：

1，脏读：对于两个事务t1，t2，t1读取了已经被t2更新但是还没有被提交的字段之后，若t2回滚，则t1读取的临时且无效的(没有提交)
2，不可重复读：对于两个事务t1，t2，t1读取了一个字段，然后t2更新了该字段之后，t1再次读取同一个字段，值不同了(更新)
3，幻读：对于两个事务t1，t2，t1读取了一个字段，然后t2在该表中插入了一些新的行之后，如果t1再次读取同一个表，就会多出几行(插入)


隔离级别：一个事务与其他事务隔离的程度称为隔离级别，级别越高并发性越弱

1，read uncommitted  读未提交数据
	允许事务读取未被其他事务提交的变更；脏读，不可重复读，幻读都会出现
2，read committed 读已提交数据
	只允许事务读取已经被其他事务提交的变更，可以避免脏读，但是不可重复读和幻读可能出现
3，repeatable read 可重复读
	确保事务可以多次从一个字段中读取相同的值，期间禁止其他事务对该字段更新，可以避免脏读和不可重复读，但是幻读可能发生
4，serializable 串行化
	确保事务可以从一个表中读取相同的行，该事务执行期间，禁止其他事务对表插入更新删除，可以避免所有并发问题，但是效率低下

oracle支持read commited 和 serializable， 默认为前者
mysql支持四种，么人为repeateable read


*/
#查看隔离级别
SELECT @@tx_isolation

#设置当前连接隔离级别
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

#设置全局隔离级别
SET GLOBAL TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

/*
savepoint设置保存点
只能与rollback搭配使用
格式
savepoint 保存点名字

*/

SET autocommit = 0;

START TRANSACTION;

DELETE FROM account WHERE id=25;
SAVEPOINT a;#设置保存点
DELETE FROM account WHERE id=25;

ROLLBACK TO a;#回滚到保存点


/*
视图
含义：虚拟表，和普通表一样使用，是通过表动态生成的数据，只保存了sql逻辑，不保存查询结果

应用场景：多个地方用到同样的查询结果
		  查询结果使用了较为复杂的sql语句

语法：
create view 视图名 as
查询语句

优点：
1，重用sql语句，简化操作，不必直到查询细节，
2，保护数据，提高安全性


*/

SELECT * FROM employees;

CREATE VIEW myv1
AS

SELECT last_name, department_name, job_title
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN jobs j ON j.job_id = e.job_id;


SELECT * FROM myv1;


SELECT AVG(salary), department_id, job_grades.`grade_level`
FROM employees
JOIN job_grades
ON salary BETWEEN job_grades.`lowest_sal` AND job_grades.`highest_sal`
GROUP BY department_id;

DROP VIEW myv2

CREATE VIEW myv2(ag,dep)
AS
SELECT AVG(salary), department_id
FROM employees
GROUP BY department_id;

CREATE VIEW myv2
AS
SELECT AVG(salary) ag, department_id
FROM employees
GROUP BY department_id;

SELECT myv2.ag, job_grades.`grade_level`
FROM myv2
JOIN job_grades
ON myv2.ag BETWEEN job_grades.`lowest_sal` AND job_grades.`highest_sal`



/*
视图的修改

方式一：
create or replace view 视图名
as
查询语句

方式二：
alter view 视图名
as
查询语句

*/

CREATE OR REPLACE VIEW myv2
AS
SELECT AVG(salary), job_id
FROM employees
GROUP BY job_id;

/*
视图删除

drop view 视图名1，视图名2,...
删除必须要有权限

*/
DROP VIEW myv1, myv2;

/*
查看视图
show create view myv3;
查看视图创建的语句和其他信息
*/


/*
视图的更新(更新视图中的数据)
没加权限时，可以增删改查

当视图具有以下类型是不能更新的
1，包含分组函数，distinct，group by，having，union或union all
2，常量视图
3，select中包含子查询
4，join
5，from一个不能更新的视图
6，where子句的子查询引用了from子句中的表

一般来说不推荐更改视图
*/

CREATE OR REPLACE VIEW myv1
AS

SELECT last_name, email
FROM employees;

SELECT * FROM myv1;

INSERT INTO myv1
VALUES
('pony', 'sdf@163.com');


SELECT *
FROM employees
WHERE last_name = 'pony';

UPDATE myv1 SET last_name = 'petter'
WHERE last_name = 'pony';

DELETE FROM myv1
WHERE last_name='pony';


/*
视图和表的对比
        创建语法        是否占用物理空间                 使用  
视图   create view          否(只是在内存中保存了逻辑)   增删改查，一般不能
表     create table         是(存盘了)                   增删改查


*/


/*
delete和truncate在使用事务时的区别
delete支持回滚
truncate不支持回滚
*/

SET autocommit = 0;
START TRANSACTION;
DELETE FROM acccount;
ROLLBACK;

SET autocommit = 0;
START TRANSACTION;
TRUNCATE TABLE account;
ROLLBACK;

/*
变量：

1，系统变量：
	全局变量：针对整个服务器
	会话变量


2，自定义变量：
	用户变量
	局部变量



*/

/*
系统变量：
变量由系统提供

使用语法：
1，查看所有系统变量
show global variables;
show session variables; = show variables;

2，查看满足条件的部分系统变量
show global/session variables like '%含有字符%';

3，查看某个系统变量的值
select @@【session.】系统变量名
select @@global. 系统变量

4，位某个系统变量赋值
set global/[session] 系统变量名 = 值
或者：
set @@global/[session].系统变=值

注意：全局级别变量要加global，会话级别时session，不写默认session

全局变量作用域：服务器每次启动将为所有全局变量赋初始值，针对所有的会话有效，但不能
跨重启


*/

SHOW GLOBAL VARIABLES;
SHOW GLOBAL VARIABLES LIKE '%char%';
SELECT @@global.autocommit;
SET @@global.autocommit = 0;

/*
会话变量
作用域只针对当前会话有效

*/

SHOW VARIABLES;
SHOW SESSION VARIABLES;
SHOW VARIABLES LIKE '%char%';
SHOW SESSION VARIABLES LIKE '%c%';
SELECT @@tx_isolation;
SELECT @@session.tx_isolation;
SET @@tx_isolation='read-uncommitted';
SET SESSION tx_isolation='read-uncommitted';



/*
自定义变量

说明：变量由用户自己定义
使用步骤：
1，声明，2，赋值，3，使用(查看，比较，运算)

作用域：等用于session的作用域，应用于
begin end里面 或begin end外面

声明格式：

1，声明时必须初始化
SET @用户变量名 = 值；
或
set @用户变量名:=值
或
select @用户变量名:=值

2，赋值
SET @用户变量名 = 值；
或
set @用户变量名:=值
或
select @用户变量名:=值
或
select 字段 into 变量名
from 表；

3，查看用户变量的值
select @用户变量名

*/


SET @myName = 'join';

SELECT COUNT(*) INTO @myName
FROM employees;


SELECT @myName;



/*
局部变量：

作用域：仅仅定义在begin end中有效

声明：
declare 变量名 类型(mysql中的常见类型)
declare 变量名 类型 default 值

SET 局部变量名 = 值；
或
set 局部变量名:=值
或
select @局部变量名:=值
或
select 字段 into 局部变量名
from 表；

使用
select 局部变量名

应用在 begin end中
而且只能是begin end中的第一句话


*/


/*

		作用域           定义和使用位置            语法
用户变量       当前会话           会话的任意位置           必须加@，不用限定类型
局部变量       begin end 中       begin end 中且第一句话   一般不用加@ 需要限定类型

*/

SET @m = 1;
SET @n = 2;
SET @sum = @m + @n;
SELECT @sum;

BEGIN
DECLARE m1 INT DEFAULT 1;
DECLARE n1 INT DEFAULT 2;
DECLARE msum INT;
SET msum=n1+m1;
SELECT msum;
END



/*
存储过程和函数：类似于java中的方法

好处：提高代码重用性，简化操作

存储过程：
	一组预先编译好的sql语句的集合，理解成批处理语句
	减少编译次数，减少了和数据库服务器的连接次数

语法：

一，创建语法
create procedure 存储过程名(参数列表)
begin

存储过程体：一组合法有效的sql语句

end

参数列表：
参数模式 参数名 参数类型
eg：IN stuNAme varchar(20)
1，IN：该参数徐奥调用方传入值，需要传入参数
2，OUT：该参数可以作为输出，该参数可以作为返回值
3，INOUT：该参数既可以作为输入也可以作为输出，该参数既要传入值，也可以返回值

存储过程体：
1，如果过程体只有一句话，begin end可以省略
2，存储过程体的每条sql语句的结尾要求必须加分号
3，存储过程的结尾可以使用dellimiter重新设置
语法：
DELIMITER 结束标记
案例：
DELIMITER $


二，调用语法：

CALL 存储过程名(实参列表);
*/


#1，空参列表
#案例，插入到表中五条记录

CREATE TABLE IF NOT EXISTS mytest(
	id INT PRIMARY KEY AUTO_INCREMENT,
	username VARCHAR(20),
	passwd VARCHAR(20)
);


INSERT INTO mytest VALUES
(NULL, 'Alice', '123'),
(NULL, 'Bob', '456');

SELECT * FROM mytest;


DELIMITER $
CREATE PROCEDURE myp1()
BEGIN
	INSERT INTO mytest(username,passwd)
	VALUES('join','000'),
	('rose','111'),
	('Linda','222');
END $

CALL myp1()$#在命令行中，之后也只能这么结尾了


DELETE FROM mytest
WHERE passwd = '000';

DROP PROCEDURE myp1;


#2，创建带in模式参数的存储过程

#根据女神名查询对应男神的信息
DELIMITER $
CREATE PROCEDURE myp2(IN beautyName VARCHAR(20)
BEGIN
	SELECT bo.*
	FROM boys bo
	RIGHT JOIN beauty b ON bo.id = b.boyfriend_id
	WHERE b.name=beautyName;
END$

CALL myp1('lisa')$


#创建过程实现用户是否登录成功
DELIMITER $
CREATE PROCEDURE myp3(IN username VARCHAR(20), IN passwd VARCHAR(20))
BEGIN
	DECLARE result INT DEFAULT 0;
	SELECT COUNT(*) INTO result 
	FROM mytest
	#where username = username#重名是就近原则
	WHERE mytest.username=username
	AND mytest.passwd = passwd
	SELECT IF(result > 0, '成功', '失败');

END $

CALL myp3('join','000');


#3，创建带out模式的存储过程
#例子：根据女神名，返回对应的男神名
CREATE PROCEDURE myp5(IN beautyName VARCHAR(20), OUT boyName VARCHAR(20))
BEGIN
	SELECT boys.boyName INTO boyName
	FROM boys
	INNER JOIN beauty
	ON boy.id = beauty.boyfriend_id
	WHERE b.name = beautyName
END $


SET @bName$
CALL myp5('小昭', @bName)$
SELECT @bName$

#多个out参数
CREATE PROCEDURE myp6(IN beautyName VARCHAR(20),
OUT boyName VARCHAR(20)，
OUT userId INT)
BEGIN
	SELECT boys.boyName, boys.userCP INTO boyName, userId
	FROM boys
	INNER JOIN beauty
	ON boy.id = beauty.boyfriend_id
	WHERE b.name = beautyName
END $


SET @bName$
SET @bId$
CALL myp5('小昭', @bName, @bId)$
SELECT @bName$, @bId$

#4,INOUT 模式
#传入a，b要求a，b翻倍并返回

CREATE PROCEDURE myp8(INOUT a INT, INOUT b INT)
BEGIN
	SET a = a * 2;
	SET b = b * 2;
END$

SET @userA = 1$
SET @userB = 2$

CALL myp8(@userA, @userB)$

SELECT @userA, @userB



/*


删除存储过程

drop procedure 存储过程名称

一次只能删一个

*/

DROP PROCEDURE p1;


#查看存储过程信息

DESC myp2;#错误的，desc只能看表

SHOW CREATE PROCEDURE myp1;


#存储过程无法修改，只能删除后写新的



/*

函数：与存储过程类似

区别：
1，存储过程可以有0个返回，也可以有多个返回
2，函数只能有一个返回
3，存储过程适合左批量的插入，批量更新
4，函数适合左数据操作后返回一个结果

创建语法

create function 函数名(参数列表) returns 返回类型
begin
	函数体
end

参数列表：
1，参数名
2，参数类型

函数体：
必须有return语句，如果没有会报错
return 值;

当函数体中只有一句话可以省略begin  end
使用delimiter语句作为设置结束的标记

delimiter $就可以了，如果写成$;那么结束符变为$;

调用语法：
select 函数名(参数列表)

*/

#1.无参有返回函数
#列子 返回员工个数
DELIMITER $
CREATE FUNCTION myf1() RETURNS INT
BEGIN
	DECLARE c INT;#定义变量
	SET c=1;
	SELECT COUNT(*) INTO c
	FROM employees;
	RETURN c;
END $

SELECT myf1()$


#2，有返回值有参函数

DELIMITER $
CREATE FUNCTION myf2(empName VARCHAR(20)) RETURNS DOUBLE
BEGIN
	SET @sal=0;
	SELECT salary INTO @sal
	FROM employees
	WHERE last_name = empName;
	RETURN @sal;#如果有两个值会报错
END $

SELECT myf2('test')$

#查看函数
DELIMITER ;
SHOW CREATE FUNCTION myf2;
#删除函数
DROP FUNCTION myf2;

#修改只能先删再重写


/*
流程控制结构

1，顺序结构

2，分支结构

2.1，if函数
select if(表达式1， 表达式2，表达式3)
若表达式1成立，返回2的值，否则返回3的值

2.2，case结构
情况一：用于实现等值判断(swtich)
case 变量/表达式/字段
when 要判断的值 then 要返回的值1或语句；
when 要判断的值 then 要返回的值2或语句；
...
else 要返回的值n或语句n；
end case;



情况二：用于实现区间判断(多重if)

case
when 要判断的值 then 要返回的值1或语句；
when 要判断的值 then 要返回的值2或语句；
...
else 要返回的值n或语句n；
end case;

case既可以作为表达式嵌套在其他语句中使用，可以放在任何地方
作为独立的语句只能放在begin end中

如果when中的值或者语句成立，则执行对应的then后语句
然后结束case，如果都不满足执行else中语句

else可以省略

如果没有else且所有条件都不满足则返回null



3，循环机构





*/

DELIMITER $
CREATE PROCEDURE myp6(IN input INT, OUT output VARCHAR(1))
BEGIN
	CASE
	WHEN input BETWEEN 90 AND 100 THEN SELECT 'A' INTO output;
	WHEN input BETWEEN 80 AND 90 THEN SELECT 'B' INTO output;
	ELSE SELECT 'C' INTO output;
	END CASE;
END $

SET @tempRes = ' ';
CALL myp6(91, @tempRes)$

SELECT @tempRes;


/*
if结构
功能：实现多重分支
语法：

if 条件1 then 语句1；
elseif 条件2 then 语句2；
...
else 语句n；
end if；

只能用在begin end中

*/

DELIMITER $
CREATE FUNCTION test_if(score INT) RETURNS CHAR
BEGIN
	IF score BETWEEN 90 AND 100 THEN RETURN 'A';
	ELSEIF score BETWEEN 80 AND 90 THEN RETURN 'B';
	ELSEIF score BETWEEN 70 AND 80 THEN RETURN 'C';
	ELSE RETURN 'D';
	END IF;
	
END $
#begin end搭配的delimiter必不可少



/*
循环结构
分类：
while、 loop， repeat

循环控制：
iterate类似于java 中的continue
leave类似于java 中的break

1。while语法
while 循环条件 do
	循环体；
end while

如果要搭配循环控制，要加上标签
标签：while 循环条件 do
	循环体；
end while 标签


2，loop死循环

[标签:] loop
	循环体
end loop [标签]

3，repeat，类似于java中的do while

[标签：]repeat
	循环体
until 结束循环条件
end loop [标签]

*/

#批量插入

DELIMITER $
CREATE PROCEDURE pro_while(IN insertCount INT)
BEGIN
	DECLARE i INT;
	SET i = 1;
	a:WHILE i < insertCount DO
		INSERT INTO mytest(username, passwd)
		VALUES(concat('rose',i), '666');
		IF i >= 20 THEN LEAVE a;
		END IF;
		SET i = i + 1;
		IF MOD(i , 2) != 0 THEN iterate a;
		END IF;
	END WHILE a;
END $ 

CALL pro_while(100);

#
create table stringcontent(
	id int primary key auto_increment,
	content varchar(20)
)

delimiter $
create procedure test_randstr(in insertCount int)
BEGIN
	declare i int default 1;
	declare str varchar(26) default 'abcdefghijklmnopqrstuvwxyz';
	declare startIndex int default 1;
	declare len int default 1;
	while i <= insertCount do
		
			
		set startIndex = floor(rand() * 26 + 1);
		set len = floor(rand() * (26 - startIndex + 1));
		insert into stringcontent values(null, substr(str, startIndex));
		set i = i + 1;
	end while;

end $