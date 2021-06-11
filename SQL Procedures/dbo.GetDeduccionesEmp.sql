ALTER PROCEDURE [dbo].[GetDeduccionesEmpleado]
	-- parametros de entrada
	@InEmpleadoId INT
	-- parametros de salida
	,@OutResultCode INT OUTPUT

AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SELECT
			@OutResultCode=0  -- codigo de ejecucion exitoso

		IF NOT EXISTS(SELECT 1 FROM dbo.DeduccionesXEmpleado P WHERE P.IdEmpleado=@InEmpleadoId)
		BEGIN
			Set @OutResultCode=50001; -- el puesto no existe
			RETURN
		END;

		SELECT TOP (1000) [ID]
		  ,[IdEmpleado]
		  ,[IdTipoDeduccion]
		  ,[Monto]
		  ,(Select top 1 Nombre from dbo.TipoDeduccion t where t.id = [IdTipoDeduccion])
		  ,(Select top 1 Obligatorio from dbo.TipoDeduccion t where t.id = [IdTipoDeduccion])
		  ,(Select top 1 Porcentual from dbo.TipoDeduccion t where t.id = [IdTipoDeduccion])
	  FROM [PlanillaObrera_BD].[dbo].[DeduccionesXEmpleado] WHERE IdEmpleado = @InEmpleadoId AND Visible = 1
	END TRY
	BEGIN CATCH
		Set @OutResultCode=50005;
	END CATCH;
	SET NOCOUNT OFF;
END


