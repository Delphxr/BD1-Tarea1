CREATE PROCEDURE [dbo].[GetDeduccionesSemana]
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

		SET @fechaInicioSemana = (select top 1 FechaInicio from dbo.SemanaPlanilla where id = @InSemanaId)
		SET @fechaFinSemana = (select top 1 FechaFin from dbo.SemanaPlanilla where id = @InSemanaId)

		--retornamos las marcas
		SELECT [ID]
      ,[Fecha]
      ,[Monto]
	  ,(Select top 1 nombre from dbo.TipoDeduccion t where t.id = (select top 1 idtipodeduccion from dbo.MovimientoDeduccion w where w.id = p.id))
      ,[IdTipoMov]
      ,[IdEmpleado]
		FROM [dbo].[MovimientoPlanilla] p 
		where exists(select 1 from MovimientoDeduccion m where m.id = p.id) and p.IdEmpleado = @InEmpleadoId and p.Fecha >= @fechaInicioSemana and p.Fecha < @fechaFinSemana +1


	END TRY
	BEGIN CATCH
		Set @OutResultCode=50005;
	END CATCH;
	SET NOCOUNT OFF;
END
