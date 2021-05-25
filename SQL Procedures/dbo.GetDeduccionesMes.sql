USE [PlanillaObrera_BD]
GO
/****** Object:  StoredProcedure [dbo].[GetDeduccionesMes]    Script Date: 25/05/2021 01:52:16 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[GetDeduccionesMes]
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
			  ,(Select top 1 nombre from dbo.TipoDeduccion t where t.id = (select top 1 idtipodeduccion from dbo.MovimientoDeduccion w where w.id = p.IdMovimiento))
		  FROM [dbo].[DeduccionesXMesXEmpleado] p WHERE IdEmpleado=@inEmpleadoId and IdMes=@inMesId
	END TRY
	BEGIN CATCH
		Set @OutResultCode=50005;
	END CATCH;
	SET NOCOUNT OFF;
END
