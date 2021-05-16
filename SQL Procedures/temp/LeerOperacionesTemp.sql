DECLARE @Datos XML/*Declaramos la variable Datos como un tipo XML*/
 
SELECT @Datos = D  /*El select imprime los contenidos del XML para dejarlo cargado en memoria*/
FROM OPENROWSET (BULK 'C:\Users\jenar\OneDrive\Documentos\Datos_Tarea2.xml', SINGLE_BLOB) AS Datos(D) --ruta del xml
-- para las pruebas estamos manejando ruta estatica, ya una vez terminado
-- hacemos que la ruta sea dinamica

DECLARE @hdoc INT /*Creamos hdoc que va a ser un identificador*/
    
EXEC sp_xml_preparedocument @hdoc OUTPUT, @Datos/*Toma el identificador y a la variable con el documento y las asocia*/

-- esta tabla es para guardar las operaciones que vamos a hacer, donde cada fila es un dia diferente
DECLARE @TablaOperaciones TABLE(
	ID INT IDENTITY(1,1) PRIMARY KEY CLUSTERED, --el id es para cuando hagamos la iteracion de la tabla
	XmlData XML, --aqui vamos a guardar los nodos de cada operacion para luego dividirlos por categoria
	Fecha DATE,
	NuevoEmpleado XML,
	EliminarEmpleado XML,
	AsociaEmpleadoConDeduccion XML,
	DesasociaEmpleadoConDeduccion XML,
	TipoDeJornadaProximaSemana XML,
	MarcaDeAsistencia XML
)

-- guardamos en la tabla de operaciones las operaciones a realizar
INSERT INTO @TablaOperaciones(
	XmlData,
	Fecha,
	NuevoEmpleado,
	EliminarEmpleado,
	AsociaEmpleadoConDeduccion,
	DesasociaEmpleadoConDeduccion,
	TipoDeJornadaProximaSemana,
	MarcaDeAsistencia
)
SELECT * 
FROM OPENXML (@hdoc,'/Datos/Operacion',3)
WITH (
	XmlData XML '.',
	Fecha DATE,
	NuevoEmpleado XML,
	EliminarEmpleado XML,
	AsociaEmpleadoConDeduccion XML,
	DesasociaEmpleadoConDeduccion XML,
	TipoDeJornadaProximaSemana XML,
	MarcaDeAsistencia XML
)

DECLARE @Fin_Semana DATE = (SELECT TOP (1) [Fecha] FROM @TablaOperaciones);

SELECT [Fin_Semana] = @Fin_Semana;

DECLARE @Fin_Mes DATE = DATEADD(WEEK,3,(SELECT TOP (1) [Fecha] FROM @TablaOperaciones));

SELECT [Fin_Mes] = @Fin_Mes;

DECLARE @CursorTestID INT = 1; --cursor para iterar por la tabla

-- obtenemos la cantidad de filas de la tabla
DECLARE @RowCnt BIGINT = 0;
SELECT @RowCnt = COUNT(0) FROM @TablaOperaciones;

DECLARE @main xml = '<root></root>' --plantilla para cuando insertemos las operaciones a las comunas
 --iteramos por la tabla
WHILE @CursorTestID <= @RowCnt
BEGIN
	-- en los update lo que hacemos es tomar los nodos con el nombre necesario de cada dia
	-- y moverlos a la columna necesaria
	--insertamos las operaciones de insertar empleados
	UPDATE @TablaOperaciones 
		SET NuevoEmpleado = (
				 SELECT @main.query('/root/*'), XmlData.query('/Operacion/NuevoEmpleado') 
				 FOR XML RAW(''),ROOT('root'), ELEMENTS, TYPE
				 )
		WHERE ID = @CursorTestID and NuevoEmpleado IS NOT NULL

	--insertamos las operaciones de eliminar empleados
	UPDATE @TablaOperaciones
		SET EliminarEmpleado = (
				 SELECT @main.query('/root/*'), XmlData.query('/Operacion/EliminarEmpleado') 
				 FOR XML RAW(''),ROOT('root'), ELEMENTS, TYPE
				 )
		WHERE ID = @CursorTestID and EliminarEmpleado IS NOT NULL;
	
	--insertamos las operaciones de asociar con deduccion
	UPDATE @TablaOperaciones
		SET AsociaEmpleadoConDeduccion = (
				 SELECT @main.query('/root/*'), XmlData.query('/Operacion/AsociaEmpleadoConDeduccion') 
				 FOR XML RAW(''),ROOT('root'), ELEMENTS, TYPE
				 )
		WHERE ID = @CursorTestID and AsociaEmpleadoConDeduccion IS NOT NULL;

	--insertamos las operaciones de desasociar deduccion
	UPDATE @TablaOperaciones
		SET DesasociaEmpleadoConDeduccion = (
				 SELECT @main.query('/root/*'), XmlData.query('/Operacion/DesasociaEmpleadoConDeduccion') 
				 FOR XML RAW(''),ROOT('root'), ELEMENTS, TYPE
				 )
		WHERE ID = @CursorTestID and DesasociaEmpleadoConDeduccion IS NOT NULL;

	--insertamos las operaciones de tipo jornada
	UPDATE @TablaOperaciones
		SET TipoDeJornadaProximaSemana = (
				 SELECT @main.query('/root/*'), XmlData.query('/Operacion/TipoDeJornadaProximaSemana') 
				 FOR XML RAW(''),ROOT('root'), ELEMENTS, TYPE
				 )
		WHERE ID = @CursorTestID and TipoDeJornadaProximaSemana IS NOT NULL;

	--insertamos las operaciones de marca de asistencia
	UPDATE @TablaOperaciones
		SET MarcaDeAsistencia = (
				 SELECT @main.query('/root/*'), XmlData.query('/Operacion/MarcaDeAsistencia') 
				 FOR XML RAW(''),ROOT('root'), ELEMENTS, TYPE
				 )
		WHERE ID = @CursorTestID and MarcaDeAsistencia IS NOT NULL;


	
	SET @CursorTestID = @CursorTestID + 1 
END

select * from @TablaOperaciones


--reiniciamos todo lo necesario para iterar de nuevo
set @CursorTestID = 1;
set  @RowCnt = 0;
SELECT @RowCnt = COUNT(0) FROM @TablaOperaciones;

declare @subxml xml --subxml para realizar las operaciones de cada columna

--  ==================================================================================================
--  || este loop es el que hace las operaciones, de momento lo unico que hace es imprimir los datos ||
--  ================================================================================================== 

-- ahora vamos a iterar de nuevo y realizar las operaciones de cada columna
WHILE @CursorTestID <= @RowCnt
BEGIN
	DECLARE @Fecha_Actual DATE = (Select Fecha FROM @TablaOperaciones WHERE id =@CursorTestID)
	SELECT [Fecha_Actual] = @Fecha_Actual
	-- cargamos nuevo empleado en caso de que haya
	set @subxml = (select TOP 1 NuevoEmpleado FROM @TablaOperaciones WHERE id = @CursorTestID)
	--si no es nulo realizamos la insercion del empleado
	if (@subxml is not null)
		begin
			EXEC sp_xml_preparedocument @hdoc OUTPUT, @subxml/*Toma el identificador y a la variable con el documento y las asocia*/
			if(@Fecha_Actual = @Fin_Semana)
				begin
					INSERT INTO Empleado (FechaNacimiento,Nombre,Usuario,IdDepartamento,ValorDocumentoIdentidad,IdPuesto,IdTipoIdentificacion,Visible)
					SELECT FechaNacimiento,Nombre,Username,IdDepartamento,ValorDocumentoIdentidad,idPuesto,idTipoDocumentacionIdentidad,0 
					FROM OPENXML (@hdoc,'/root/NuevoEmpleado',3)
					WITH (
						FechaNacimiento DATE,
						Nombre varchar(100),
						Password varchar(100),
						Username varchar(100),
						IdDepartamento int,
						ValorDocumentoIdentidad int,
						idPuesto int,
						idTipoDocumentacionIdentidad int
						)

					SELECT * FROM Empleado
					SET @Fin_Semana = DATEADD(WEEK,1,@Fin_Semana)
				end
			SELECT * FROM OPENXML (@hdoc,'/root/NuevoEmpleado',3)
				WITH (
					FechaNacimiento DATE,
					Nombre varchar(100),
					Password varchar(100),
					Username varchar(100),
					IdDepartamento int,
					ValorDocumentoIdentidad int,
					idPuesto int,
					idTipoDocumentacionIdentidad int
				)
			
		end
	-- cargamos eliminar empleado
	set @subxml = (select TOP 1 EliminarEmpleado FROM @TablaOperaciones WHERE id = @CursorTestID)
	if @subxml is not null
		begin
			EXEC sp_xml_preparedocument @hdoc OUTPUT, @subxml/*Toma el identificador y a la variable con el documento y las asocia*/
			SELECT * FROM OPENXML (@hdoc,'/root/EliminarEmpleado',3)
				WITH (
					ValorDocumentoIdentidad int
				)
		end

	-- cargamos asocia empleado con deduccion en caso de que haya
	set @subxml = (select TOP 1 AsociaEmpleadoConDeduccion FROM @TablaOperaciones WHERE id = @CursorTestID)
	if @subxml is not null
		begin
			EXEC sp_xml_preparedocument @hdoc OUTPUT, @subxml/*Toma el identificador y a la variable con el documento y las asocia*/
			SELECT * FROM OPENXML (@hdoc,'/root/AsociaEmpleadoConDeduccion',3)
				WITH (
					IdDeduccion int,
					Monto money,
					ValorDocumentoIdentidad int
				)
		end

	-- cargamos desasocia empleado con deduccion en caso de que haya
	set @subxml = (select TOP 1 DesasociaEmpleadoConDeduccion FROM @TablaOperaciones WHERE id = @CursorTestID)
	if @subxml is not null
		begin
			EXEC sp_xml_preparedocument @hdoc OUTPUT, @subxml/*Toma el identificador y a la variable con el documento y las asocia*/
			SELECT * FROM OPENXML (@hdoc,'/root/DesasociaEmpleadoConDeduccion',3)
				WITH (
					IdDeduccion int,
					ValorDocumentoIdentidad int
				)
		end

	-- cargamos tipo de jornada en caso de que haya
	set @subxml = (select TOP 1 TipoDeJornadaProximaSemana FROM @TablaOperaciones WHERE id = @CursorTestID)
	if @subxml is not null
		begin
			EXEC sp_xml_preparedocument @hdoc OUTPUT, @subxml/*Toma el identificador y a la variable con el documento y las asocia*/
			SELECT * FROM OPENXML (@hdoc,'/root/TipoDeJornadaProximaSemana',3)
				WITH (
					IdJornada int,
					ValorDocumentoIdentidad int
				)
		end

	-- cargamosmarca de asistencia en caso de que haya
	set @subxml = (select TOP 1 MarcaDeAsistencia FROM @TablaOperaciones WHERE id = @CursorTestID)
	if @subxml is not null
		begin
			EXEC sp_xml_preparedocument @hdoc OUTPUT, @subxml/*Toma el identificador y a la variable con el documento y las asocia*/
			SELECT * FROM OPENXML (@hdoc,'/root/MarcaDeAsistencia',3)
				WITH (
					FechaEntrada date,
					FechaSalida date,
					ValorDocumentoIdentidad int
				)
		end


	
	SET @CursorTestID = @CursorTestID + 1 
END
