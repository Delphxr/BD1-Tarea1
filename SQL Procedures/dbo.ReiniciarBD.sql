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
		
			DELETE FROM [dbo].[Empleados]
					WHERE ID>=0

			DELETE FROM [dbo].[Departamentos]
					WHERE ID>=0
			DELETE FROM [dbo].[Puestos]
					WHERE ID>=0
			DELETE FROM [dbo].[TipoDocIdent]
					WHERE ID>=0
			DELETE FROM [dbo].[Administradores]
					WHERE Usuario != 'admin'
			
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