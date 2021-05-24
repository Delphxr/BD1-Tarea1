ALTER PROCEDURE [dbo].[GetMarcasSemana]
	-- parametros de entrada
	@InEmpleadoId INT
	,@InSemanaId INT
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
			Set @OutResultCode=50001; -- el empleado no existe
			RETURN
		END;

		IF NOT EXISTS(SELECT 1 FROM dbo.SemanaPlanilla P WHERE P.ID=@InSemanaId)
		BEGIN
			Set @OutResultCode=50002; -- semana no existe
			RETURN
		END;

		--DECLARE @InEmpleadoId int =2
		--DECLARE @InSemanaId int =2
		DECLARE @fechaInicioSemana datetime
		DECLARE @fechaFinSemana datetime
		DECLARE @cedulaEmpleado varchar(24)
		
		SET @cedulaEmpleado = (Select top 1 ValorDocumentoIdentidad from dbo.Empleado where id = @InEmpleadoId)
		
		SET @fechaInicioSemana = (select top 1 FechaInicio from dbo.SemanaPlanilla where id = @InSemanaId)
		SET @fechaFinSemana = (select top 1 FechaFin from dbo.SemanaPlanilla where id = @InSemanaId)

		--retornamos las marcas
		SELECT [ID]
			  ,[FechaEntrada]
			  ,[FechaSalida]
		  FROM [dbo].[MarcasAsistencia] WHERE ValorDocumentoIdentidad = @cedulaEmpleado and FechaEntrada >= @fechaInicioSemana and FechaEntrada < @fechaFinSemana +1


	END TRY
	BEGIN CATCH
		Set @OutResultCode=50005;
	END CATCH;
	SET NOCOUNT OFF;
END
