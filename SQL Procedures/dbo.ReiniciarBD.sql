CREATE PROCEDURE dbo.ReiniciarBD
	-- parametro de salida
	@OutResultCode INT OUTPUT	
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SELECT
			@OutResultCode=0  -- codigo de ejecucion exitoso
		
		BEGIN TRANSACTION
			DELETE FROM [dbo].[DeduccionesXEmpleado]
			DELETE FROM [dbo].[PlanillaXSemanaXEmpleado]
			DELETE FROM [dbo].[DeduccionesXMesXEmpleado]
			DELETE FROM [dbo].[PlanillaXMesXEmpleado]
			DELETE FROM [dbo].[Feriados]
			DELETE FROM [dbo].[Jornada]
			DELETE FROM [dbo].[TipoJornada]
			DELETE FROM [dbo].[MovimientoDeduccion]
			DELETE FROM [dbo].[TipoDeduccion]
			DELETE FROM [dbo].[MovimientoHoras]
			DELETE FROM [dbo].[MarcasAsistencia]
			DELETE FROM [dbo].[MovimientoPlanilla]
			DELETE FROM [dbo].[TipoMovimiento]
			DELETE FROM [dbo].[Empleado]
			DELETE FROM [dbo].[SemanaPlanilla]
			DELETE FROM [dbo].[MesPlanilla]
			DELETE FROM [dbo].[Departamentos]
			DELETE FROM [dbo].[Puestos]
			DELETE FROM [dbo].[TipoDocIdent]
			DELETE FROM [dbo].[Usuarios]
					WHERE Username != 'admin'
			
		COMMIT TRANSACTION;  -- Garantiza el todo 
			--(respecto del todo o nada, de la A de ACID, atomico)

	END TRY
	BEGIN CATCH
		-- @@Trancount indica cuantas transacciones de BD estan activas 
		IF @@Trancount>0 
			ROLLBACK TRANSACTION ; -- garantiza el nada, pues si hubo error 
			-- quiero que la BD quede como si nada hubiera pasado

		Set @OutResultCode=50005;

	END CATCH;
	SET NOCOUNT OFF;
END