
SET NOCOUNT ON
BEGIN TRY
BEGIN TRANSACTION


DECLARE @Datos XML/*Declaramos la variable Datos como un tipo XML*/
 
SELECT @Datos = D  /*El select imprime los contenidos del XML para dejarlo cargado en memoria*/
FROM OPENROWSET (BULK 'C:\Users\Oswaldo\Desktop\Datos_Tarea3.xml', SINGLE_BLOB) AS Datos(D) --ruta del xml
-- para las pruebas estamos manejando ruta estatica, ya una vez terminado
-- hacemos que la ruta sea dinamica

DECLARE @hdoc INT /*Creamos hdoc que va a ser un identificador*/
    
EXEC sp_xml_preparedocument @hdoc OUTPUT, @Datos/*Toma el identificador y a la variable con el documento y las asocia*/


print 'iniciando a leer catalogos'
--  ============================
--  || cargamos los catalogos ||
--  ============================ 

INSERT INTO dbo.Puestos(ID,Nombre,SalarioXHora,Visible)
SELECT Id,Nombre,SalarioXHora,1
FROM OPENXML (@hdoc,'/Datos/Catalogos/Puestos/Puesto',1)
WITH(/*Dentro del WITH se pone el nombre y el tipo de los atributos a retornar*/
	Id int,
    Nombre VARCHAR(64),
	SalarioXHora money
    ) cr
	WHERE
	NOT EXISTS (SELECT 1 FROM dbo.Puestos c
				WHERE cr.ID = c.Id)
	-- solo insertamos si no existe esa id ya


INSERT INTO dbo.Departamentos(ID,Nombre)
SELECT Id,Nombre
FROM OPENXML (@hdoc,'/Datos/Catalogos/Departamentos/Departamento',1)
WITH(/*Dentro del WITH se pone el nombre y el tipo de los atributos a retornar*/
	Id int,
    Nombre VARCHAR(64)
    ) cr
	WHERE
	NOT EXISTS (SELECT 1 FROM dbo.Departamentos c
				WHERE cr.ID = c.Id)
	-- solo insertamos si no existe esa id ya


INSERT INTO dbo.tipoDocIdent(ID,Nombre)
SELECT Id,Nombre
FROM OPENXML (@hdoc,'/Datos/Catalogos/Tipos_de_Documento_de_Identificacion/TipoIdDoc',1)
WITH(/*Dentro del WITH se pone el nombre y el tipo de los atributos a retornar*/
	Id int,
    Nombre VARCHAR(64)
    ) cr
	WHERE
	NOT EXISTS (SELECT 1 FROM dbo.tipoDocIdent c
				WHERE cr.ID = c.Id)
	-- solo insertamos si no existe esa id ya



INSERT INTO dbo.TipoJornada(ID,Nombre,HoraEntrada,HoraSalida)
SELECT Id,Nombre,HoraEntrada,HoraSalida
FROM OPENXML (@hdoc,'/Datos/Catalogos/TiposDeJornada/TipoDeJornada',1)
WITH(/*Dentro del WITH se pone el nombre y el tipo de los atributos a retornar*/
	Id int,
    Nombre VARCHAR(64),
	HoraEntrada TIME,
	HoraSalida TIME
    ) cr
	WHERE
	NOT EXISTS (SELECT 1 FROM dbo.TipoJornada c
				WHERE cr.ID = c.Id)
	-- solo insertamos si no existe esa id ya




INSERT INTO dbo.TipoMovimiento(ID,Nombre)
SELECT Id,Nombre
FROM OPENXML (@hdoc,'/Datos/Catalogos/TiposDeMovimiento/TipoDeMovimiento',1)
WITH(/*Dentro del WITH se pone el nombre y el tipo de los atributos a retornar*/
	Id int,
    Nombre VARCHAR(64)
    ) cr
	WHERE
	NOT EXISTS (SELECT 1 FROM dbo.TipoMovimiento c
				WHERE cr.ID = c.Id)
	-- solo insertamos si no existe esa id ya




INSERT INTO dbo.Feriados(Fecha,Nombre)
SELECT Fecha,Nombre
FROM OPENXML (@hdoc,'/Datos/Catalogos/Feriados/Feriado',1)
WITH(/*Dentro del WITH se pone el nombre y el tipo de los atributos a retornar*/
	Fecha DATE,
    Nombre VARCHAR(64)
    ) cr
	WHERE
	NOT EXISTS (SELECT 1 FROM dbo.Feriados c
				WHERE cr.Fecha = c.Fecha)
	-- solo insertamos si no existe esa fecha ya



--aqui los cast convierten 'si' y 'no' a valores bit
INSERT INTO dbo.TipoDeduccion(ID,Nombre,Obligatorio,Porcentual,Valor)
SELECT Id,Nombre,CAST(CASE Obligatorio WHEN 'Si' THEN 1 WHEN 'No' THEN 0 ELSE Obligatorio END AS BIT),CAST(CASE Porcentual WHEN 'Si' THEN 1 WHEN 'No' THEN 0 ELSE Porcentual END AS BIT),Valor
FROM OPENXML (@hdoc,'/Datos/Catalogos/Deducciones/TipoDeDeduccion',1)
WITH(/*Dentro del WITH se pone el nombre y el tipo de los atributos a retornar*/
	Id int,
    Nombre VARCHAR(64),
	Obligatorio VARCHAR(5),
	Porcentual VARCHAR(5),
	Valor MONEY
    ) cr
	WHERE
	NOT EXISTS (SELECT 1 FROM dbo.TipoDeduccion c
				WHERE cr.ID = c.Id)
	-- solo insertamos si no existe esa id ya


INSERT INTO dbo.Usuarios(Username,Pwd,Tipo)
SELECT username,pwd,tipo
FROM OPENXML (@hdoc,'/Datos/Usuarios/Usuario',1)
WITH(/*Dentro del WITH se pone el nombre y el tipo de los atributos a retornar*/
    username VARCHAR(64),
	pwd VARCHAR(64),
	tipo INT
    )

print 'terminando a leer catalogos'
print 'iniciando a limpiar base de datos'
--  ============================================
--  || Empezamos a ingresar las operaciones   ||
--  ============================================
DELETE FROM dbo.Historial
DBCC CHECKIDENT ('Historial', RESEED, 0)
DELETE FROM dbo.DeduccionesXMesXEmpleado
DBCC CHECKIDENT ('DeduccionesXMesXEmpleado', RESEED, 0)
DELETE FROM dbo.PlanillaXSemanaXEmpleado/*Limpia la tabla Empleados*/
DBCC CHECKIDENT ('PlanillaXSemanaXEmpleado', RESEED, 0)/*Reinicia el identify*/
DELETE FROM dbo.PlanillaXMesXEmpleado/*Limpia la tabla Empleados*/
DBCC CHECKIDENT ('PlanillaXMesXEmpleado', RESEED, 0)/*Reinicia el identify*/
DELETE FROM dbo.SemanaPlanilla/*Limpia la tabla Empleados*/
DBCC CHECKIDENT ('SemanaPlanilla', RESEED, 0)/*Reinicia el identify*/
DELETE FROM dbo.MesPlanilla/*Limpia la tabla Empleados*/
DBCC CHECKIDENT ('MesPlanilla', RESEED, 0)/*Reinicia el identify*/
DELETE FROM dbo.MovimientoDeduccion/*Limpia la tabla Empleados*/

DELETE FROM dbo.MovimientoHoras/*Limpia la tabla Empleados*/

DELETE FROM dbo.MovimientoPlanilla/*Limpia la tabla Empleados*/
DBCC CHECKIDENT ('MovimientoPlanilla', RESEED, 0)/*Reinicia el identify*/
DELETE FROM dbo.MarcasAsistencia/*Limpia la tabla Empleados*/
DBCC CHECKIDENT ('MarcasAsistencia', RESEED, 0)/*Reinicia el identify*/
DELETE FROM dbo.DeduccionesXEmpleado/*Limpia la tabla Empleados*/
DBCC CHECKIDENT ('DeduccionesXEmpleado', RESEED, 0)/*Reinicia el identify*/
DELETE FROM dbo.Jornada/*Limpia la tabla Empleados*/
DBCC CHECKIDENT ('Jornada', RESEED, 0)/*Reinicia el identify*/
DELETE FROM dbo.Empleado/*Limpia la tabla Empleados*/
DBCC CHECKIDENT ('Empleado', RESEED, 0)/*Reinicia el identify*/

print 'terminando limpiar base de datos'

-- esta tabla es para guardar las operaciones que vamos a hacer, donde cada fila es un dia diferente
DECLARE @TablaOperaciones TABLE(
	ID INT IDENTITY(1,1) PRIMARY KEY, --el id es para cuando hagamos la iteracion de la tabla
	XmlData XML, --aqui vamos a guardar los nodos de cada operacion para luego dividirlos por categoria
	Fecha DATE,
	Operaciones XML
)

declare @xmlvacio XML = ''
-- guardamos en la tabla de operaciones las operaciones a realizar
INSERT INTO @TablaOperaciones(
	XmlData,
	Fecha
)
SELECT * 
FROM OPENXML (@hdoc,'/Datos/Operacion',3)
WITH (
	XmlData XML '.',
	Fecha DATE
)
print 'terminando ingresar operaiciones'



DECLARE @Fin_Semana DATE = (SELECT TOP (1) [Fecha] FROM @TablaOperaciones);
DECLARE @Fin_Mes DATE = DATEADD(WEEK,3,(SELECT TOP (1) [Fecha] FROM @TablaOperaciones));



INSERT INTO dbo.MesPlanilla(FechaInicio,FechaFin)
VALUES(@Fin_Semana,@Fin_Mes)


DECLARE @CursorTestID INT = 1; --cursor para iterar por la tabla

-- obtenemos la cantidad de filas de la tabla
DECLARE @RowCnt BIGINT = 0;
SELECT @RowCnt = COUNT(0) FROM @TablaOperaciones;

DECLARE @main xml --plantilla para cuando insertemos las operaciones a las comunas
DECLARE @xmltemporal xml --temporal para ir insertando las varas 

print 'iniciando primer while'
WHILE @CursorTestID <= @RowCnt
BEGIN

	
	set @main = '<root>
		<NuevoEmpleado></NuevoEmpleado>
		<EliminarEmpleado></EliminarEmpleado>
		<AsociaEmpleadoConDeduccion></AsociaEmpleadoConDeduccion>
		<DesasociaEmpleadoConDeduccion></DesasociaEmpleadoConDeduccion>
		<TipoDeJornadaProximaSemana></TipoDeJornadaProximaSemana>
		<MarcaDeAsistencia></MarcaDeAsistencia>
	</root>'

	--nuevo empleado
	set @xmltemporal = (select XmlData.query('/Operacion/NuevoEmpleado') 
		from @TablaOperaciones 
		WHERE ID = @CursorTestID)

	set @main.modify('             
	insert sql:variable("@xmltemporal")             
	into (/root/NuevoEmpleado)[1] ')

	--eliminar empleado
	set @xmltemporal = (select XmlData.query('/Operacion/EliminarEmpleado') 
		from @TablaOperaciones 
		WHERE ID = @CursorTestID)
	set @main.modify('             
	insert sql:variable("@xmltemporal")             
	into (/root/EliminarEmpleado)[1] ')

	--AsociaEmpleadoConDeduccion
	set @xmltemporal = (select XmlData.query('/Operacion/AsociaEmpleadoConDeduccion') 
		from @TablaOperaciones 
		WHERE ID = @CursorTestID)
	set @main.modify('             
	insert sql:variable("@xmltemporal")             
	into (/root/AsociaEmpleadoConDeduccion)[1] ')

	--DesasociaEmpleadoConDeduccion
	set @xmltemporal = (select XmlData.query('/Operacion/DesasociaEmpleadoConDeduccion') 
		from @TablaOperaciones 
		WHERE ID = @CursorTestID)
	set @main.modify('             
	insert sql:variable("@xmltemporal")             
	into (/root/DesasociaEmpleadoConDeduccion)[1] ')

	--TipoDeJornadaProximaSemana
	set @xmltemporal = (select XmlData.query('/Operacion/TipoDeJornadaProximaSemana') 
		from @TablaOperaciones 
		WHERE ID = @CursorTestID)
	set @main.modify('             
	insert sql:variable("@xmltemporal")             
	into (/root/TipoDeJornadaProximaSemana)[1] ')

	--MarcaDeAsistencia
	set @xmltemporal = (select XmlData.query('/Operacion/MarcaDeAsistencia') 
		from @TablaOperaciones 
		WHERE ID = @CursorTestID)
	set @main.modify('             
	insert sql:variable("@xmltemporal")             
	into (/root/MarcaDeAsistencia)[1] ')

	update @TablaOperaciones
		set Operaciones = @main
		where ID = @CursorTestID


	
	SET @CursorTestID = @CursorTestID + 1 
END

print 'fin del priemr while'
--select * from @TablaOperaciones

print 'declaramos tablas variable'
--reiniciamos todo lo necesario para iterar de nuevo
set @CursorTestID = 1;
set  @RowCnt = 0;
SELECT @RowCnt = COUNT(0) FROM @TablaOperaciones;

-- creamos las tablas temporales donde vamos a guardar
-- los datos que se ingresan cuando no es fin de semana

DECLARE @NuevoEmpleadoTemp TABLE(
						FechaNacimiento DATE,
						Nombre varchar(100),
						idDepartamento int,
						ValorDocumentoIdentidad int,
						idPuesto int,
						idUsuario int,
						idTipoDocumentacionIdentidad int
						)

DECLARE @EliminarEmpleadoTemp TABLE(
						ValorDocumentoIdentidad VARCHAR(16)
						)

-- ============================================================= --
-- Tablas Variable donde guardamos las operaciones de cada fecha --
-- ============================================================= --

DECLARE @NuevoEmpleado TABLE(
	Secuencia INT,
	ValorDocumentoIdentidad VARCHAR(16),
	Nombre VARCHAR(128),
	IdTipoDocumentoIdentidad INT,
	IdPuesto INT,
	IdDepartamento INT,
	FechaNacimiento DATE,
	Username VARCHAR(64),
	Passwrd VARCHAR(64),
	ProduceError INT
)

DECLARE @EliminarEmpleado TABLE(
	Secuencia INT,
	ValorDocumentoIdentidad VARCHAR(16),
	ProduceError INT
)

DECLARE @AsociaEmpleadoConDeduccion TABLE(
	Secuencia INT,
	ValorDocumentoIdentidad VARCHAR(16),
	IdDeduccion INT,
	Monto MONEY,
	ProduceError INT
)

DECLARE @DesasociaEmpleadoConDeduccion TABLE (
	Secuencia INT,
	ValorDocumentoIdentidad VARCHAR(16),
	IdDeduccion INT,
	ProduceError INT
)

DECLARE @NuevasJornadas TABLE(
	Secuencia INT,
	ValorDocumentoIdentidad VARCHAR(16),
	IdJornada INT,
	ProduceError INT
)

DECLARE @MarcaAsistencia TABLE(
	Secuencia INT,
	ValorDocumentoIdentidad VARCHAR(16),
	FechaEntrada DATETIME,
	FechaSalida DATETIME,
	ProduceError INT
)
-- ============================================================= --


declare @subxml xml --subxml para realizar las operaciones de cada columna




print 'fin generar tablas variable e inicio de loop 2'
--  ==================================================================================================
--  || este loop es el que hace las operaciones, de momento lo unico que hace es imprimir los datos ||
--  ================================================================================================== 

-- ahora vamos a iterar de nuevo y realizar las operaciones de cada columna
DECLARE @Fecha_Actual DATE
DECLARE @resultadoCorrida INT
DECLARE @CorridaActual INT --aqui vamos a guardar el Id de la corrida actual
DECLARE @dummyReturnCode INT --para los SP que requieren un output
WHILE @CursorTestID <= @RowCnt
BEGIN
	SET @Fecha_Actual = (Select Fecha FROM @TablaOperaciones WHERE id =@CursorTestID)
	
	--revisamos los detalles de la corrida de la fecha actual
	-- para saber si ya se termino de ejecutar(2), aun esta en proceso(1), o del todo no ha empezado (3)
	EXEC	[dbo].[GetResultadoCorrida]
		@inFechaOperacion = @Fecha_Actual,
		@outResultado = @resultadoCorrida OUTPUT

	IF @resultadoCorrida = 3 OR @resultadoCorrida = 1
	BEGIN
		--creamos una nueva corrida
		EXEC	[dbo].[NuevaCorrida]
			@inFechaOperacion = @Fecha_Actual,
			@inTipoRegistro = 1, --inicio de corrida
			@OutResultCode = @dummyReturnCode OUTPUT
		SET @CorridaActual = SCOPE_IDENTITY()
	END
	ELSE --si la fecha actual ya se ejecuto cambiamos a la siguiente
	BEGIN
		SET @CursorTestID = @CursorTestID + 1 
		CONTINUE
	END
		

	-- cargamos el xml para la fecha actual
	set @subxml = (select TOP 1 Operaciones FROM @TablaOperaciones WHERE id = @CursorTestID)
	EXEC sp_xml_preparedocument @hdoc OUTPUT, @subxml

	--Limpiamos las tablas variable y luego las llenamos de los datos que ocupamos --
	-- =========================================================================== --
	DELETE FROM @NuevoEmpleado
	DELETE FROM @EliminarEmpleado
	DELETE FROM @AsociaEmpleadoConDeduccion
	DELETE FROM @AsociaEmpleadoConDeduccion
	DELETE FROM @NuevasJornadas
	DELETE FROM @MarcaAsistencia

	INSERT INTO @NuevoEmpleado (
			Secuencia,
			ValorDocumentoIdentidad,
			Nombre,
			IdTipoDocumentoIdentidad,
			IdPuesto,
			IdDepartamento,
			FechaNacimiento,
			Username,
			Passwrd,
			ProduceError)
		SELECT Secuencia,ValorDocumentoIdentidad,Nombre,idTipoDocumentacionIdentidad,idPuesto,idDepartamento,FechaNacimiento,Username,Password,ProduceError
		FROM OPENXML (@hdoc,'/root/NuevoEmpleado/NuevoEmpleado',3)
		WITH(
			Secuencia INT,
			ValorDocumentoIdentidad VARCHAR(16),
			Nombre VARCHAR(128),
			idTipoDocumentacionIdentidad INT,
			idPuesto INT,
			idDepartamento INT,
			FechaNacimiento DATE,
			Username VARCHAR(64),
			Password VARCHAR(64),
			ProduceError INT
			)

	INSERT INTO @EliminarEmpleado (
			Secuencia,
			ValorDocumentoIdentidad,
			ProduceError)
		SELECT Secuencia,ValorDocumentoIdentidad,ProduceError
		FROM OPENXML (@hdoc,'/root/EliminarEmpleado/EliminarEmpleado',3) 
		WITH(
			Secuencia INT,
			ValorDocumentoIdentidad VARCHAR(16),
			ProduceError INT
		) 

	INSERT INTO @AsociaEmpleadoConDeduccion(
			Secuencia,
			ValorDocumentoIdentidad,
			IdDeduccion,
			Monto,
			ProduceError)
		SELECT Secuencia,ValorDocumentoIdentidad,IdDeduccion,Monto,ProduceError
		FROM OPENXML (@hdoc,'/root/AsociaEmpleadoConDeduccion/AsociaEmpleadoConDeduccion',3)
		WITH (
			Secuencia INT,
			ValorDocumentoIdentidad VARCHAR(16),
			IdDeduccion INT,			
			Monto MONEY,
			ProduceError INT
		)

	INSERT INTO @DesasociaEmpleadoConDeduccion(
			Secuencia,
			ValorDocumentoIdentidad,
			IdDeduccion,
			ProduceError)
			SELECT Secuencia,ValorDocumentoIdentidad,IdDeduccion,ProduceError
			FROM OPENXML (@hdoc,'/root/DesasociaEmpleadoConDeduccion/DesasociaEmpleadoConDeduccion',3)
			WITH(
				Secuencia INT,
				ValorDocumentoIdentidad VARCHAR(16),
				IdDeduccion INT,
				ProduceError INT
			)

	INSERT INTO @NuevasJornadas (
			Secuencia,
			ValorDocumentoIdentidad,
			IdJornada,
			ProduceError)
			SELECT Secuencia,ValorDocumentoIdentidad,IdJornada,ProduceError
			FROM OPENXML (@hdoc,'/root/TipoDeJornadaProximaSemana/TipoDeJornadaProximaSemana',3)
			WITH (
				Secuencia INT,
				ValorDocumentoIdentidad VARCHAR(16),
				IdJornada INT,
				ProduceError INT					
			)

	INSERT INTO @MarcaAsistencia (
			Secuencia,
			ValorDocumentoIdentidad,
			FechaEntrada,
			FechaSalida,
			ProduceError)
			SELECT Secuencia,ValorDocumentoIdentidad,FechaEntrada,FechaSalida,ProduceError
			FROM OPENXML (@hdoc,'/root/MarcaDeAsistencia/MarcaDeAsistencia',3)
			WITH (
				Secuencia INT,
				ValorDocumentoIdentidad VARCHAR(16),
				FechaEntrada DATETIME,
				FechaSalida DATETIME,
				ProduceError INT
			)

	-- ========================================================= --


					


	--si no es nulo realizamos la insercion del empleado
	if (@subxml.value('(/root/NuevoEmpleado/NuevoEmpleado/@Secuencia)[1]', 'varchar(64)') is not null)
		begin
			-- insertamos los USUARIOS que se ingresan hoy (ESTOS SE INGRESAN SIN IMPORTAR EL DIA DE LA SEMANA)
			INSERT INTO dbo.Usuarios (Username,Pwd,Tipo)
			SELECT Username,Password,2
			FROM OPENXML (@hdoc,'/root/NuevoEmpleado/NuevoEmpleado',3)
			WITH(
				Username varchar(64),
				Password varchar(64)
				)

			--en caso de ser fin de semana:
			if(@Fecha_Actual = @Fin_Semana)
				begin

					-- insertamos los EMPLEADOS que se ingresan hoy
					INSERT INTO dbo.Empleado (FechaNacimiento,Nombre,IdDepartamento,ValorDocumentoIdentidad,IdPuesto,IdUsuario,IdTipoIdentificacion,Visible)
					SELECT FechaNacimiento,Nombre,IdDepartamento,ValorDocumentoIdentidad,idPuesto,1,idTipoDocumentacionIdentidad,1 
					FROM OPENXML (@hdoc,'/root/NuevoEmpleado/NuevoEmpleado',3)
					WITH (
						FechaNacimiento DATE,
						Nombre varchar(100),
						idDepartamento int,
						ValorDocumentoIdentidad int,
						idPuesto int,
						idTipoDocumentacionIdentidad int
						)


					--colocamos los usuarios en los empleados
					Update dbo.Empleado
					SET IdUsuario = (Select top 1 ID from dbo.Usuarios c where c.username = XMLDATA.Username and c.Pwd = XMLDATA.Password)
					FROM OPENXML (@hdoc,'/root/NuevoEmpleado/NuevoEmpleado',3)
					WITH(
						Username varchar(64),
						Password varchar(64),
						ValorDocumentoIdentidad int
					) XMLDATA
					where IdUsuario = 1 and dbo.Empleado.ValorDocumentoIdentidad = XMLDATA.ValorDocumentoIdentidad
					


					--insertamos los empleados que se han ido acumulando
					INSERT INTO dbo.Empleado (FechaNacimiento,Nombre,IdDepartamento,ValorDocumentoIdentidad,IdPuesto,IdUsuario,IdTipoIdentificacion,Visible)
					SELECT FechaNacimiento,Nombre,IdDepartamento,ValorDocumentoIdentidad,idPuesto,1,idTipoDocumentacionIdentidad,1 
					FROM @NuevoEmpleadoTemp

					IF EXISTS (SELECT ProduceError FROM OPENXML (@hdoc,'/root/NuevoEmpleado/NuevoEmpleado',3) WITH (ProduceError int) where ProduceError = 1)
					BEGIN
						BEGIN TRY
							SELECT 1/0
						END TRY
						BEGIN CATCH
							SELECT Secuencia, ProduceError,'Nuevo Empleado' FROM OPENXML (@hdoc,'/root/NuevoEmpleado/NuevoEmpleado',3) WITH (Secuencia int, ProduceError int) where ProduceError = 1
							exec SP_ERRORINFO
						END CATCH
					END

				end
					
			-- en caso de ser un dia normal:
			ELSE
				begin
					INSERT INTO @NuevoEmpleadoTemp (FechaNacimiento,Nombre,IdDepartamento,ValorDocumentoIdentidad,IdPuesto,idUsuario,idTipoDocumentacionIdentidad)
						SELECT FechaNacimiento,Nombre,IdDepartamento,ValorDocumentoIdentidad,idPuesto,1,idTipoDocumentacionIdentidad
						FROM OPENXML (@hdoc,'/root/NuevoEmpleado/NuevoEmpleado',3)
						WITH (
							FechaNacimiento DATE,
							Nombre varchar(100),
							idDepartamento int,
							ValorDocumentoIdentidad int,
							idPuesto int,
							idTipoDocumentacionIdentidad int
							)

					IF EXISTS (SELECT ProduceError FROM OPENXML (@hdoc,'/root/NuevoEmpleado/NuevoEmpleado',3) WITH (ProduceError int) where ProduceError = 1)
					BEGIN
						BEGIN TRY
							SELECT 1/0
						END TRY
						BEGIN CATCH
							SELECT Secuencia, ProduceError,'Nuevo Empleado' FROM OPENXML (@hdoc,'/root/NuevoEmpleado/NuevoEmpleado',3) WITH (Secuencia int, ProduceError int) where ProduceError = 1
							exec SP_ERRORINFO
						END CATCH
					END

				end	
		end

	--eliminar empleado
	if (@subxml.value('(/root/EliminarEmpleado/EliminarEmpleado/@Secuencia)[1]', 'varchar(64)') is not null)
		begin

			if(@Fecha_Actual = @Fin_Semana)
				begin
					Update Empleado
					SET Visible = 0
					FROM OPENXML (@hdoc,'/root/EliminarEmpleado/EliminarEmpleado',3) 
					WITH(
						ValorDocumentoIdentidad varchar(16)
					) AS X inner join dbo.Empleado AS E ON E.ValorDocumentoIdentidad = X.ValorDocumentoIdentidad


					IF EXISTS (SELECT ProduceError FROM OPENXML (@hdoc,'/root/EliminarEmpleado/EliminarEmpleado',3) WITH (ProduceError int) where ProduceError = 1)
					BEGIN
						BEGIN TRY
							SELECT 1/0
						END TRY
						BEGIN CATCH
							SELECT Secuencia, ProduceError,'Eliminar Empleado' FROM OPENXML (@hdoc,'/root/EliminarEmpleado/EliminarEmpleado',3) WITH (Secuencia int, ProduceError int) where ProduceError = 1
							exec SP_ERRORINFO
						END CATCH
					END


				end
			-- si es otro dia:
			ELSE
				begin
					INSERT INTO @EliminarEmpleadoTemp(ValorDocumentoIdentidad)
					SELECT ValorDocumentoIdentidad
					FROM OPENXML (@hdoc,'/root/EliminarEmpleado/EliminarEmpleado',3)
					WITH(
						ValorDocumentoIdentidad varchar(16)
					)


					IF EXISTS (SELECT ProduceError FROM OPENXML (@hdoc,'/root/EliminarEmpleado/EliminarEmpleado',3) WITH (ProduceError int) where ProduceError = 1)
					BEGIN
						BEGIN TRY
							SELECT 1/0
						END TRY
						BEGIN CATCH
							SELECT Secuencia, ProduceError,'Eliminar Empleado' FROM OPENXML (@hdoc,'/root/EliminarEmpleado/EliminarEmpleado',3) WITH (Secuencia int, ProduceError int) where ProduceError = 1
							exec SP_ERRORINFO
						END CATCH
					END


				end
		end

	-- cargamos asocia empleado con deduccion en caso de que haya
	if (@subxml.value('(/root/AsociaEmpleadoConDeduccion/AsociaEmpleadoConDeduccion/@Secuencia)[1]', 'varchar(64)') is not null)

		begin
				INSERT INTO dbo.DeduccionesXEmpleado(IdEmpleado,IdTipoDeduccion,Monto,Visible)
					SELECT (Select top 1 ID from dbo.empleado c where c.ValorDocumentoIdentidad = cr.ValorDocumentoIdentidad),IdDeduccion,IsNull(Monto,0),1
					FROM OPENXML (@hdoc,'/root/AsociaEmpleadoConDeduccion/AsociaEmpleadoConDeduccion',3)
						WITH (
							IdDeduccion int,
							ValorDocumentoIdentidad int,
							Monto money
						) cr

				IF EXISTS (SELECT ProduceError FROM OPENXML (@hdoc,'/root/AsociaEmpleadoConDeduccion/AsociaEmpleadoConDeduccion',3) WITH (ProduceError int) where ProduceError = 1)
					BEGIN
						BEGIN TRY
							SELECT 1/0
						END TRY
						BEGIN CATCH
							SELECT Secuencia, ProduceError,'Asocia Empleado Deduccion' FROM OPENXML (@hdoc,'/root/AsociaEmpleadoConDeduccion/AsociaEmpleadoConDeduccion',3) WITH (Secuencia int, ProduceError int) where ProduceError = 1
							exec SP_ERRORINFO
						END CATCH
					END

		end

		-- cargamos desasocia empleado con deduccion en caso de que haya
	if (@subxml.value('(/root/DesasociaEmpleadoConDeduccion/DesasociaEmpleadoConDeduccion/@Secuencia)[1]', 'varchar(64)') is not null)
		begin
			begin
				Update dbo.DeduccionesXEmpleado
					SET Visible = 0
					FROM OPENXML (@hdoc,'/root/DesasociaEmpleadoConDeduccion/DesasociaEmpleadoConDeduccion',3)
					WITH(
						IdDeduccion int,
						ValorDocumentoIdentidad varchar(16)
					) AS X inner join dbo.DeduccionesXEmpleado AS D ON D.IdTipoDeduccion = X.IdDeduccion
					inner join dbo.Empleado AS E ON D.IdEmpleado = E.ID

					IF EXISTS (SELECT ProduceError FROM OPENXML (@hdoc,'/root/DesasociaEmpleadoConDeduccion/DesasociaEmpleadoConDeduccion',3) WITH (ProduceError int) where ProduceError = 1)
					BEGIN
						BEGIN TRY
							SELECT 1/0
						END TRY
						BEGIN CATCH
							SELECT Secuencia, ProduceError,'Desasocia Empleado Deduccion' FROM OPENXML (@hdoc,'/root/DesasociaEmpleadoConDeduccion/DesasociaEmpleadoConDeduccion',3) WITH (Secuencia int, ProduceError int) where ProduceError = 1
							exec SP_ERRORINFO
						END CATCH
					END

			end
		end

		-- cargamos tipo de jornada en caso de que haya
	if (@subxml.value('(/root/TipoDeJornadaProximaSemana/TipoDeJornadaProximaSemana/@Secuencia)[1]', 'varchar(64)') is not null)
		begin
			--if(@Fecha_Actual = @Fin_Semana)
			--begin
				INSERT INTO dbo.Jornada(IdTipoJornada,IdEmpleado)
					SELECT IdJornada,(Select top 1 ID from dbo.empleado c where c.ValorDocumentoIdentidad = cr.ValorDocumentoIdentidad)
					FROM OPENXML (@hdoc,'/root/TipoDeJornadaProximaSemana/TipoDeJornadaProximaSemana',3)
						WITH (
							IdJornada int,
							ValorDocumentoIdentidad int
						) cr


				IF EXISTS (SELECT ProduceError FROM OPENXML (@hdoc,'/root/TipoDeJornadaProximaSemana/TipoDeJornadaProximaSemana',3) WITH (ProduceError int) where ProduceError = 1)
					BEGIN
						BEGIN TRY
							SELECT 1/0
						END TRY
						BEGIN CATCH
							SELECT Secuencia, ProduceError,'Tipo de Jornada Proxima Semana' FROM OPENXML (@hdoc,'/root/TipoDeJornadaProximaSemana/TipoDeJornadaProximaSemana',3) WITH (Secuencia int, ProduceError int) where ProduceError = 1
							exec SP_ERRORINFO
						END CATCH
					END

			--end
		end

		-- cargamosmarca de asistencia en caso de que haya
	begin transaction Marca
	if (@subxml.value('(/root/MarcaDeAsistencia/MarcaDeAsistencia/@Secuencia)[1]', 'varchar(64)') is not null)
		begin			
			INSERT INTO dbo.MarcasAsistencia(FechaEntrada,FechaSalida,ValorDocumentoIdentidad)
			SELECT * FROM OPENXML (@hdoc,'/root/MarcaDeAsistencia/MarcaDeAsistencia',3)
				WITH (
					FechaEntrada datetime,
					FechaSalida datetime,
					ValorDocumentoIdentidad int
				)

			EXEC dbo.SPMOVIMIENTOS @Fecha_Actual,@Fin_Semana

		

			IF EXISTS (SELECT ProduceError FROM OPENXML (@hdoc,'/root/MarcaDeAsistencia/MarcaDeAsistencia',3) WITH (ProduceError int) where ProduceError = 1)
					BEGIN
						BEGIN TRY
							SELECT 1/0
						END TRY
						BEGIN CATCH
							SELECT Secuencia, ProduceError,'MarcaAsistencia' FROM OPENXML (@hdoc,'/root/MarcaDeAsistencia/MarcaDeAsistencia',3) WITH (Secuencia int, ProduceError int) where ProduceError = 1
							exec SP_ERRORINFO
						END CATCH
					END


		end
	IF (@Fecha_Actual = @Fin_Mes)
		begin
			INSERT INTO dbo.MesPlanilla(FechaInicio,FechaFin)
			VALUES(DATEADD(DAY,1,@Fin_Mes),DATEADD(WEEK,4,@Fin_Mes))

			SET @Fin_Mes = DATEADD(WEEK,4,@Fin_Mes)

		end
	
	IF (@Fecha_Actual = @Fin_Semana)
		begin
			

			INSERT INTO dbo.SemanaPlanilla(FechaInicio,Fechafin,IdMes)
			SELECT DATEADD(DAY,1,@Fin_Semana),DATEADD(WEEK,1,@Fin_Semana),ID FROM dbo.MesPlanilla WHERE DATEADD(DAY,1,@Fin_Semana) BETWEEN MesPlanilla.FechaInicio and MesPlanilla.FechaFin
			--EXEC dbo.SPMovimientoDeduccion @Fecha_Actual

			SET @Fin_Semana = DATEADD(WEEK,1,@Fin_Semana)
			
			UPDATE dbo.MovimientoPlanilla
			SET Visible = 0
		end
	commit transaction Marca

	
	

	SET @CursorTestID = @CursorTestID + 1 
end
EXEC dbo.SETNETO
EXEC sp_xml_removedocument @hdoc/*Remueve el documento XML de la memoria*/


COMMIT TRANSACTION;  -- Garantiza el todo 
			--(respecto del todo o nada, de la A de ACID, atomico)
print 'Fin del SP'
END TRY
BEGIN CATCH
		-- @@Trancount indica cuantas transacciones de BD estan activas 
		IF @@Trancount>0 
			print 'Hubo un error! en la linea: ' + ERROR_LINE()
			print ERROR_MESSAGE ( )
			
			ROLLBACK TRANSACTION ; -- garantiza el nada, pues si hubo error 
			-- quiero que la BD quede como si nada hubiera pasado

	END CATCH;
	SET NOCOUNT OFF;

