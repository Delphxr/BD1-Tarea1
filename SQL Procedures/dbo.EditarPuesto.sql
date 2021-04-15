CREATE PROCEDURE dbo.EditarPuesto
	-- parametros de entrada
	@inPuestoId INT
	, @inNombre VARCHAR(50)
	, @inSalarioXHora MONEY	
	-- parametros de salida
	, @OutResultCode INT OUTPUT
	
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SELECT
			@OutResultCode=0  -- codigo de ejecucion exitoso

		IF NOT EXISTS(SELECT 1 FROM dbo.Puestos P WHERE P.ID=@inPuestoId)
		BEGIN
			Set @OutResultCode=50001; -- Puesto no existe
			RETURN
		END;

		UPDATE [dbo].[Puestos]
			SET  [Nombre] = @inNombre
				,[SalarioXHora] = @inSalarioXHora
			WHERE ID=@inPuestoId

	END TRY
	BEGIN CATCH
		Set @OutResultCode=50005; -- error de ejecucion
	END CATCH;
	SET NOCOUNT OFF;
END