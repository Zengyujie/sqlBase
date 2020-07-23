/*
DML：数据操作语言：

插入：insert

修改：update

删除：delete

*/

#插入语句
/*
方式一：

语法：

insert into 表名(列名1，列名2，...)
values(值1，值2，...)

值与列明一一对应
插入的值的类型要与列定义的类型一致或兼容
不可以为null的值必须插入值
可以为空的方法可以按如下操作：
1，加入NULL
2，省略列名和值

列名的顺序可变，值一一对应即可
列数和值数必须匹配
可以省略列名，默认所有列，顺序与表一致
*/

INSERT INTO beauty(id, NAME, sex, borndate, phone,photo, boyfriend_id)
VALUES(13,'唐艺昕','女','1990-4-23', '189888888', NULL, 2);

INSERT INTO beauty(id, NAME, sex, borndate, phone, boyfriend_id)
VALUES(14,'金星','女','1990-4-23', '189888888', 2);

INSERT INTO beauty(id, NAME, sex, phone)
VALUES(15,'娜扎','女','189888888');

INSERT INTO beauty(NAME, sex, id, phone)
VALUES('蒋欣','女',16, '189888888');


INSERT INTO beauty
VALUES(18,'张飞','女','490-4-23', '189888888', NULL, 2);


SELECT * FROM beauty;


/*
插入
方式二：

insert into 表名
set 列名=值，列名=值...


*/

INSERT INTO beauty
SET id=17, NAME='刘涛', phone='999'; 



/*
两种方法优劣：

1，方式一支持插入多行
2，方式一支持子查询，将查询的结果集通过insert插入表中



*/


INSERT INTO beauty(id, NAME, sex, phone)
VALUES(19,'娜扎1','女','189888888'),
(20,'娜扎2','女','189888888'),
(21,'娜扎3','女','189888888'),
(22,'娜扎4','女','189888888'),
(23,'娜扎5','女','189888888');


INSERT INTO beauty(id, NAME, phone)
SELECT 27, '孟佳', '2334354'
UNION
SELECT id+100, boys.`boyName`, '123345'
FROM boys;



/*
修改语句：

语法：
1，修改单表记录
	update 表名
	set 列 = 新值, 列 = 新值,...
	where 筛选条件

2，修改多表记录
 92语法 update 表1 别名，表2 别名
	set 列=值，...
	where 连接条件 and 筛选条件
	
 99语法：update 表1 别名
	 inner|left|right join 表2 别名
	 on 连接条件
	 set 列=值
	 where 筛选条件


*/

UPDATE beauty
SET phone='13800'
WHERE NAME LIKE '%唐%'


#修改张无忌女朋友的手机号
UPDATE beauty AS b
JOIN boys AS bo
ON b.boyfriend_id = bo.id
SET b.phone='777'
WHERE bo.boyName='张无忌';


/*
删除语句
方式一：
单表删除：
delete from 表名 where 条件
一次删一行

多表删除：

sql 92:
	delete 表1的别名,表2的别名..要删哪个表就写哪个，全部写就一起删
	from 表1 别名，表2 别名
	where 连接条件
	and 筛选条件

sql99：
	delete 表1的别名,表2的别名..要删哪个表就写哪个，全部写就一起删
	from 表1 别名
	inner|left|right join 表2
	on 连接条件
	where 筛选条件
	

方式二：truncate
truncate table 表名
删一个表，清空数据
truncate不能加条件

truncate效率比delete高一点
加入要删除的表中有自增长列，再插入数据，自增长值从断点开始
truncate删除删除后再插入从1开始

truncate删除没有返回值
delete删除有返回值

truncate删除不能回滚，delete删除可以回滚


*/

DELETE FROM beauty
WHERE NAME LIKE '%孟佳%';

DELETE beauty
FROM beauty
JOIN boys
ON beauty.`boyfriend_id` = boys.`id`
WHERE boys.`boyName` LIKE '%张无忌%';

DELETE be, b
FROM beauty be
JOIN boys b
ON be.`boyfriend_id` = b.`id`
WHERE b.`boyName`='%黄晓明%';



TRUNCATE TABLE boys;
