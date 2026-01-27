-- login with any user account

-- permissions from logged-in user don't grant any permissions, so both fail:
SELECT * FROM Sifrarnik."User";
SELECT * FROM Io.Note;

EXEC sp_setapprole 'APP_Uloga', N'-U)8-zpQ&}^9oS4+hu7IC/@c;=\}.O,i';

SELECT * FROM Sifrarnik."User";
SELECT * FROM IO.Note;
-- the app can never delete entries in Sifrarnik.Organisation, so the following fails:
DELETE FROM Sifrarnik.Organisation WHERE id = 999;
