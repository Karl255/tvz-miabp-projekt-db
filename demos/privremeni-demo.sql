SELECT * FROM Sifrarnik."User";
SELECT * FROM Sifrarnik."Group";

-- Users in Groups
-- TVZ - Group
SELECT * FROM Sifrarnik.fn_Group_get_Users(2);
-- TVZ - Admin
SELECT * FROM Sifrarnik.fn_Group_get_Users(9);
-- TVZ - Referada
SELECT * FROM Sifrarnik.fn_Group_get_Users(11);


-- Folder & Notes
-- All folders
SELECT * FROM "Io".Folder;
-- Folder content
SELECT * FROM "Io".fn_Folder_get_Content(11);
-- Notes
SELECT * FROM "Io".fn_Note_get_Info(3);

-- User permissions
SELECT "Io".fn_Folder_get_UserPermission(6, 11); -- userId, folderId