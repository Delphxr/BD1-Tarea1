CREATE PROCEDURE dbo.GetDetalleCorrida
	-- parametros de entrada
	  @inIdCorrida INT
	, @inTipoOperacion INT
	-- parametros de salida
	, @outResultado INT OUTPUT
	
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		
		IF NOT EXISTS(SELECT 1 FROM dbo.DetalleCorrida C WHERE C.idCorrida=@inIdCorrida)
		BEGIN
			Set @outResultado = 50001 --no existe corrida
			RETURN
		END;

		IF EXISTS(SELECT 1 FROM dbo.DetalleCorrida C WHERE C.TipoOperacion=@inTipoOperacion)
		BEGIN
			Set @outResultado = 50002 --no hay nada para ese tipo de operacion
			RETURN
		END;

		SET @outResultado = (SELECT MAX(RefID) FROM dbo.DetalleCorrida WHERE idCorrida=@inIdCorrida and TipoOperacion=@inTipoOperacion)
		RETURN
		
	END TRY
	BEGIN CATCH
		Set @outResultado=50005; -- error de ejecucion
	END CATCH;
	SET NOCOUNT OFF;
END