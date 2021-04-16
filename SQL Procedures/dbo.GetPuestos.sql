CREATE PROCEDURE dbo.GetPuestos
	-- parametros de salida
	@OutResultCode INT OUTPUT

AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SELECT
			@OutResultCode=0  -- codigo de ejecucion exitoso
		SELECT [ID]
			,[Nombre]
			,[SalarioXHora]
			,[Visible]
		FROM [dbo].[Puestos]
	END TRY
	BEGIN CATCH
		Set @OutResultCode=50005;
	END CATCH;
	SET NOCOUNT OFF;
END


