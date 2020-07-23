SELECT * FROM customers;

INSERT INTO customers(NAME, email, birth)
VALUES
('张飞','zf@gmail.com',STR_TO_DATE('1990-02-24','%Y-%m-%d'));


SELECT * FROM `order`;

CREATE TABLE goods(
	id INT PRIMARY KEY AUTO_INCREMENT,
	good_name VARCHAR(20)
);

DROP TABLE goods;

TRUNCATE TABLE goods;

SELECT * FROM goods;

DELIMITER $
CREATE FUNCTION insertGoods(insertCount INT) RETURNS INT
BEGIN
	DECLARE i INT DEFAULT 0;
	WHILE i < insertCount DO
		INSERT INTO goods(good_name)
		VALUES('test');
		SET i = i + 1;
	END WHILE;
	RETURN i;
END $

DROP FUNCTION insertGoods;

SELECT insertGoods(100);


SELECT * FROM user_table;

#创建用户
CREATE USER tom IDENTIFIED BY '12345612';

#赋予权限

#授予通过网络登陆，赋予所有权限
GRANT  ALL PRIVILEGES ON *.* TO tom@'%' IDENTIFIED BY '12345612';

#本地命令行登陆，授予某个数据库下所有表的增删改查权限
GRANT SELECT, INSERT, DELETE, UPDATE ON test.* TO tom@localhost IDENTIFIED BY '12345612';


