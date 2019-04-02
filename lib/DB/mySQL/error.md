# 错误记录


> ERROR 1290 (HY000): The MySQL server is running with the --skip-grant-tables option so it cannot execute this statemen

flush privileges;

> ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'password('123')' at line 1

alter user 'root'@'localhost' identified by '123';
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '123'

> ERROR 2002 (HY000): Can't connect to local MySQL server through socket '/tmp/mysql.sock' (2)
