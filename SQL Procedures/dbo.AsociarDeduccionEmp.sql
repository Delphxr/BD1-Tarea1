CREATE PROCEDURE dbo.AsociarDeduccionEmpleado
	-- parametros de entrada
	  @inIdEmpleado INT
	, @inTipoDeduccion INT
	, @inMonto MONEY

	-- parametros de salida
	, @OutResultCode INT OUTPUT
	
AS
BEGIN

	SET NOCOUNT ON;
	BEGIN TRY
		SELECT
			@OutResultCode=0;  -- codigo de ejecucion exitoso

			-- Validacion de paramentros de entrada
	
		IF NOT EXISTS(SELECT 1 FROM dbo.Empleado T WHERE T.ID=@inIdEmpleado)
		BEGIN
			Set @OutResultCode=50001; -- no existe el empleado
			RETURN
		END;

		IF NOT EXISTS(SELECT 1 FROM dbo.TipoDeduccion D WHERE D.ID=@inTipoDeduccion)
		BEGIN
			Set @OutResultCode=50002; -- tipo deduccion no existe
			RETURN
		END;




		INSERT INTO [dbo].[DeduccionesXEmpleado]
           ([IdEmpleado]
           ,[IdTipoDeduccion]
		   ,[Monto]
		   ,[Visible])
		VALUES(
			 @inIdEmpleado
			,@inTipoDeduccion
			,@inMonto
			,1)

	END TRY
	BEGIN CATCH
		Set @OutResultCode=50005;
	END CATCH;

	SET NOCOUNT OFF;
END