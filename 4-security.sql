-- CHECK_POLICY = OFF is used only for development purpose and should never be used in production.

CREATE USER DB_Admin WITHOUT LOGIN;

CREATE LOGIN Admin_Matej WITH PASSWORD = N'matejpass', DEFAULT_DATABASE = master, CHECK_POLICY = OFF;
CREATE USER Admin_Matej FOR LOGIN Admin_Matej;
GRANT IMPERSONATE ON USER::DB_Admin TO Admin_Matej;

CREATE LOGIN Admin_Karlo WITH PASSWORD = N'karlopass', DEFAULT_DATABASE = master, CHECK_POLICY = OFF;
CREATE USER Admin_Karlo FOR LOGIN Admin_Karlo;
GRANT IMPERSONATE ON USER::DB_Admin TO Admin_Karlo;

CREATE ROLE DB_Administratori; 
ALTER ROLE DB_Administratori ADD MEMBER DB_Admin;
ALTER ROLE db_owner ADD MEMBER DB_Administratori;

-- app role

CREATE LOGIN APP_Login WITH PASSWORD = N'apppass', DEFAULT_DATABASE = master, CHECK_POLICY = OFF;
CREATE USER APP_Login FOR LOGIN APP_Login;
CREATE APPLICATION ROLE APP_Uloga WITH PASSWORD = N'-U)8-zpQ&}^9oS4+hu7IC/@c;=\}.O,i'; -- sp_setapprole

-- with such permissions we limit our ability to use an app-side database migrations
GRANT SELECT ON SCHEMA::Sifrarnik TO APP_Uloga;
GRANT INSERT ON SCHEMA::Sifrarnik TO APP_Uloga;
GRANT UPDATE ON SCHEMA::Sifrarnik TO APP_Uloga;
GRANT DELETE ON SCHEMA::Sifrarnik TO APP_Uloga;
DENY DELETE ON OBJECT::Sifrarnik.Organisation TO APP_Uloga;
GRANT EXECUTE ON SCHEMA::Io TO APP_Uloga;

GRANT SELECT ON SCHEMA::Io TO APP_Uloga;
GRANT INSERT ON SCHEMA::Io TO APP_Uloga;
GRANT UPDATE ON SCHEMA::Io TO APP_Uloga;
GRANT DELETE ON SCHEMA::Io TO APP_Uloga;
GRANT EXECUTE ON SCHEMA::Io TO APP_Uloga;
