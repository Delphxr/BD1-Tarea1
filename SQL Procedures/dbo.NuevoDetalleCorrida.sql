ALTER PROCEDURE [dbo].[NuevoDetalleCorrida]
	-- parametros de entrada
	  @inIdCorrida INT
	, @inTipoOperacion INT
	, @inRefID INT
	-- parametros de salida
	, @OutResultCode INT OUTPUT
	
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SELECT
			@OutResultCode=0  -- codigo de ejecucion exitoso

		IF NOT EXISTS(SELECT 1 FROM dbo.Corrida C WHERE C.ID=@inIdCorrida)
		BEGIN
			Set @OutResultCode=50001; -- no existe la corrida
			RETURN
		END;

		INSERT INTO [dbo].[DetalleCorrida]
           ([IdCorrida]
           ,[TipoOperacion]
           ,[RefID])
     VALUES
           (@inIdCorrida
           ,@inTipoOperacion
           ,@inRefID)
	END TRY
	BEGIN CATCH
		Set @OutResultCode=50005; -- error de ejecucion
	END CATCH;
	SET NOCOUNT OFF;
END