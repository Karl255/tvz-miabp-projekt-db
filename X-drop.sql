-- drops should be written in reverse order of their create counterparts

-- 4-security

DROP USER IF EXISTS User_Pero;
DROP USER IF EXISTS User_Karlo;
DROP USER IF EXISTS User_Matej;
DROP USER IF EXISTS DB_Admin;

IF DATABASE_PRINCIPAL_ID('APP_Uloga') IS NOT NULL
	DROP APPLICATION ROLE APP_Uloga;

IF DATABASE_PRINCIPAL_ID('DB_Administratori') IS NOT NULL
	DROP ROLE DB_Administratori;

IF EXISTS (SELECT name FROM master.sys.server_principals WHERE name = 'User_Pero') DROP LOGIN User_Pero;
IF EXISTS (SELECT name FROM master.sys.server_principals WHERE name = 'User_Karlo') DROP LOGIN User_Karlo;
IF EXISTS (SELECT name FROM master.sys.server_principals WHERE name = 'User_Matej') DROP LOGIN User_Matej;

-- 3-sp

-- 2-ddl

DROP TABLE IF EXISTS Io.TaggedNote;
DROP TABLE IF EXISTS Io.Tag;
DROP TABLE IF EXISTS Io.LoggedReminder;
DROP TABLE IF EXISTS Io.Reminder;
DROP TABLE IF EXISTS Io.Note;
DROP TABLE IF EXISTS Io.Permission;
DROP TABLE IF EXISTS Io.Folder;
DROP TABLE IF EXISTS Sifrarnik.GroupUser;
DROP TABLE IF EXISTS Sifrarnik."User";
DROP TABLE IF EXISTS Sifrarnik."Group";
DROP TABLE IF EXISTS Sifrarnik.Organisation;

-- 1-db

DROP SCHEMA IF EXISTS Io;
DROP SCHEMA IF EXISTS Sifrarnik;
