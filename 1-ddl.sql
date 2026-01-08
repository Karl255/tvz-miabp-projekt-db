CREATE TABLE Organisation (
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE "Group" (
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    -- u proceduri za brisanje dodati = 0
    isAutomaticallyManaged BIT NOT NULL,
    organisationId INT NOT NULL,
    FOREIGN KEY (organisationId) REFERENCES Organisation(id)
);

CREATE TABLE "User" (
    id INT PRIMARY KEY,
    username VARCHAR(32) NOT NULL,
    -- SHA3-224
    passwordHash VARCHAR(28) NOT NULL,
    organisationId INT NOT NULL,
    FOREIGN KEY (organisationId) REFERENCES Organisation(id)
);

CREATE TABLE Folder (
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
	parentFolderId INT NULL,
	FOREIGN KEY (parentFolderId) REFERENCES Folder(id)
);

CREATE TABLE Permission (
    groupId INT PRIMARY KEY,
    folderId INT PRIMARY KEY,
    -- 'READ', 'EDIT', 'MANAGE'
    level VARCHAR(6) NOT NULL
);

CREATE TABLE Note (
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
	content VARCHAR(MAX) NOT NULL,
	folderId INT NOT NULL,
	FOREIGN KEY (folderId) REFERENCES Folder(id),
	CONSTRAINT UNIQUE NONCLUSTERED (name, folderId)
);

-- Reminder, LoggedReminder

CREATE TABLE Reminder (
    groupId INT NOT NULL,
    noteId INT NOT NULL,
    
    timestamp DATETIME NOT NULL,
    -- možda još dodati repeat?
    
    PRIMARY KEY (groupId, noteId),
    FOREIGN KEY (groupId) REFERENCES "Group"(id),
    FOREIGN KEY (noteId) REFERENCES Note(id)
);

CREATE TABLE LoggedRemidner (
	id INT PRIMARY KEY,
    groupId INT NOT NULL,
    noteId INT NOT NULL,
	fired DATETIME NOT NULL,
	FOREIGN KEY (groupId, noteId) REFERENCES Reminder(groupId, noteId)
)

CREATE TABLE Tag (
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    organisationId INT NOT NULL,
    FOREIGN KEY (organisationId) REFERENCES Organisation(id)
);

CREATE TABLE TaggedNote (
    noteId INT NOT NULL,
    tagId INT NOT NULL,
    PRIMARY KEY (noteId, tagId),
    FOREIGN KEY (noteId) REFERENCES Note(id),
    FOREIGN KEY (tagId) REFERENCES Tag(id)
);
