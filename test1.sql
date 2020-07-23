SHOW DATABASES;
/*

一，MySQL常见命令：
1，启动，退出，看版本号：在cmd下
        启动：mysql [-h 主机名 -P 端口号] -u 用户名 -p 密码
        退出：exit; quit; ctrl+c
        看版本：mysql --version或者mysql -V
2，查看所有数据库：show databases;
3，打开指定库：use 库名;
4，查看当前库所有表：show tables;
5，查看其他库表：show tables from 库名;
6，查看表结构：desc 表名;

二，mysql语法规范：
1，不区分大小写，但是建议关键字大写，表名，列名小写
2，每条命令最好用；结尾
3，每条命令可以根据需要缩进或换行
4，注释：单行#或者--，多行 /* test */


*/