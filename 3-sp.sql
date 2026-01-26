-- ideje:
-- SP: Prikaži sadržaj foldera (folderId može biti NULL). User mora imati bilokoji permission.
-- SP: Postavi permission. Trenutni user mora imati "MANAGE" permission.
-- SP: Kreiraj novog korisnika. Treba hashirati plaintext lozinku.
-- SP: Dodaj permission za usera.
-- SP: Dodaj permission za grupu.

-- Funkcija: Dobivanje permissiona korisnika prema folderu.
	-- ulaz: folderId, userId
	-- izlaz: permission level ('VIEW', 'EDIT', 'MANAGE')
