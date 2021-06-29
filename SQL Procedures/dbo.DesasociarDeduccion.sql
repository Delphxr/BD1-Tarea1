USE [PlanillaObrera_BD]
GO
/****** Object:  StoredProcedure [dbo].[DesasociarDeduccion]    Script Date: 29/06/2021 02:23:07 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[DesasociarDeduccion]
	-- parametros de entrada
	  @inId INT

	-- parametros de salida
	, @OutResultCode INT OUTPUT
	
AS
BEGIN

	SET NOCOUNT ON;
	BEGIN TRY
		SELECT
			@OutResultCode=0;  -- codigo de ejecucion exitoso

			-- Validacion de paramentros de entrada
	
		IF NOT EXISTS(SELECT 1 FROM dbo.DeduccionesXEmpleado T WHERE T.ID=@inId)
		BEGIN
			Set @OutResultCode=50001; -- no existe la deduccion
			RETURN
		END;
			   		 	  	  
		UPDATE [dbo].[DeduccionesXEmpleado]
		   SET [Visible] = 0
		 WHERE ID=@inId

			DECLARE @fecha DATE = GETDATE()
			DECLARE @Dummyreturn INT
			DECLARE @detalle VARCHAR(128) = (Select top 1 nombre from dbo.TipoDeduccion t where t.id = (SELECT TOP 1 IdTipoDeduccion FROM dbo.DeduccionesXEmpleado WHERE ID=@inId))
			DECLARE @idemp INT = (SELECT TOP 1 IdEmpleado FROM dbo.DeduccionesXEmpleado WHERE ID=@inId)
			SET @detalle = 'NuevaDeduccion ' + @detalle
			exec dbo.NuevoHistorial 
						  @inIdEmpleado = @idemp
						, @inValorModificado = @detalle
						, @inValorAnterior = 1
						, @inValorNuevo = 0
						, @inFecha = @fecha
						-- parametros de salida
						, @OutResultCode = @Dummyreturn OUTPUT

	END TRY
	BEGIN CATCH
		Set @OutResultCode=50005;
	END CATCH;

	SET NOCOUNT OFF;
END