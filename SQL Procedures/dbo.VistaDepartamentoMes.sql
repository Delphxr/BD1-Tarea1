CREATE PROCEDURE [dbo].[VistaDepartamentoMes]
	@inMesInicio INT,
	@inMesFin INT,
	-- parametros de salida
	@OutResultCode INT OUTPUT

AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SELECT
			@OutResultCode=0  -- codigo de ejecucion exitoso
		


		SELECT TOP (1000) [Nombre]
			  ,[Promedio]
			  ,[Totaldeducciones]
			  ,[SalarioMaximo]
			  ,[EmpleadoMejorPagado]
			  ,[idMes]
		  FROM [PlanillaObrera_BD].[dbo].[Departamento_Mes]
		  WHERE idMes BETWEEN @inMesInicio AND @inMesFin

	END TRY
	BEGIN CATCH
		Set @OutResultCode=50005;
	END CATCH;
	SET NOCOUNT OFF;
END


