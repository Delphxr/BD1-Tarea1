CREATE PROCEDURE dbo.GetPuestosByID
	-- parametros de entrada
	@InPuestoId INT
	-- parametros de salida
	,@OutResultCode INT OUTPUT

AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SELECT
			@OutResultCode=0  -- codigo de ejecucion exitoso

		IF NOT EXISTS(SELECT 1 FROM dbo.Puestos P WHERE P.ID=@InPuestoId)
		BEGIN
			Set @OutResultCode=50001; -- el puesto no existe
			RETURN
		END;

		SELECT [ID]
			,[Nombre]
			,[SalarioXHora]
		FROM [dbo].[Puestos] WHERE ID=@InPuestoId
	END TRY
	BEGIN CATCH
		Set @OutResultCode=50005;
	END CATCH;
	SET NOCOUNT OFF;
END


