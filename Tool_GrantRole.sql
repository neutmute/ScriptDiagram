/*
Utility for setting up user accounts in SQL databases with all the steps that are easy to miss. 
Handles database restores to relink SIDs
https://github.com/neutmute/ScriptDiagram

DROP PROCEDURE dbo.Tool_GrantRole
*/
CREATE PROCEDURE dbo.Tool_GrantRole
(
	@username	VARCHAR(128)
	,@role		VARCHAR(128)
	,@password	VARCHAR(128) = NULL
)
AS
BEGIN
	DECLARE @DynamicSQL VARCHAR(400)
			,@IsAdUser BIT

	SELECT @IsAdUser = CASE WHEN (CHARINDEX('\', @username) <> 0) THEN 1 ELSE 0 END

	IF (EXISTS(SELECT 1 FROM sys.server_principals WHERE name = @username))
	BEGIN
		PRINT 'Login ' + @username + ' already exists'
	END
	ELSE
	BEGIN
		IF (@Password IS NULL)
		BEGIN
			PRINT 'Granting WINDOWS login to server for username=' + @username
			SELECT @DynamicSQL = 'CREATE LOGIN [' + @username + '] FROM WINDOWS WITH DEFAULT_DATABASE=master'
			EXEC(@DynamicSQL)
		END
		ELSE
		BEGIN
			PRINT 'Granting SQL Authed login to server for username=' + @username
			SELECT @DynamicSQL = 'CREATE LOGIN [' + @username + '] WITH PASSWORD=''' + @password + ''', CHECK_POLICY = OFF'
			EXEC(@DynamicSQL)
		END
	END

	IF (@password IS NOT NULL)
	BEGIN
		PRINT 'Autofixing ' + @username
		SELECT @DynamicSQL = 'EXEC sp_change_users_login ''Auto_fix'', [' + @username + '], null, ''' + @password + ''''			
	END

	/*
	* At one time had 'SP_REVOKEDBACCESS' used here to make grantdbaccess always succeed
	* but that has the effect of wiping all other access so sucessive calls to this proc could not be made
	* Was added to support some database restore scenarios. Need a better way if that comes up again
	*/
	IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = @username )
	BEGIN
		PRINT 'Granting username=''' + @username + ''' access to ' + db_name()
		EXEC sp_grantdbaccess @username
	END
	ELSE
	BEGIN
		PRINT 'Username ''' + @username + ''' already has acccess to ' + db_name()
	END

	IF (@IsAdUser = 0)
	BEGIN
		PRINT 'Relinking username to login in case of database restore'
		SELECT @DynamicSQL = 'EXEC sp_change_users_login ''Update_One'', [' + @username + '], [' + @username + ']'
		EXEC(@DynamicSQL)
	END
	
	PRINT 'Adding ' + @Username + ' to ' + @role
	SELECT @DynamicSQL = 'sp_addrolemember ' + @role + ', ['  + @username + ']'	-- SSDT for some reason didn't recognise parameter
	EXEC(@DynamicSQL)
END
