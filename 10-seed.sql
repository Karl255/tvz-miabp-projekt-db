-- Organisation (creates groups for each org using trigger)
INSERT INTO Sifrarnik.Organisation (name) VALUES ('Test org.');
INSERT INTO Sifrarnik.Organisation (name) VALUES ('TVZ');

-- User (automatically creates special group for each user and adds users to their organisations 'ALL' group)
EXEC Sifrarnik.InsertUser @username = 'testUser', @password = 'testpass', @email = 'test@test.com', @organisationId = 1;
EXEC Sifrarnik.InsertUser @username = 'student_user', @password = 'studentpass', @email = 'student@tvz.com', @organisationId = 2;
EXEC Sifrarnik.InsertUser @username = 'admin', @password = 'adminpass', @email = 'admin@tvz.com', @organisationId = 2;
EXEC Sifrarnik.InsertUser @username = 'dekan', @password = 'dekanpass', @email = 'dekan@tvz.com', @organisationId = 2;
EXEC Sifrarnik.InsertUser @username = 'teta_iz_referade', @password = 'referadapass', @email = 'referada@tvz.hr', @organisationId = 2;
EXEC Sifrarnik.InsertUser @username = 'prof1', @password = 'profpass', @email = 'prof@tvz.hr', @organisationId = 2;

-- Groups (non-automatically created groups)
INSERT INTO Sifrarnik."Group" (name, type, organisationId) VALUES ('TVZ - Admin', 'CUSTOM', 2);
INSERT INTO Sifrarnik."Group" (name, type, organisationId) VALUES ('TVZ - Dekan', 'CUSTOM', 2);
INSERT INTO Sifrarnik."Group" (name, type, organisationId) VALUES ('TVZ - Referada', 'CUSTOM', 2);
INSERT INTO Sifrarnik."Group" (name, type, organisationId) VALUES ('TVZ - Profesori', 'CUSTOM', 2);

-- UserGroup
-- User 'admin' to 'TVZ - Admin' Group
INSERT INTO Sifrarnik.GroupUser (userId, groupId) VALUES (3,9);
-- User 'dekan' to 'TVZ - Dekan' Group
INSERT INTO Sifrarnik.GroupUser (userId, groupId) VALUES (4,10);
-- User 'teta_iz_referade' to 'TVZ - Referada' Group
INSERT INTO Sifrarnik.GroupUser (userId, groupId) VALUES (5, 11);

-- Folder
INSERT INTO "Io".Folder (name) VALUES ('TVZ General');
INSERT INTO "Io".Folder (name, parentFolderId) VALUES ('Upute', 1);
INSERT INTO "Io".Folder (name, parentFolderId) VALUES ('Upisi', 2);
INSERT INTO "Io".Folder (name, parentFolderId) VALUES ('Završetak studija', 2);
INSERT INTO "Io".Folder (name, parentFolderId) VALUES ('Odabir mentora', 4);
INSERT INTO "Io".Folder (name, parentFolderId) VALUES ('Obrana diplomskog rada', 4);
INSERT INTO "Io".Folder (name, parentFolderId) VALUES ('Studentski zbor', 1);
INSERT INTO "Io".Folder (name, parentFolderId) VALUES ('Nastava', 1);
INSERT INTO "Io".Folder (name, parentFolderId) VALUES ('Raspored', 8);
INSERT INTO "Io".Folder (name, parentFolderId) VALUES ('Predmeti', 8);
INSERT INTO "Io".Folder (name, parentFolderId) VALUES ('MIABP', 10);
INSERT INTO "Io".Folder (name, parentFolderId) VALUES ('OOP', 10);
INSERT INTO "Io".Folder (name, parentFolderId) VALUES ('Osnove Elektrotehnike', 10);

-- Permission
EXEC Sifrarnik.AddGroupPermission @groupId = 2, @folderId = 1, @permissionLevel = 'VIEW';
EXEC Sifrarnik.AddGroupPermission @groupId = 9, @folderId = 1, @permissionLevel = 'MANAGE';
EXEC Sifrarnik.AddGroupPermission @groupId = 10, @folderId = 1, @permissionLevel = 'EDIT';
EXEC Sifrarnik.AddGroupPermission @groupId = 11, @folderId = 3, @permissionLevel = 'EDIT';

EXEC Sifrarnik.AddUserPermission @userId = 6, @folderId = 11, @permissionLevel = 'EDIT';
EXEC Sifrarnik.AddUserPermission @userId = 6, @folderId = 12, @permissionLevel = 'EDIT';

-- Tag
INSERT INTO "Io".Tag (name, organisationId) VALUES ('Važno', 2);
INSERT INTO "Io".Tag (name, organisationId) VALUES ('Prijediplomski', 2);
INSERT INTO "Io".Tag (name, organisationId) VALUES ('Diplomski', 2);
INSERT INTO "Io".Tag (name, organisationId) VALUES ('Računartsvo', 2);
INSERT INTO "Io".Tag (name, organisationId) VALUES ('Informatika', 2);
INSERT INTO "Io".Tag (name, organisationId) VALUES ('Elektrotehnika', 2);
INSERT INTO "Io".Tag (name, organisationId) VALUES ('Mehatronika', 2);
INSERT INTO "Io".Tag (name, organisationId) VALUES ('Graditeljstvo', 2);

-- Note
INSERT INTO "Io".Note (name, content, folderId) VALUES 
	(
		'O nama', 
		'Tehničko veleučilište u Zagrebu (TVZ) osnovano je 1998. godine s ciljem obrazovanja budućih inženjera.',
		1
	);
INSERT INTO "Io".Note (name, content, folderId) VALUES
	(
		'Koraci upisa u zimski semestar',
		'Koraci upisa u zimski semestar za prijediplomske studije',
		3
	);
INSERT INTO "Io".Note (name, content, folderId) VALUES
	(
		'Upute za polaganje kolegija',
		'Upute za polaganje kolegija MIABP...',
		11
	);

-- TaggedNote
INSERT INTO "Io".TaggedNote VALUES (2, 2);
INSERT INTO "Io".TaggedNote VALUES (2, 1);

INSERT INTO "Io".TaggedNote VALUES (3, 3);
INSERT INTO "Io".TaggedNote VALUES (3, 4);
INSERT INTO "Io".TaggedNote VALUES (3, 5);