SELECT * FROM Sifrarnik.Organisation;

SELECT * FROM Sifrarnik."User";
SELECT * FROM Sifrarnik."Group";

-- Users in Groups
SELECT * FROM Sifrarnik.fn_Group_get_Users(2); -- TVZ - Group
SELECT * FROM Sifrarnik.fn_Group_get_Users(9); -- TVZ - Admin
SELECT * FROM Sifrarnik.fn_Group_get_Users(11); -- TVZ - Referada

SELECT * FROM Sifrarnik.fn_User_get_Groups(3); -- admin user

-- Folder & Notes
SELECT * FROM "Io".Folder; -- All folders
SELECT * FROM "Io".fn_Folder_get_Content(11); -- Folder content
SELECT * FROM "Io".fn_Note_get_Info(3); -- Notes

-- User permissions
SELECT "Io".fn_Folder_get_UserPermission(6, 11); -- userId, folderId

-- Enkripcija
EXEC Sifrarnik.InsertUser @username = 'encryptedUser', @password = 'encryptpass', @email = 'encrypt@test.com', @organisationId = 1;
SELECT * FROM Sifrarnik."User" WHERE username = 'encryptedUser';
EXEC Sifrarnik.UserLogin @username = 'encryptedUser', @password = 'encryptpass';