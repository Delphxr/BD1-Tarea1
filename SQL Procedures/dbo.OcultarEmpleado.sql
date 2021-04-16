CREATE PROCEDURE dbo.OcultarEmpleado
	-- parametros de entrada
	  @inEmpleadoID INT
	, @inVisible BIT
	-- parametros de salida
	, @OutResultCode INT OUTPUT
	
AS
BEGIN

	SET NOCOUNT ON;
	BEGIN TRY
		SELECT
			@OutResultCode=0  -- codigo de ejecucion exitoso
			;

			-- Validacion de paramentros de entrada

		IF NOT EXISTS(SELECT 1 FROM dbo.Empleados E WHERE E.ID=@inEmpleadoID)
		BEGIN
			Set @OutResultCode=50001; -- el empleado no existe
			RETURN
		END;
		
		UPDATE [dbo].[Empleados]
			SET [Visible] = @inVisible
			WHERE ID=@inEmpleadoID

	END TRY
	BEGIN CATCH
		Set @OutResultCode=50005;

	END CATCH;

	SET NOCOUNT OFF;
END