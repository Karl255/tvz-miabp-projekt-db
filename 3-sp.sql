-- SP: Kreiraj novog korisnika. Treba hashirati plaintext lozinku.
CREATE PROCEDURE Sifrarnik.InsertUser
	@username VARCHAR(32),
	@password VARCHAR(32),
	@organisationId INT
AS
BEGIN
	INSERT INTO Sifrarnik."User" (username, passwordHash) VALUES (@username, HASHBYTES('SHA2_256', @password));

	DECLARE @userId INT = SCOPE_IDENTITY();

	INSERT INTO Sifrarnik."Group" (name, type, organisationId) VALUES (CONCAT(@username, ' - Group'),'USER',@organisationId);

	DECLARE @groupId INT = SCOPE_IDENTITY();

	INSERT INTO Sifrarnik."GroupUser" (userId, groupId) VALUES (@userId, @groupId);
	INSERT INTO Sifrarnik."GroupUser" (userId, groupId) SELECT @userId, g.organisationId FROM Sifrarnik."Group" g WHERE g.organisationId = @organisationId AND g.type = 'ORGANISATION_ALL';
END
GO
	

-- SP: Dodaj permission za usera.
CREATE PROCEDURE Sifrarnik.AddUserPermission
	@userId INT,
	@folderId INT,
	@permissionLevel VARCHAR(6)
AS
BEGIN
	DECLARE @userGroupId INT = (SELECT g.id FROM Sifrarnik."Group" g 
									INNER JOIN Sifrarnik.GroupUser gu ON g.id = gu.groupId
									INNER JOIN Sifrarnik."User" u on u.id = gu.userId
									WHERE u.id = @userId AND g.type = 'USER');
	
	INSERT INTO "Io".Permission (groupId, folderId, level) VALUES (@userGroupId, @folderId, @permissionLevel);
END
GO

-- SP: Dodaj permission za grupu.
CREATE PROCEDURE Sifrarnik.AddGroupPermission
	@groupId INT,
	@folderId INT,
	@permissionLevel VARCHAR(6)
AS
BEGIN
	INSERT INTO "Io".Permission (groupId, folderId, level) VALUES (@groupId, @folderId, @permissionLevel);
END
GO

-- Funkcije ------------------------------------------------------
-- FN: Dohvaćanje svih usera u grupi
CREATE FUNCTION Sifrarnik.fn_Group_get_Users (@groupId INT)
RETURNS TABLE AS
RETURN
(
	SELECT u.id as userId, u.username FROM Sifrarnik."User" u
	INNER JOIN Sifrarnik.GroupUser gu ON gu.userId = u.id
	WHERE gu.groupId = @groupId
)
GO

-- FN: Dohvaćanje putanje nekog foldera
CREATE FUNCTION "Io".fn_Folder_get_Path (@folderId INT)
RETURNS VARCHAR(255) AS
BEGIN
	DECLARE @path VARCHAR(255) = (SELECT CONCAT(name,'/') FROM "Io".Folder WHERE id = @folderId);
	DECLARE @currentFolderId INT = @folderId;
	DECLARE @parentFolder INT;

	WHILE @currentFolderId IS NOT NULL
	BEGIN
		SET @parentFolder = (SELECT parentFolderId FROM "Io".Folder WHERE id = @currentFolderId);

		IF @parentFolder IS NOT NULL
			SELECT @path = CONCAT(f.name, '/', @path), @currentFolderId = f.id FROM "Io".Folder f WHERE f.id = @parentFolder;
		ELSE
			BREAK
	END
	RETURN @path;
END
GO

-- FN: Dohvačanje bilješke s dodatnim info
CREATE FUNCTION "Io".fn_Note_get_Info(@noteId INT)
RETURNS TABLE AS
RETURN
(
	SELECT n.id, n.name, n.content, COALESCE(STRING_AGG(t.name, ', '),'-') as tags, "Io".fn_Folder_get_Path(f.id) as "path" FROM "Io".Note n
	LEFT JOIN "Io".TaggedNote tn ON n.id = tn.noteId
	LEFT JOIN "Io".Tag t ON t.id = tn.tagId
	INNER JOIN "Io".Folder f ON n.folderId = f.id
	WHERE n.id = @noteId
	GROUP BY n.Id, n.name, n.content, f.id
)
GO

-- FN: Dobivanje permissiona korisnika prema folderu.
	-- ulaz: folderId, userId
	-- izlaz: permission level ('READ', 'EDIT', 'MANAGE')
CREATE FUNCTION "Io".fn_Folder_get_UserPermission(@userId INT, @folderId INT)
RETURNS VARCHAR (6) AS
BEGIN
	DECLARE @permissionLevel VARCHAR(6);
	DECLARE @currentFolder INT = @folderId;
	WHILE @permissionLevel IS NULL AND @currentFolder IS NOT NULL
	BEGIN
		SET @permissionLevel = (
		SELECT TOP (1) p.level as PermissionLevel FROM "Io".Permission p
		INNER JOIN "Io".Folder f on f.id = p.folderId
		INNER JOIN Sifrarnik."Group" g on g.id = p.groupId
		INNER JOIN Sifrarnik.GroupUser gu on g.id = gu.groupId
		WHERE gu.userId = @userId AND f.id = @currentFolder
		ORDER BY 
		CASE p.level
			WHEN 'VIEW' THEN 1
			WHEN 'EDIT' THEN 2
			WHEN 'MANAGE' THEN 3
		END DESC
		);
		SET @currentFolder = (SELECT parentFolderId FROM "Io".Folder WHERE id = @currentFolder);
	END
	RETURN @permissionLevel;		
END
GO

-- FN: Prikaži sadržaj foldera (folderId može biti NULL). User mora imati bilokoji permission.
CREATE FUNCTION "Io".fn_Folder_get_Content(@folderId INT)
RETURNS TABLE AS
RETURN
(
	SELECT id as itemId, name, 'Folder' as "type" FROM "Io".Folder WHERE parentFolderId = @folderId
	UNION
	SELECT id, name, 'Note' as "type" FROM "Io".Note WHERE folderId = @folderId
)
GO