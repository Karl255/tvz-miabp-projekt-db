-- Tables

CREATE TABLE Sifrarnik.Organisation (
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
	INDEX IX_name (name)
);

CREATE TABLE Sifrarnik."Group" (
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    -- 'ALL', 'USER', 'CUSTOM'
	-- samo CUSTOM se može brisati
    type VARCHAR(6) NOT NULL,
    organisationId INT NOT NULL,
    FOREIGN KEY (organisationId) REFERENCES Sifrarnik.Organisation(id)
);

CREATE TABLE Sifrarnik."User" (
    id INT PRIMARY KEY,
    username VARCHAR(32) NOT NULL,
    -- SHA3-224
    passwordHash VARCHAR(28) NOT NULL,
	INDEX IX_username (username)
);

CREATE TABLE Sifrarnik.GroupUser (
	userId INT NOT NULL,
	groupId INT NOT NULL,
	PRIMARY KEY (userId, groupId),
	FOREIGN KEY (userId) REFERENCES Sifrarnik."User"(id),
	FOREIGN KEY (groupId) REFERENCES Sifrarnik."Group"(id)
)

CREATE TABLE Io.Folder (
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
	parentFolderId INT NULL,
	FOREIGN KEY (parentFolderId) REFERENCES Io.Folder(id)
);

CREATE TABLE Io.Permission (
    groupId INT NOT NULL,
    folderId INT NOT NULL,
    -- 'READ', 'EDIT', 'MANAGE'
    level VARCHAR(6) NOT NULL,
	PRIMARY KEY (groupId, folderId),
	FOREIGN KEY (groupId) REFERENCES Sifrarnik."Group"(id),
	FOREIGN KEY (folderId) REFERENCES Io.Folder(id)
);

CREATE TABLE Io.Note (
    id INT PRIMARY KEY,
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

CREATE TABLE Io.LoggedRemidner (
	id INT PRIMARY KEY,
    groupId INT NOT NULL,
    noteId INT NOT NULL,
	fired DATETIME NOT NULL,
	FOREIGN KEY (groupId, noteId) REFERENCES Io.Reminder(groupId, noteId)
)

CREATE TABLE Io.Tag (
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    organisationId INT NOT NULL,
    FOREIGN KEY (organisationId) REFERENCES Sifrarnik.Organisation(id),
	UNIQUE NONCLUSTERED (name, organisationId)
);

CREATE TABLE Io.TaggedNote (
    noteId INT NOT NULL,
    tagId INT NOT NULL,
    PRIMARY KEY (noteId, tagId),
    FOREIGN KEY (noteId) REFERENCES Io.Note(id),
    FOREIGN KEY (tagId) REFERENCES Io.Tag(id)
);

-- Triggers

-- ideje:
-- on user create - create special user's group and add to ALL
-- on user delete - delete special user's group and remove from ALL
