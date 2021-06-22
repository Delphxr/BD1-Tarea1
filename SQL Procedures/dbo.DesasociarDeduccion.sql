CREATE PROCEDURE dbo.DesasociarDeduccion
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

	END TRY
	BEGIN CATCH
		Set @OutResultCode=50005;
	END CATCH;

	SET NOCOUNT OFF;
END