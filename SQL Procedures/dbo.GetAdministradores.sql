CREATE PROCEDURE [dbo].[GetAdministradores]
	-- parametros de salida
	@OutResultCode INT OUTPUT

AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SELECT
			@OutResultCode=0  -- codigo de ejecucion exitoso
		SELECT [Usuario]
			  ,[Contrasena]
			  ,[Tipo]
		FROM [dbo].[Administradores]
	END TRY
	BEGIN CATCH
		Set @OutResultCode=50005;
	END CATCH;
	SET NOCOUNT OFF;
END