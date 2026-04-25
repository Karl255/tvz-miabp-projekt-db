-- Full backup script
BEGIN
	DECLARE @path VARCHAR(255) = CONCAT('C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER2\MSSQL\Backup\miabp_db_full_backup_', CAST(GETDATE() AS DATE), '.bak')
	BACKUP DATABASE [miabp_db] TO  DISK = @path WITH NOFORMAT, NOINIT,  NAME = N'miabp_db-backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
END
GO

-- Transaction log script
BEGIN
	DECLARE @path VARCHAR(255) = CONCAT('C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER2\MSSQL\Backup\miabp_db_tl_', CAST(GETDATE() AS DATE), '.bak');
	BACKUP LOG [miabp_db] TO  DISK = @path WITH NOFORMAT, NOINIT,  NAME = N'miabp_db-backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
END
GO