-- login with an admin's account

SELECT * FROM Sifrarnik."User";

EXECUTE AS USER = 'DB_Admin';

SELECT CURRENT_USER;
