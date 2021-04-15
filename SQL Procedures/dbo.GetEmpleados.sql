CREATE PROCEDURE dbo.GetEmpleados
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
			  ,[IdTipoIdentificacion]
			  ,[ValorDocumentoIdentificacion]
			  ,[IdDepartamento]
			  ,[IdPuesto]
			  ,[FechaNacimiento]
		FROM [dbo].[Empleados]
	END TRY
	BEGIN CATCH
		Set @OutResultCode=50005;
	END CATCH;
	SET NOCOUNT OFF;
END


