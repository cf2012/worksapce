create user ${username}    identified by "${password}"
  default tablespace ${tablespace}
  temporary tablespace TEMP
  profile DEFAULT;
-- Grant/Revoke role privileges
grant connect to ${username};
grant resource to ${username} ;
grant select_catalog_role to ${username};
-- Grant/Revoke system privileges
grant create any synonym to ${username};
grant create job to ${username};
grant create procedure to ${username};
grant create synonym to ${username};
grant create view to ${username};
grant debug connect session to ${username};
grant execute any procedure to ${username};
grant select any transaction to ${username};
grant unlimited tablespace to ${username};

-- debug 存储过程的权限
grant debug any procedure to ${username};
-- 值得商榷. 赋这项权限后, 可以查询到其他用户的表了.
grant select any table to ${username};
