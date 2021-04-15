CREATE PROCEDURE dbo.EditarEmpleado
	-- parametros de entrada
	  @inEmpleadoID INT
	, @inNombre VARCHAR(100)
	, @inTipoIdentidicacionId INT
	, @inValorDocumentoIdentificacion VARCHAR(10)
	, @inDepartamentoId INT
	, @inPuestoId INT
	, @inFechaNacimiento DATE
	-- parametros de salida
	, @OutResultCode INT OUTPUT
	
AS
BEGIN


	
	SET NOCOUNT ON;
	BEGIN TRY
		SELECT
			@OutResultCode=0  -- codigo de ejecucion exitoso
			;

			-- Validacion de paramentros de entrada
	
		IF NOT EXISTS(SELECT 1 FROM dbo.TipoDocIdent T WHERE T.ID=@inTipoIdentidicacionId)
		BEGIN
			Set @OutResultCode=50001; -- Tipo DI no existe
			RETURN
		END;

		IF NOT EXISTS(SELECT 1 FROM dbo.Departamentos D WHERE D.ID=@inDepartamentoId)
		BEGIN
			Set @OutResultCode=50002; -- Departamento no existe
			RETURN
		END;

		IF NOT EXISTS(SELECT 1 FROM dbo.Puestos P WHERE P.ID=@inPuestoId)
		BEGIN
			Set @OutResultCode=50003; -- Puesto no existe
			RETURN
		END;

		IF NOT EXISTS(SELECT 1 FROM dbo.Empleados E WHERE E.ID=@inEmpleadoID)
		BEGIN
			Set @OutResultCode=50004; -- el empleado no existe
			RETURN
		END;
		
		UPDATE [dbo].[Empleados]
			SET [Nombre] = @inNombre
			  ,[IdTipoIdentificacion] = @inTipoIdentidicacionId
			  ,[ValorDocumentoIdentificacion] = @inValorDocumentoIdentificacion
			  ,[IdDepartamento] = @inDepartamentoId
			  ,[IdPuesto] = @inPuestoId
			  ,[FechaNacimiento] = @inFechaNacimiento
			WHERE ID=@inEmpleadoID

	END TRY
	BEGIN CATCH
		Set @OutResultCode=50005;

	END CATCH;

	SET NOCOUNT OFF;
END