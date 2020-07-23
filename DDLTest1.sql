/*
DDL：数据定义语言

库和表的管理

一，库的管理
创建、修改、删除

二、表的管理
创建、修改、删除

创建：create
修改：alter
删除：drop


*/

#创建库
/*
语法：
create database 库名;


*/

CREATE DATABASE book;
#只能创建一次，重复创建会报错，因此加判断
CREATE DATABASE IF NOT EXISTS books;

#修改库
#已经将修改库名废弃了，因为不安全

#修改字符集
ALTER DATABASE books CHARACTER SET utf8mb4;

#库的删除
DROP DATABASE book;
#重复执行会报错，因此要判断
DROP DATABASE IF EXISTS book;



#创建表
/*

create table 表名(
	列名 列的类型[长度，约束],
	列名 列的类型[长度，约束],
	列名 列的类型[长度，约束],
	列名 列的类型[长度，约束],
	...
	列名 列的类型[长度，约束]
);


*/

CREATE TABLE book(
	id INT,#编号
	bName VARCHAR(20),#书名(最大长度20字符)
	price DOUBLE,
	authorId INT,#作者编号，便于分表
	publishDate DATETIME#出版日期
	
);


CREATE TABLE author(
	id INT,
	au_name VARCHAR(20),
	nation VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS author(
	id INT,
	au_name VARCHAR(20),
	nation VARCHAR(20)
);

#表的修改列的类型或约束，默认值
ALTER TABLE book MODIFY COLUMN pubDate TIMESTAMP;

#修改列名
ALTER TABLE book CHANGE COLUMN publishDate pubDate DATETIME;新名字的类型要带上

#添加列
ALTER TABLE author ADD COLUMN annual DOUBLE;#类型一定要带上

#删除列
ALTER TABLE author DROP COLUMN annual;

#修改表名
ALTER TABLE author RENAME TO book_author;

/*
表的修改：
alter table 表名 add|drop|modify|change column 列名[列类型，约束]

*/

#表的删除
DROP TABLE book_author;
DROP TABLE IF EXISTS book_author;#同理


#创建表的通用写法：

DROP DATABASE IF EXISTS 旧库名
CREATE DATABASE 新库名;

DROP TABLE IF EXISTS 旧表名
CREATE TABLE 表名();

ALTER TABLE author CONVERT TO CHARACTER SET utf8;


INSERT INTO author(id, au_name, nation) 
VALUES(1,'村上村树','日本'),
(2,'莫言','中国'),
(3,'冯唐','中国'),
(4,'金庸','中国');

SELECT * FROM author;

SHOW VARIABLES LIKE 'character%'


#表的复制，仅仅复制表结构
CREATE TABLE copy LIKE author;

#表的复制，结构加数据
CREATE TABLE copy1
SELECT * FROM author;

#表的部分，复制部分
CREATE TABLE copy2
SELECT id, au_name
FROM author
WHERE nation='中国';

#仅仅复制某些字段不要数据
CREATE TABLE copy3
SELECT id, au_name
FROM author
WHERE 0;


USE test;

CREATE TABLE dept1(
	id INT(7),
	NAME VARCHAR(25)
);

CREATE TABLE dept2
SELECT department_id, department_name
FROM my_employees.departments;#可以跨数据库

ALTER TABLE dept1 MODIFY COLUMN NAME VARCHAR(50);


/*
常见数据类型
数值型：
	整型：
		TinyInt: 1 byte
		SmallInt: 2 byte
		MediumInt: 3 byte
		Int\Integer: 4 byte
		BigInt: 8 byte
	小数：
		定点数
			dec(M, D)/decimal(M, D)
			最大表示和都double一样
		浮点数
			float(M, D) 4 byte
			double(M, D) 8 byte
		M,D可以省略，float和double根据传入数据变化
			decimal，M默认为10，D为0
		M表示小数和整数加起来的位数
		D表示保留小数点后的位数
		
		定点型精度较高，如果对数值精度要求较高可以考虑使用
		
字符型：
	较短的文本：
		char，varchar
		char(M), varchar(M)M表示允许最多的字符数
		char表示固定的字符，varchar表示可变长度的字符
		char比较耗费空间，但是效率高，varchar节省空间但是效率低
		char(M)的M可以省略默认为1
		varchar(M) 的M不可省略
	
		binary/varbinary类型：保存二进制字符串

		Enum类型：插入的数据只能是enum中规定好的内容，插入其他会失败
			1-255用1字节存，255-65535用2个字节存，最多65535
			不区分大小写

		Set类型：可以保存0-64个成员，与enum最大的区别是，set一次可以选多个成员
			enum只能选一个
			1-8成员 1 byte
			9-16成员 2 byte
			...
			33-64成员 8 byte
			不区分大小写
	
	较长的文本：
		text, blob（较长的二进制数据\图片视频）
日期：
	date: 4 byte 只能存日期 1000-01-01 到 9999-12-31
	datetime: 8 byte 1000-01-01 00:00:00 到9999-12-31 23：59：59
	timestamp 4 byte 19700101080001 到2038年的某个时刻
	time 3 byte -838：59：59 到838：59：59
	year 1 byte 1901 到2155

	datetime不受时区影响

	timestamp和实际时区有关，更能反应实际的日期，而datetime则只能反映出插入时的当地时区
	timestamp的属性受mysql版本和sqlmode的影响很大
	



选择类型的原则：越简单越好，能保存数值的类型越小越好
*/

#int：设置有符号和无符号
CREATE TABLE tab_int(
	t1 INT,#默认是有符号的
	t2 INT UNSIGNED,#无符号的
	t3 INT(7),#括号中的7代表宽度，不加关键字没效果
	t4 INT(7) ZEROFILL,#当宽度与该关键词搭配时，不够
			#的部分会用0左补齐，该关键字用了后为无符号数
	
	f1 FLOAT(5, 2),#一共可以允许5位数字，保留两位小数
	f2 DOUBLE(5, 2),
	f3 DECIMAL(5, 2)
);

INSERT INTO tab_int VALUES(-1);
INSERT INTO tab_int VALUES(-1,-1);
#负数超过了下限，所以第二列查询结果为0
#超过返回会报out of range异常，值取临界值
#不设置长度则默认长度为：无符号为10，有符号为11


#枚举型
CREATE TABLE tab_char(
	c1 ENUM('a','b','c')
)

INSERT INTO tab_char VALUES('a'),
('m'),('A');#m会插入失败因为超出了范围

CREATE TABLE tab_set(
	s1 SET('a','b','c','d')
);

INSERT INTO tab_set VALUES('a'),('a,b'),('a,b,c');

CREATE TABLE tab_date(
	t1 DATETIME,
	t2 TIMESTAMP
);

INSERT INTO tab_date VALUES(NOW(), NOW());

SHOW VARIABLES LIKE 'time_zone';

SET time_zone = '+9:00';#改时区



/*
常见约束

含义：一种限制，用于限制表中的数据，为了保证表中的数据的准确性和可靠性

create table 表名（
	字段名 字段类型 约束
）

六大约束：
NOT NULL: 非空，用于保证该字段的值不能为空
DEFAULT：默认值，用于保证字段有默认值
PRIMARY KEY:主见，用于保证字段的值具有唯一性，非空
UNIQUE：唯一性，但是可以为NULL
CHECK：检查约束[mysql不支持，语法不报错，没用]：sqlserver，oracle支持
FOREIGN KEY：外键约束，用于限制两个表的关系，用于保证该表的值必须来源于主表的关联值
	在从表添加外键约束用于引用主表中某列的值

添加约束的时机：创建表时，修改表时，都要保证在数据添加之前

约束分类：
	列级约束：
		六大约束都支持，但外键约束没有效果
	表级约束：
		除了非空、默认、其他都支持
	
	create table 表名(
		字段名 类型 列级约束，
		表级约束
	)

*/

CREATE DATABASE students;

USE students;


/*
列级约束：直接在字段名和类型后面追加约束类型即可

*/
CREATE TABLE IF NOT EXISTS stuinfo(
	id INT PRIMARY KEY,
	stuName VARCHAR(20) NOT NULL,
	gender CHAR(1) CHECK(gender='男' OR gender = '女'),
	seat INT UNIQUE,
	age INT DEFAULT  18,
	majorId INT REFERENCES major(id)
);

CREATE TABLE IF NOT EXISTS major(
	id INT PRIMARY KEY,
	majorName VARCHAR(20)

);

DESC stuinfo;

SHOW INDEX FROM stuinfo;#查看表中的索引

/*
添加表级约束
【constraint 约束名】(相当于重命名，可省略) 约束类型(字段名)

*/

DROP TABLE IF EXISTS stuinfo;
CREATE TABLE IF NOT EXISTS stuinfo(
	id INT,
	stuName VARCHAR(20),
	gender CHAR(1),
	seat INT,
	age INT,
	majorid INT,
	
	CONSTRAINT pk PRIMARY KEY(id),
	CONSTRAINT uq UNIQUE(seat),
	CONSTRAINT ck CHECK(gender='男' OR gender='女'),
	CONSTRAINT fk_stuinfo_major FOREIGN KEY(majorid) REFERENCES major(id)
);
#列级主键约束不可以重命名
#表级主键约束可以通过constrain重命名


#一般将外键约束写在表级约束的地方
#mysql列级外键没有效果，表级才有
CREATE TABLE IF NOT EXISTS stuinfo(
	id INT PRIMARY KEY,
	stuName VARCHAR(20) NOT NULL,
	gender CHAR(1) CHECK(gender='男' OR gender='女'),
	seat INT UNIQUE,
	age INT DEFAULT 18,
	majorid INT,
	CONSTRAINT fk_stuinfo_major FOREIGN KEY(majorid) REFERENCES major(id)
);

/*
primary key 与 unique

	保证唯一性    允许非空   一个表中可以有多少个       是否允许组合
主键	   是            否      至多有一个列标记为主键         是
唯一       是            是            可以有多个列             是


*/

CREATE TABLE IF NOT EXISTS stuinfo(
	id INT,
	stuName VARCHAR(20) UNIQUE NOT NULL,#可以加多个约束用空格即可没有顺序要求
	gender CHAR(1),
	seat INT,
	age INT,
	majorid INT,
	
	CONSTRAINT pk PRIMARY KEY(id, stuName),#两者组合为主键
	CONSTRAINT uq UNIQUE(seat, age),
	CONSTRAINT ck CHECK(gender='男' OR gender='女'),
	CONSTRAINT fk_stuinfo_major FOREIGN KEY(majorid) REFERENCES major(id)
);
#组合主键只需要整体不重复即可，部分可以重复
#组合唯一键也可以
#不推荐使用组合键

/*
外键：
1，要求在从表中设置外键关系
2，要求从表在主表中的类型一致或兼容，名称没有要求
3，要求主表中的关联列必须是一个key(主键或唯一键，一般是主键)
4，插入数据是要先插入主表的数据再插入从表
5，删除数据应该先删除从表再删除主表
*/



#修改表时添加约束
ALTER TABLE stuinfo MODIFY COLUMN stuName VARCHAR(20) NOT NULL;

ALTER TABLE stuinfo MODIFY COLUMN age INT DEFAULT 19;

ALTER TABLE stuinfo MODIFY COLUMN id INT PRIMARY KEY;

ALTER TABLE stuinfo ADD PRIMARY KEY(id)#表级约束的修改

ALTER TABLE stuinfo ADD [constrain for_name] FOREIGN KEY(majorid) REFERENCES major(id);


/*
添加列级约束
alter table 表名 modify column 字段名 字段类型 新约束

添加表级约束
alter table 表名 add [constrain 约束名] 约束类型(字段名) [外键引用]

*/



#修改表时删除约束

ALTER TABLE stuinfo MODIFY COLUMN stuName VARCHAR(20) NULL;
ALTER TABLE stuinfo MODIFY COLUMN id INT;
#不写默认即可
ALTER TABLE stuinfo DROP PRIMARY KEY;#表级删除
ALTER TABLE stuinfo DROP INDEX#删除唯一键

ALTER TABLE stuinfo DROP FOREIGN KEY 外键名;

/*
		位置          支持的约束类型                    是否可以起约束别名
列级约束：    列的后面        语法都支持，但是外键没有效果          不可以
表级约束：    所有列下面      默认和非空不支持，其他支持            可以，但是主键没有效果


*/



/*
标识列（自增长列）
含义：可以不手动插入值，系统提供默认的序列值


*/

CREATE TABLE IF NOT EXISTS tab_identity(
	id INT PRIMARY KEY,
	NAME VARCHAR(20)
)


INSERT INTO tab_identity VALUES
(NULL,'join');
#对于自增长列，插入null即可

ALTER TABLE tab_identity DROP PRIMARY KEY;

ALTER TABLE tab_identity MODIFY COLUMN id INT PRIMARY KEY AUTO_INCREMENT;

TRUNCATE TABLE tab_identity;

SELECT * FROM tab_identity;

SHOW VARIABLES LIKE '%auto_increment%';

SET auto_increment_increment = 3;#设置自增不长
#mysql不支持设置自增起始值

/*
标识列使用问题：
1，标识列必须是一个key，不一定非要是主键，唯一，外键都可以
2，一个表中最多只能有一个自增长列
3，int, float, double等数值型可以添加标识列
4，标识列可以设置增长步长，可以通过手动插入设置标识列
*/

#删除标识列
ALTER TABLE tab_identity MODIFY COLUMN id INT;

