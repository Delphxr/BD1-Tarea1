ALTER PROCEDURE [dbo].[EditarEmpleado]
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

		IF NOT EXISTS(SELECT 1 FROM dbo.Empleado E WHERE E.ID=@inEmpleadoID)
		BEGIN
			Set @OutResultCode=50004; -- el empleado no existe
			RETURN
		END;
		
		
		BEGIN TRANSACTION Cambios
			--guardamos los datos en el historial
			declare @output int
			declare @old sql_variant = (select top 1 Nombre from dbo.Empleado WHERE ID=@inEmpleadoID)
			if (@old != @inNombre)
			begin
				exec dbo.NuevoHistorial 
				  @inIdEmpleado = @inEmpleadoID
				, @inValorModificado = 'Nombre'
				, @inValorAnterior = @old
				, @inValorNuevo = @inNombre
				-- parametros de salida
				, @OutResultCode = @output OUTPUT
			end;

			set @old = (select top 1 ValorDocumentoIdentidad from dbo.Empleado WHERE ID=@inEmpleadoID)
			if (@old != @inValorDocumentoIdentificacion)
			begin
				exec dbo.NuevoHistorial 
				  @inIdEmpleado = @inEmpleadoID
				, @inValorModificado = 'ValorDI'
				, @inValorAnterior = @old
				, @inValorNuevo = @inValorDocumentoIdentificacion
				-- parametros de salida
				, @OutResultCode = @output OUTPUT
			end;

			set @old = (select top 1 IdTipoIdentificacion from dbo.Empleado WHERE ID=@inEmpleadoID)
			if (@old != @inTipoIdentidicacionId)
			begin
				exec dbo.NuevoHistorial 
				  @inIdEmpleado = @inEmpleadoID
				, @inValorModificado = 'TipoDI'
				, @inValorAnterior = @old
				, @inValorNuevo = @inTipoIdentidicacionId
				-- parametros de salida
				, @OutResultCode = @output OUTPUT
			end;

			set @old = (select top 1 IdDepartamento from dbo.Empleado WHERE ID=@inEmpleadoID)
			if (@old != @inDepartamentoId)
			begin
				exec dbo.NuevoHistorial 
				  @inIdEmpleado = @inEmpleadoID
				, @inValorModificado = 'Departamento'
				, @inValorAnterior = @old
				, @inValorNuevo = @inDepartamentoId
				-- parametros de salida
				, @OutResultCode = @output OUTPUT
			end;

			set @old = (select top 1 IdPuesto from dbo.Empleado WHERE ID=@inEmpleadoID)
			if (@old != @inPuestoId)
			begin
				exec dbo.NuevoHistorial 
				  @inIdEmpleado = @inEmpleadoID
				, @inValorModificado = 'Puesto'
				, @inValorAnterior = @old
				, @inValorNuevo = @inPuestoId
				-- parametros de salida
				, @OutResultCode = @output OUTPUT
			end;

			set @old = (select top 1 FechaNacimiento from dbo.Empleado WHERE ID=@inEmpleadoID)
			if (@old != @inFechaNacimiento)
			begin
				exec dbo.NuevoHistorial 
				  @inIdEmpleado = @inEmpleadoID
				, @inValorModificado = 'FechaNacimiento'
				, @inValorAnterior = @old
				, @inValorNuevo = @inFechaNacimiento
				-- parametros de salida
				, @OutResultCode = @output OUTPUT
			end;

			UPDATE [dbo].[Empleado]
				SET [Nombre] = @inNombre
				  ,[IdTipoIdentificacion] = @inTipoIdentidicacionId
				  ,[ValorDocumentoIdentidad] = @inValorDocumentoIdentificacion
				  ,[IdDepartamento] = @inDepartamentoId
				  ,[IdPuesto] = @inPuestoId
				  ,[FechaNacimiento] = @inFechaNacimiento
				WHERE ID=@inEmpleadoID
		COMMIT TRANSACTION Cambios;

	END TRY
	BEGIN CATCH
		IF @@Trancount>0 
				ROLLBACK TRANSACTION Cambios; -- garantiza el nada, pues si hubo error 
				-- quiero que la BD quede como si nada hubiera pasado
		Set @OutResultCode=50005;

	END CATCH;

	SET NOCOUNT OFF;
END