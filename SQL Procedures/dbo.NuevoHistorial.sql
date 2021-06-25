CREATE PROCEDURE dbo.NuevoHistorial
	-- parametros de entrada
	  @inIdEmpleado INT
	, @inValorModificado VARCHAR(100)
	, @inValorAnterior sql_variant --con esto recibimos cualquier tipo de parametro
	, @inValorNuevo sql_variant
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
			Set @OutResultCode=50001; -- Empleado no existe
			RETURN
		END;

		--preparamos los parametros
		DECLARE @ValorAnteriorSTR VARCHAR(100) = CONVERT(varchar(100), @inValorAnterior)
		DECLARE @ValorNuevoSTR VARCHAR(100) = CONVERT(varchar(100), @inValorNuevo)



		INSERT INTO [dbo].[Historial]
           ([IdEmpleado]
           ,[ValorModificado]
           ,[ValorAnterior]
           ,[ValorNuevo]
           ,[Fecha])
		VALUES
           (@inIdEmpleado
           ,@inValorModificado
           ,@ValorAnteriorSTR
           ,@ValorNuevoSTR
           ,GETDATE())

	END TRY
	BEGIN CATCH
		Set @OutResultCode=50005;
	END CATCH;

	SET NOCOUNT OFF;
END