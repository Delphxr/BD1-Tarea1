ALTER PROCEDURE dbo.NuevaCorrida
	-- parametros de entrada
	  @inFechaOperacion DATE
	, @inTipoRegistro INT
	-- parametros de salida
	, @OutResultCode INT OUTPUT
	
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SELECT
			@OutResultCode=0  -- codigo de ejecucion exitoso



		INSERT INTO [dbo].[Corrida]
           ([FechaOperacion]
           ,[TipoRegistro]
           ,[PostTime])
		VALUES
           (@inFechaOperacion
           ,@inTipoRegistro
           ,GETDATE())
	END TRY
	BEGIN CATCH
		Set @OutResultCode=50005; -- error de ejecucion
	END CATCH;
	SET NOCOUNT OFF;
END