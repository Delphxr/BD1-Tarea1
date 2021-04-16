CREATE PROCEDURE dbo.InsertarPuesto
	-- parametros de entrada
	@inId INT
	, @inNombre VARCHAR(50)
	, @inSalarioXHora MONEY
	, @inVisible BIT
	-- parametros de salida
	, @OutResultCode INT OUTPUT
	
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SELECT
			@OutResultCode=0  -- codigo de ejecucion exitoso
		INSERT INTO [dbo].[Puestos]
			   ([ID]
			   ,[Nombre]
			   ,[SalarioXHora]
			   ,[Visible])
		 VALUES
			   (@inId
			   ,@inNombre
			   ,@inSalarioXHora
			   ,@inVisible)
	END TRY
	BEGIN CATCH
		Set @OutResultCode=50005; -- error de ejecucion
	END CATCH;
	SET NOCOUNT OFF;
END