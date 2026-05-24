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
EXECUTE AS USER = 'User_Masked';
EXECUTE AS USER = 'User_Unmasked';

SELECT CURRENT_USER;

SELECT * FROM Sifrarnik."User";
SELECT * FROM "Io".Note;

REVERT;