CREATE PROCEDURE dbo.GetDeduccionesMes
	@inEmpleadoId INT
	,@inMesId INT
	-- parametros de salida
	,@OutResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SELECT
			@OutResultCode=0  -- codigo de ejecucion exitoso

		IF NOT EXISTS(SELECT 1 FROM dbo.Empleado E WHERE E.ID=@InEmpleadoId)
		BEGIN
			Set @OutResultCode=50001; -- el empleado no existe
			RETURN
		END;
		
		IF NOT EXISTS(SELECT 1 FROM dbo.MesPlanilla E WHERE E.ID=@inMesId)
		BEGIN
			Set @OutResultCode=50001; -- el empleado no existe
			RETURN
		END;

		SELECT [ID]
			  ,[Monto]
			  ,[IdPlanillaXMesXEmpleado]
			  ,[IdMovimiento]
			  ,[IdEmpleado]
			  ,[IdMes]
		  FROM [dbo].[DeduccionesXMesXEmpleado] WHERE IdEmpleado=@inEmpleadoId and IdMes=@inMesId
	END TRY
	BEGIN CATCH
		Set @OutResultCode=50005;
	END CATCH;
	SET NOCOUNT OFF;
END
