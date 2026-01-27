-- CHECK_POLICY = OFF is used only for development purpose and should never be used in production.

CREATE USER DB_Admin WITHOUT LOGIN;

CREATE LOGIN Admin_Matej WITH PASSWORD = N'matejpass', DEFAULT_DATABASE=master, CHECK_POLICY = OFF;
CREATE USER Admin_Matej FOR LOGIN Admin_Matej;
GRANT IMPERSONATE ON USER::DB_Admin TO Admin_Matej;

CREATE LOGIN Admin_Karlo WITH PASSWORD = N'karlopass', DEFAULT_DATABASE=master, CHECK_POLICY = OFF;
CREATE USER Admin_Karlo FOR LOGIN Admin_Karlo;
GRANT IMPERSONATE ON USER::DB_Admin TO Admin_Karlo;

CREATE ROLE DB_Administratori; 
ALTER ROLE DB_Administratori ADD MEMBER DB_Admin;
ALTER ROLE db_owner ADD MEMBER DB_Administratori;
