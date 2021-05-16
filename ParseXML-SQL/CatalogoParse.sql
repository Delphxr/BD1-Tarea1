DECLARE @Datos xml/*Declaramos la variable Datos como un tipo XML*/
 
SELECT @Datos = D  /*El select imprime los contenidos del XML para dejarlo cargado en memoria*/
FROM OPENROWSET (BULK 'C:\Users\jenar\OneDrive\Documentos\Datos_Tarea2.xml', SINGLE_BLOB) AS Datos(D)
    
DECLARE @hdoc int /*Creamos hdoc que va a ser un identificador*/
    
EXEC sp_xml_preparedocument @hdoc OUTPUT, @Datos/*Toma el identificador y a la variable con el documento y las asocia*/


DELETE FROM dbo.Puestos/*Limpia la tabla Puestos*/

INSERT INTO dbo.Puestos/*Inserta en la tabla Puestos*/
SELECT Id,Nombre,SalarioXHora,0
FROM OPENXML (@hdoc, '/Datos/Catalogos/Puestos/Puesto' , 1)/*Lee los contenidos del XML y para eso necesita un identificador,el PATH del nodo y el 1 que sirve 
para retornar solo atributos*/
WITH(/*Dentro del WITH se pone el nombre y el tipo de los atributos a retornar*/
	Id int,
    Nombre VARCHAR(50),
	SalarioXHora money
    )


DELETE FROM dbo.Departamentos/*Limpia la tabla Departamentos*/

INSERT INTO dbo.Departamentos/*Inserta en la tabla Departamentos*/
SELECT *
FROM OPENXML (@hdoc, '/Datos/Catalogos/Departamentos/Departamento' , 1)/*Lee los contenidos del XML y para eso necesita un identificador,el PATH del nodo y el 
1 que sirve para retornar solo atributos*/
WITH(/*Dentro del WITH se pone el nombre y el tipo de los atributos a retornar*/
	Id int,
    Nombre VARCHAR(50)
    )


DELETE FROM dbo.TipoDocIdent/*Limpia la tabla TipoDocIdent*/

INSERT INTO dbo.TipoDocIdent/*Inserta en la tabla TipoDocIdent*/
SELECT *
FROM OPENXML (@hdoc, '/Datos/Catalogos/Tipos_de_Documento_de_Identificacion/TipoIdDoc' , 1)/*Lee los contenidos del XML y para eso necesita un identificador,el 
PATH del nodo y el 1 que sirve para retornar solo atributos*/
WITH(/*Dentro del WITH se pone el nombre y el tipo de los atributos a retornar*/
	Id int,
    Nombre VARCHAR(20)
    )
    
DELETE FROM dbo.TipoJornada 

INSERT INTO dbo.TipoJornada(ID,Nombre,HoraEntrada,HoraSalida)
SELECT Id,Nombre,HoraEntrada,HoraSalida
FROM OPENXML (@hdoc, '/Datos/Catalogos/TiposDeJornada/TipoDeJornada' , 1)/*Lee los contenidos del XML y para eso necesita un identificador,el 
PATH del nodo y el 1 que sirve para retornar solo atributos*/
WITH(/*Dentro del WITH se pone el nombre y el tipo de los atributos a retornar*/
	HoraEntrada time(7),
	HoraSalida time(7),
	Id int,
	Nombre varchar(128)
	)

DELETE FROM dbo.TipoMovimiento 

INSERT INTO dbo.TipoMovimiento(ID,Nombre)
SELECT Id,Nombre
FROM OPENXML (@hdoc, '/Datos/Catalogos/TiposDeMovimiento/TipoDeMovimiento' , 1)/*Lee los contenidos del XML y para eso necesita un identificador,el 
PATH del nodo y el 1 que sirve para retornar solo atributos*/
WITH(/*Dentro del WITH se pone el nombre y el tipo de los atributos a retornar*/
	Id int,
	Nombre varchar(128)
	)

DELETE FROM dbo.Feriados
DBCC CHECKIDENT ('Feriados', RESEED, 0)/*Reinicia el identify*/

INSERT INTO dbo.Feriados(Fecha,Nombre)
SELECT Fecha,Nombre 
FROM OPENXML (@hdoc, '/Datos/Catalogos/Feriados/Feriado' , 1)/*Lee los contenidos del XML y para eso necesita un identificador,el 
PATH del nodo y el 1 que sirve para retornar solo atributos*/
WITH(/*Dentro del WITH se pone el nombre y el tipo de los atributos a retornar*/
	Fecha date,
	Nombre varchar(128)
	)

DELETE FROM dbo.TipoDeduccion

INSERT INTO dbo.TipoDeduccion(ID,Nombre,Obligatorio,Porcentual,Valor)
SELECT *
FROM OPENXML (@hdoc, '/Datos/Catalogos/Deducciones/TipoDeDeduccion' , 1)/*Lee los contenidos del XML y para eso necesita un identificador,el 
PATH del nodo y el 1 que sirve para retornar solo atributos*/
WITH(/*Dentro del WITH se pone el nombre y el tipo de los atributos a retornar*/
	Id int,
	Nombre varchar(128),
	Obligatorio bit,
	Porcentual bit,
	Valor money
	)
 
DELETE FROM dbo.Usuarios/*Limpia la tabla Administradores*/

INSERT INTO dbo.Usuarios(Username,Pwd,Tipo)/*Inserta en la tabla Administradores*/
SELECT *
FROM OPENXML (@hdoc, '/Datos/Usuarios/Usuario' , 1)/*Lee los contenidos del XML y para eso necesita un identificador,el PATH del nodo y el 1 que sirve
para retornar solo atributos*/
WITH(/*Dentro del WITH se pone el nombre y el tipo de los atributos a retornar*/
    username VARCHAR(50),
	pwd VARCHAR(50),
	tipo int
    )
    
EXEC sp_xml_removedocument @hdoc/*Remueve el documento XML de la memoria*/
