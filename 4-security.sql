-- CHECK_POLICY = OFF is used only for development purpose and should never be used in production.

CREATE USER DB_Admin WITHOUT LOGIN;
CREATE ROLE DB_Administratori; 
ALTER ROLE DB_Administratori ADD MEMBER DB_Admin;
ALTER ROLE db_owner ADD MEMBER DB_Administratori; -- full access

-- users
CREATE LOGIN User_Matej WITH PASSWORD = N'matejpass', DEFAULT_DATABASE = master, CHECK_POLICY = OFF;
CREATE USER User_Matej FOR LOGIN User_Matej;
CREATE LOGIN User_Karlo WITH PASSWORD = N'karlopass', DEFAULT_DATABASE = master, CHECK_POLICY = OFF;
CREATE USER User_Karlo FOR LOGIN User_Karlo;
CREATE LOGIN User_Pero WITH PASSWORD = N'peropass', DEFAULT_DATABASE = master, CHECK_POLICY = OFF;
CREATE USER User_Pero FOR LOGIN User_Pero;

-- admins
GRANT IMPERSONATE ON USER::DB_Admin TO User_Matej;
GRANT IMPERSONATE ON USER::DB_Admin TO User_Karlo;

-- app role
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
