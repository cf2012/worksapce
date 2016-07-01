CREATE DATABASE `${tpl_database_name}`;
CREATE USER '${tpl_user_name}'@'%' IDENTIFIED BY '${tpl_passswd}';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, REFERENCES, INDEX, ALTER, CREATE TEMPORARY TABLES, LOCK TABLES, CREATE VIEW, SHOW VIEW, CREATE ROUTINE, ALTER ROUTINE, EXECUTE, EVENT, TRIGGER ON `${tpl_database_name}`.* TO '${tpl_user_name}'@'%';
GRANT SELECT ON `information\_schema`.* TO '${tpl_user_name}'@'%';
GRANT SELECT ON `mysql`.* TO '${tpl_user_name}'@'%';
GRANT SELECT ON `performance\_schema`.* TO '${tpl_user_name}'@'%';

flush privileges ;
