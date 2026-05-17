-- Tables
CREATE TABLE Sifrarnik.Organisation (
    id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(100) NOT NULL,
	INDEX IX_name (name)
);

CREATE TABLE Sifrarnik."Group" (
    id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(50) NOT NULL,
    -- 'ORGANISATION_ALL', 'USER', 'CUSTOM'
    type VARCHAR(16) NOT NULL,
    organisationId INT NOT NULL,
    FOREIGN KEY (organisationId) REFERENCES Sifrarnik.Organisation(id),
    CONSTRAINT ck_GroupType
    CHECK (type in ('ORGANISATION_ALL', 'USER', 'CUSTOM'))
);

CREATE TABLE Sifrarnik."User" (
    id INT PRIMARY KEY IDENTITY(1,1),
    username VARCHAR(32) NOT NULL,
    dateOfBirth DATE NOT NULL,
    -- SHA2-256
    passwordHash VARBINARY(256) NOT NULL,
    email VARBINARY(MAX) NOT NULL,
	INDEX IX_username (username)
);

CREATE TABLE Sifrarnik.GroupUser (
	userId INT NOT NULL,
	groupId INT NOT NULL,
	PRIMARY KEY (userId, groupId),
	FOREIGN KEY (userId) REFERENCES Sifrarnik."User"(id) ON DELETE CASCADE,
	FOREIGN KEY (groupId) REFERENCES Sifrarnik."Group"(id) ON DELETE CASCADE
)

CREATE TABLE Io.Folder (
    id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(50) NOT NULL,
	parentFolderId INT NULL,
	FOREIGN KEY (parentFolderId) REFERENCES Io.Folder(id)
);

CREATE TABLE Io.Permission (
    groupId INT NOT NULL,
    folderId INT NOT NULL,
    -- 'VIEW', 'EDIT', 'MANAGE'
    level VARCHAR(6) NOT NULL,
	PRIMARY KEY (groupId, folderId),
	FOREIGN KEY (groupId) REFERENCES Sifrarnik."Group"(id) ON DELETE CASCADE,
	FOREIGN KEY (folderId) REFERENCES Io.Folder(id) ON DELETE CASCADE,
    CONSTRAINT ck_PermissionLevel
    CHECK (level in('VIEW', 'EDIT', 'MANAGE'))
);

CREATE TABLE Io.Note (
    id INT PRIMARY KEY IDENTITY(1,1),  
    name VARCHAR(50) NOT NULL,
	content VARCHAR(MAX) NOT NULL,
	folderId INT NOT NULL,
	FOREIGN KEY (folderId) REFERENCES Io.Folder(id),
	UNIQUE NONCLUSTERED (name, folderId)
);

CREATE TABLE Io.Reminder (
    groupId INT NOT NULL,
    noteId INT NOT NULL,
    
    timestamp DATETIME NOT NULL,
    -- možda još dodati repeat?
    
    PRIMARY KEY (groupId, noteId),
    FOREIGN KEY (groupId) REFERENCES Sifrarnik."Group"(id),
    FOREIGN KEY (noteId) REFERENCES Io.Note(id)
);

CREATE TABLE Io.LoggedReminder (
	id INT PRIMARY KEY IDENTITY(1,1),
    groupId INT NOT NULL,
    noteId INT NOT NULL,
	fired DATETIME NOT NULL,
	FOREIGN KEY (groupId, noteId) REFERENCES Io.Reminder(groupId, noteId)
)

CREATE TABLE Io.Tag (
    id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(50) NOT NULL,
    organisationId INT NOT NULL,
    FOREIGN KEY (organisationId) REFERENCES Sifrarnik.Organisation(id),
	UNIQUE NONCLUSTERED (name, organisationId)
);

CREATE TABLE Io.TaggedNote (
    noteId INT NOT NULL,
    tagId INT NOT NULL,
    PRIMARY KEY (noteId, tagId),
    FOREIGN KEY (noteId) REFERENCES Io.Note(id) ON DELETE CASCADE,
    FOREIGN KEY (tagId) REFERENCES Io.Tag(id) ON DELETE CASCADE
);
GO

-- Triggers
-- on Organisation INSERT - insert 'OGRANISATION' group for that organisation
CREATE TRIGGER trig_Organisation_Insert
ON Sifrarnik.Organisation
AFTER INSERT
AS
    INSERT INTO	Sifrarnik."Group" (name, type, organisationId) 
		SELECT 
		i.name, 'ORGANISATION_ALL', i.id 
		FROM inserted i;
GO

-- on user delete - delete special user's group
CREATE TRIGGER trig_User_Delete
ON Sifrarnik."User"
AFTER DELETE
AS
    DELETE FROM Sifrarnik."Group" WHERE type = 'USER' AND name = (SELECT d.username FROM deleted d)
GO


-- Keys
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'GlavniKljucPass123!'
GO

CREATE ASYMMETRIC KEY AsimetricniKLjuc
WITH ALGORITHM = RSA_2048
GO

CREATE SYMMETRIC KEY SimetricniKljuc
WITH ALGORITHM = AES_256
ENCRYPTION BY ASYMMETRIC KEY AsimetricniKljuc
GO
