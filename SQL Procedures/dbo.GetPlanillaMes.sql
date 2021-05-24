ALTER PROCEDURE [dbo].[GetPlanillaMes]
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

		IF NOT EXISTS(SELECT 1 FROM [dbo].[PlanillaXMesXEmpleado] P WHERE P.IdEmpleado=@InEmpleadoId)
		BEGIN
			Set @OutResultCode=50001; -- el puesto no existe
			RETURN
		END;



		SELECT [ID]
		  ,[SalarioNeto]
		  ,[SalarioBruto]
		  ,[TotalDeducciones]
		  ,[IdEmpleado]
		  ,[idMes]
		 FROM [dbo].[PlanillaXMesXEmpleado]  where IdEmpleado=@InEmpleadoId ORDER BY ID DESC
	END TRY
	BEGIN CATCH
		Set @OutResultCode=50005;
	END CATCH;
	SET NOCOUNT OFF;
END