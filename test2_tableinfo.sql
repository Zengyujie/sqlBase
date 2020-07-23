/*
employee表：全部元素可以空

first_name, varchar(20)		名
last_name, varchar(20)          姓
email, varchar(20)              邮箱
phone_number, varchar(20)       电话
job_id, varchar(20)             工号
salary, double(10, 2)           工资
commission_pet, double(4, 2)    奖金率
manager_id, int(6)              经理编号
department_id, int(4)           部门编号
hiredate, datetime              入职时间

departments表：
department_id int(4)            部门编号
department_name varchar(20)     部门名称
manager_id int(6)               部门领导编号
location_id int(4)              位置编号

locations表
localtion_id int(11)            位置编号
street_adress varchar(40)       街道
postal_code varchar(12)         邮编
city varchar(30)                城市
state_province varchar(25)      州
country_id varchar(2)           国家


jobs表：
job_id varchar(10)              工号
job_title varchar(35)           工名称
min_salary int(8)               最低工资
max_salary int(8)               最高工资



*/