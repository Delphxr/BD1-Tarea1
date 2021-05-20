CREATE PROCEDURE dbo.GetMarcasSemana
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

		DECLARE @tablaMovSemanaTemp Table(IDMovPlanilla int)
		DECLARE @tablaMovHorasTemp Table(IDMarcas int)
		
		--obtenemos los movimientos de la semana
		INSERT INTO @tablaMovSemanaTemp(IDMovPlanilla)
		SELECT [IdMovimientoPlanilla]
		FROM [dbo].[PlanillaXSemanaXEmpleado] WHERE IdSemana = @InSemanaId and IdEmpleado = @InEmpleadoId

		--obtenemos los id de los movimientos de horas de la semana
		INSERT INTO @tablaMovHorasTemp(IDMarcas)
		SELECT IdMarcaAsistencia
		FROM dbo.MovimientoHoras WHERE EXISTS (SELECT 1 
											   FROM   @tablaMovSemanaTemp t
											   WHERE  t.IDMovPlanilla = ID)

		--retornamos las marcas
		SELECT [ID]
			  ,[FechaEntrada]
			  ,[FechaSalida]
			  ,[ValorDocumentoIdentidad]
		  FROM [dbo].[MarcasAsistencia] WHERE EXISTS (SELECT 1 
													FROM   @tablaMovHorasTemp t
													WHERE  t.IDMarcas = ID)


	END TRY
	BEGIN CATCH
		Set @OutResultCode=50005;
	END CATCH;
	SET NOCOUNT OFF;
END
