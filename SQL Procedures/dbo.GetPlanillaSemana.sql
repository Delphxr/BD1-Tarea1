CREATE PROCEDURE dbo.GetPlanillaSemana
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

		IF NOT EXISTS(SELECT 1 FROM [dbo].[PlanillaXSemanaXEmpleado] P WHERE P.IdEmpleado=@InEmpleadoId)
		BEGIN
			Set @OutResultCode=50001; -- el puesto no existe
			RETURN
		END;

		SELECT [ID]
		  ,[SalarioBruto]
		  ,[TotalDeducciones]
		  ,[SalarioNeto]
		  ,[IdEmpleado]
		  ,[IdSemana]
		  ,[IdMovimientoPlanilla]
		  ,[IdPlanillaXMesXEmpleado]
		FROM [dbo].[PlanillaXSemanaXEmpleado] WHERE [IdEmpleado]=@InEmpleadoId
	END TRY
	BEGIN CATCH
		Set @OutResultCode=50005;
	END CATCH;
	SET NOCOUNT OFF;
END
