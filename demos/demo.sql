SELECT * FROM Sifrarnik.Organisation;

SELECT * FROM Sifrarnik."User";
SELECT * FROM Sifrarnik."Group";

-- Users in Groups
SELECT * FROM Sifrarnik.fn_GetGroupUsers(2); -- TVZ
SELECT * FROM Sifrarnik.fn_GetGroupUsers(9); -- TVZ - Admin
SELECT * FROM Sifrarnik.fn_GetGroupUsers(11); -- TVZ - Referada

SELECT * FROM Sifrarnik.fn_GetUserGroups(3); -- admin user

-- Folder & Notes
SELECT * FROM "Io".Folder; -- All folders
SELECT * FROM "Io".fn_GetFolderContent(11); -- Folder content
SELECT * FROM "Io".fn_GetNoteInfo(3); -- Notes

-- User permissions
SELECT "Io".fn_GetFolderUserPermission(6, 11); -- userId, folderId

-- Enkripcija
EXEC Sifrarnik.InsertUser @username = 'encryptedUser', @password = 'encryptpass', @email = 'encrypt@test.com', @organisationId = 1;
SELECT * FROM Sifrarnik."User" WHERE username = 'encryptedUser';
EXEC Sifrarnik.LoginUser @username = 'encryptedUser', @password = 'encryptpass';

-- Dinamičko maskiranje
ALTER TABLE Sifrarnik."User" ALTER COLUMN dateOfBirth ADD MASKED WITH(FUNCTION = 'default()');
ALTER TABLE "Io".Note ALTER COLUMN content ADD MASKED WITH(FUNCTION = 'partial(1,"...",0)');

CREATE USER test_user WITHOUT LOGIN;
GRANT SELECT ON Sifrarnik."User" TO test_user;
GRANT SELECT ON "Io".Note TO test_user;

EXECUTE AS USER = 'test_user';

SELECT CURRENT_USER;

SELECT * FROM Sifrarnik."User";
SELECT * FROM "Io".Note;

REVERT;