ALTER PROCEDURE [dbo].[GetResultadoCorrida]
	-- parametros de entrada
	  @inFechaOperacion DATE
	-- parametros de salida
	, @outResultado INT OUTPUT
	
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		
		IF NOT EXISTS(SELECT 1 FROM dbo.Corrida C WHERE C.FechaOperacion=@inFechaOperacion)
		BEGIN
			Set @outResultado = 3 --no existe corrida para esa fecha aun
			RETURN
		END;

		IF EXISTS(SELECT 1 FROM dbo.Corrida C WHERE C.FechaOperacion=@inFechaOperacion AND C.TipoRegistro = 2)
		BEGIN
			Set @outResultado = 2 --ya la fecha se ha ejecutado completamente
			RETURN
		END;

		ELSE
		BEGIN
			Set @outResultado = 1 --la fecha aun no se ha terminado de ejecutar
			RETURN
		END
		
	END TRY
	BEGIN CATCH
		Set @outResultado=50005; -- error de ejecucion
	END CATCH;
	SET NOCOUNT OFF;
END