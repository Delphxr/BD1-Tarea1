ALTER PROCEDURE dbo.GetHistorialEmpleado
	-- parametros de entrada
	@InEmpleadoId INT
	-- parametros de salida
	,@OutResultCode INT OUTPUT

AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SELECT
			@OutResultCode=0  -- codigo de ejecucion exitoso

		IF NOT EXISTS(SELECT 1 FROM dbo.Empleado P WHERE P.ID=@InEmpleadoId)
		BEGIN
			Set @OutResultCode=50001; -- epleado no existe
			RETURN
		END;

		SELECT [ID]
			  ,[IdEmpleado]
			  ,[ValorModificado]
			  ,[ValorAnterior]
			  ,[ValorNuevo]
			  ,[Fecha]
		  FROM [dbo].[Historial] WHERE IdEmpleado=@InEmpleadoId
	END TRY
	BEGIN CATCH
		Set @OutResultCode=50005;
	END CATCH;
	SET NOCOUNT OFF;
END


