DECLARE @Datos XML/*Declaramos la variable Datos como un tipo XML*/
 
SELECT @Datos = D  /*El select imprime los contenidos del XML para dejarlo cargado en memoria*/
FROM OPENROWSET (BULK 'C:\Users\jenar\OneDrive\Documentos\Datos_Tarea2.xml', SINGLE_BLOB) AS Datos(D) --ruta del xml
-- para las pruebas estamos manejando ruta estatica, ya una vez terminado
-- hacemos que la ruta sea dinamica

DECLARE @hdoc INT /*Creamos hdoc que va a ser un identificador*/
    
EXEC sp_xml_preparedocument @hdoc OUTPUT, @Datos/*Toma el identificador y a la variable con el documento y las asocia*/



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



--  ============================================
--  || Empezamos a ingresar las operaciones   ||
--  ============================================
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

INSERT INTO dbo.MesPlanilla(FechaInicio,FechaFin)
VALUES(@Fin_Semana,@Fin_Mes)


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




declare @subxml xml --subxml para realizar las operaciones de cada columna

--declare @cntx int = 1;
--declare @cntrendx int;
--declare @monto money = 0
--declare @horas int
--declare @marcaasistenciatempx TABLE(id int identity(1,1) primary key,FechaEntrada datetime,FechaSalida datetime,ValorDocumentoIdentidad int)


--  ==================================================================================================
--  || este loop es el que hace las operaciones, de momento lo unico que hace es imprimir los datos ||
--  ================================================================================================== 

-- ahora vamos a iterar de nuevo y realizar las operaciones de cada columna
WHILE @CursorTestID <= @RowCnt
BEGIN
	DECLARE @Fecha_Actual DATE = (Select Fecha FROM @TablaOperaciones WHERE id =@CursorTestID)
	--SELECT [Fecha_Actual] = @Fecha_Actual



	-- cargamos los usuarios de nuevo empleado
	set @subxml = (select TOP 1 NuevoEmpleado FROM @TablaOperaciones WHERE id = @CursorTestID)
	--si no es nulo realizamos la insercion del empleado
	if (@subxml is not null)
		begin
			EXEC sp_xml_preparedocument @hdoc OUTPUT, @subxml/*Toma el identificador y a la variable con el documento y las asocia*/
						-- insertamos los empleados que se ingresan hoy
						INSERT INTO dbo.Usuarios (Username,Pwd,Tipo)
						SELECT Username,Password,2
						FROM OPENXML (@hdoc,'/root/NuevoEmpleado',3)
						WITH(
							Username varchar(64),
							Password varchar(64)
							)
			exec sp_xml_removedocument @hdoc
		end




	-- cargamos nuevo empleado en caso de que haya
	set @subxml = (select TOP 1 NuevoEmpleado FROM @TablaOperaciones WHERE id = @CursorTestID)
	--si no es nulo realizamos la insercion del empleado
	if (@subxml is not null)
		begin
			EXEC sp_xml_preparedocument @hdoc OUTPUT, @subxml/*Toma el identificador y a la variable con el documento y las asocia*/
			--en caso de ser fin de semana:
			if(@Fecha_Actual = @Fin_Semana)
				begin
					-- insertamos los empleados que se ingresan hoy
					INSERT INTO dbo.Empleado (FechaNacimiento,Nombre,IdDepartamento,ValorDocumentoIdentidad,IdPuesto,IdUsuario,IdTipoIdentificacion,Visible)
					SELECT FechaNacimiento,Nombre,IdDepartamento,ValorDocumentoIdentidad,idPuesto,1,idTipoDocumentacionIdentidad,1 
					FROM OPENXML (@hdoc,'/root/NuevoEmpleado',3)
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
					FROM OPENXML (@hdoc,'/root/NuevoEmpleado',3)
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
					
				end
			-- en caso de ser un dia normal:
			ELSE
				begin
					INSERT INTO @NuevoEmpleadoTemp (FechaNacimiento,Nombre,IdDepartamento,ValorDocumentoIdentidad,IdPuesto,idUsuario,idTipoDocumentacionIdentidad)
						SELECT FechaNacimiento,Nombre,IdDepartamento,ValorDocumentoIdentidad,idPuesto,1,idTipoDocumentacionIdentidad
						FROM OPENXML (@hdoc,'/root/NuevoEmpleado',3)
						WITH (
							FechaNacimiento DATE,
							Nombre varchar(100),
							idDepartamento int,
							ValorDocumentoIdentidad int,
							idPuesto int,
							idTipoDocumentacionIdentidad int
							)
				end	
				EXEC sp_xml_removedocument @hdoc/*Remueve el documento XML de la memoria*/
		end

		set @subxml = (select TOP 1 EliminarEmpleado FROM @TablaOperaciones WHERE id = @CursorTestID)
	if @subxml is not null
		begin
			EXEC sp_xml_preparedocument @hdoc OUTPUT, @subxml/*Toma el identificador y a la variable con el documento y las asocia*/
			-- en caso de ser fin de semana:
			--Select FinSema = @Fin_Semana
			if(@Fecha_Actual = @Fin_Semana)
				begin
					Update Empleado
					SET Visible = 0
					FROM OPENXML (@hdoc,'/root/EliminarEmpleado',3) 
					WITH(
						ValorDocumentoIdentidad varchar(16)
					) AS X inner join dbo.Empleado AS E ON E.ValorDocumentoIdentidad = X.ValorDocumentoIdentidad

				end
			-- si es otro dia:
			ELSE
				begin
					INSERT INTO @EliminarEmpleadoTemp(ValorDocumentoIdentidad)
					SELECT ValorDocumentoIdentidad
					FROM OPENXML (@hdoc,'/root/EliminarEmpleado',3)
					WITH(
						ValorDocumentoIdentidad varchar(16)
					)
				end
				EXEC sp_xml_removedocument @hdoc/*Remueve el documento XML de la memoria*/
		end

		-- cargamos asocia empleado con deduccion en caso de que haya
	set @subxml = (select TOP 1 AsociaEmpleadoConDeduccion FROM @TablaOperaciones WHERE id = @CursorTestID)
	if @subxml is not null
		begin
			EXEC sp_xml_preparedocument @hdoc OUTPUT, @subxml/*Toma el identificador y a la variable con el documento y las asocia*/

				INSERT INTO dbo.DeduccionesXEmpleado(IdEmpleado,IdTipoDeduccion,Monto,Visible)
					SELECT (Select top 1 ID from dbo.empleado c where c.ValorDocumentoIdentidad = cr.ValorDocumentoIdentidad),IdDeduccion,IsNull(Monto,0),1
					FROM OPENXML (@hdoc,'/root/AsociaEmpleadoConDeduccion',3)
						WITH (
							IdDeduccion int,
							ValorDocumentoIdentidad int,
							Monto money
						) cr



			EXEC sp_xml_removedocument @hdoc/*Remueve el documento XML de la memoria*/
		end

		-- cargamos desasocia empleado con deduccion en caso de que haya
	set @subxml = (select TOP 1 DesasociaEmpleadoConDeduccion FROM @TablaOperaciones WHERE id = @CursorTestID)
	if @subxml is not null
		begin
			EXEC sp_xml_preparedocument @hdoc OUTPUT, @subxml/*Toma el identificador y a la variable con el documento y las asocia*/
			begin
				Update dbo.DeduccionesXEmpleado
					SET Visible = 0
					FROM OPENXML (@hdoc,'/root/DesasociaEmpleadoConDeduccion',3)
					WITH(
						IdDeduccion int,
						ValorDocumentoIdentidad varchar(16)
					) AS X inner join dbo.DeduccionesXEmpleado AS D ON D.IdTipoDeduccion = X.IdDeduccion
					inner join dbo.Empleado AS E ON D.IdEmpleado = E.ID
			end
			EXEC sp_xml_removedocument @hdoc/*Remueve el documento XML de la memoria*/
		end

		-- cargamos tipo de jornada en caso de que haya
	set @subxml = (select TOP 1 TipoDeJornadaProximaSemana FROM @TablaOperaciones WHERE id = @CursorTestID)
	if @subxml is not null
		begin
			EXEC sp_xml_preparedocument @hdoc OUTPUT, @subxml/*Toma el identificador y a la variable con el documento y las asocia*/
			--if(@Fecha_Actual = @Fin_Semana)
			--begin
				INSERT INTO dbo.Jornada(IdTipoJornada,IdEmpleado)
					SELECT IdJornada,(Select top 1 ID from dbo.empleado c where c.ValorDocumentoIdentidad = cr.ValorDocumentoIdentidad)
					FROM OPENXML (@hdoc,'/root/TipoDeJornadaProximaSemana',3)
						WITH (
							IdJornada int,
							ValorDocumentoIdentidad int
						) cr
			--end
			EXEC sp_xml_removedocument @hdoc/*Remueve el documento XML de la memoria*/
		end

		-- cargamosmarca de asistencia en caso de que haya
	begin transaction Marca
	set @subxml = (select TOP 1 MarcaDeAsistencia FROM @TablaOperaciones WHERE id = @CursorTestID)
	if @subxml is not null
		begin
			EXEC sp_xml_preparedocument @hdoc OUTPUT, @subxml/*Toma el identificador y a la variable con el documento y las asocia*/
			
			INSERT INTO dbo.MarcasAsistencia(FechaEntrada,FechaSalida,ValorDocumentoIdentificacion)
			SELECT * FROM OPENXML (@hdoc,'/root/MarcaDeAsistencia',3)
				WITH (
					FechaEntrada datetime,
					FechaSalida datetime,
					ValorDocumentoIdentidad int
				)

			EXEC dbo.SPMOVIMIENTOS @Fecha_Actual,@Fin_Semana

			
			--set @cntx = 1;
			--select @cntrendx = COUNT(0) from dbo.MarcasAsistencia;
			--while @cntx <= @cntrendx
			--begin
				
				--set @horas = DATEDIFF(hour, (select TOP 1 FechaEntrada FROM dbo.MarcasAsistencia WHERE id = @cntx), (select TOP 1 FechaSalida FROM dbo.MarcasAsistencia WHERE id = @cntx))
				--set @monto = (@horas * (select top 1 SalarioXHora from dbo.Puestos cr where cr.ID = (select top 1 IdPuesto FROM dbo.Empleado c where c.ValorDocumentoIdentidad = (select TOP 1 ValorDocumentoIdentidad FROM dbo.MarcasAsistencia WHERE id = @cntx)))   )
				--begin
				
					--INSERT INTO dbo.MovimientoPlanilla(Fecha,Monto,IdTipoMov)
					--SELECT FechaSalida,@monto,1 FROM dbo.MarcasAsistencia WHERE ID = @cntx and CONVERT(DATE,FechaSalida) = @Fecha_Actual

					--SET IDENTITY_INSERT dbo.MovimientoHoras ON
					--INSERT INTO dbo.MovimientoHoras(ID,IdMarcaAsistencia)
					--SELECT ID,1 FROM dbo.MovimientoPlanilla
					--SET IDENTITY_INSERT dbo.MovimientoHoras OFF

				--end
				--set @cntx = @cntx +1
			--end
			EXEC sp_xml_removedocument @hdoc/*Remueve el documento XML de la memoria*/

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
	--EXEC dbo.SPMOVIMIENTOS3 @Fecha_Actual
	--EXEC dbo.SPMOVIMIENTOS2 @Fecha_Actual
	--SELECT * FROM dbo.MovimientoPlanilla
	
	

	SET @CursorTestID = @CursorTestID + 1 
end
EXEC dbo.SETNETO   
