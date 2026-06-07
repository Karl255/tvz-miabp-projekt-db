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
EXEC Sifrarnik.InsertUser @username = 'encryptedUser', @password = 'encryptpass', @email = 'encrypt@test.com', @organisationId = 1, @dateOfBirth = '2002-06-16';
SELECT * FROM Sifrarnik."User" WHERE username = 'encryptedUser';
EXEC Sifrarnik.LoginUser @username = 'encryptedUser', @password = 'encryptpass';

-- Dinamičko maskiranje
-- Maskirano
EXECUTE AS USER = 'User_Masked';

SELECT CURRENT_USER;

SELECT * FROM Sifrarnik."User";
SELECT * FROM "Io".Note;

REVERT;

-- Nemaskirano
EXECUTE AS USER = 'User_Unmasked';

SELECT CURRENT_USER;

SELECT * FROM Sifrarnik."User";
SELECT * FROM "Io".Note;

REVERT;

-- etc

SELECT * FROM Sifrarnik.[User];
SELECT * FROM "Io".Permission;
SELECT * FROM "Io".Folder;
SELECT "Io".fn_GetFolderPath(11);
SELECT * FROM "Io".Note;
SELECT n.id, CONCAT("Io".fn_GetFolderPath(n.folderId), '/', n.name), n.content FROM "Io".Note n;

INSERT INTO "Io".Note (name, content, folderId) VALUES 
(
	'Test note', 
	'Lorem ipsum, dolor sit amet consectetur adipisicing elit. Reiciendis, quidem. Quas aperiam explicabo, unde eum atque provident officia quos commodi. Quo sit assumenda quidem aut possimus minus accusamus saepe culpa.',
	1
);

EXEC Sifrarnik.AddUserPermission @userId = 7, @folderId = 0, @permissionLevel = 'MANAGE';
