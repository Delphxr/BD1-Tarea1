DECLARE @Datos xml/*Declaramos la variable Datos como un tipo XML*/
 
SELECT @Datos = D  /*El select imprime los contenidos del XML para dejarlo cargado en memoria*/
FROM OPENROWSET (BULK 'D:\DatosXML.xml', SINGLE_BLOB) AS Datos(D)
    
DECLARE @hdoc int /*Creamos hdoc que va a ser un identificador*/
    
EXEC sp_xml_preparedocument @hdoc OUTPUT, @Datos/*Toma el identificador y a la variable con el documento y las asocia*/
INSERT INTO dbo.TipoDocIdent/*Inserta en la tabla TipoDocIdent*/
SELECT *
FROM OPENXML (@hdoc, '/Datos/Tipos_de_Documento_de_Identidad/TipoDocuIdentidad' , 1)/*Lee los contenidos del XML y para eso necesita un identificador,el 
PATH del nodo y el 1 que sirve para retornar solo atributos*/
WITH(/*Dentro del WITH se pone el nombre y el tipo de los atributos a retornar*/
	Id int,
    Nombre VARCHAR(20)
    )
INSERT INTO dbo.Puestos/*Inserta en la tabla Puestos*/
SELECT *
FROM OPENXML (@hdoc, '/Datos/Puestos/Puesto' , 1)/*Lee los contenidos del XML y para eso necesita un identificador,el PATH del nodo y el 1 que sirve 
para retornar solo atributos*/
WITH(/*Dentro del WITH se pone el nombre y el tipo de los atributos a retornar*/
	Id int,
    Nombre VARCHAR(50),
	SalarioXHora money,
	Visible bit
    )

INSERT INTO dbo.Departamentos/*Inserta en la tabla Departamentos*/
SELECT *
FROM OPENXML (@hdoc, '/Datos/Departamentos/Departamento' , 1)/*Lee los contenidos del XML y para eso necesita un identificador,el PATH del nodo y el 
1 que sirve para retornar solo atributos*/
WITH(/*Dentro del WITH se pone el nombre y el tipo de los atributos a retornar*/
	Id int,
	IdJefe int,
    Nombre VARCHAR(50)
    )
    
    
DELETE FROM dbo.Empleados/*Limpia la tabla empelados*/
DBCC CHECKIDENT ('Empleados', RESEED, 0)/*Reinicia el identify*/

INSERT INTO dbo.Empleados(Nombre,IdTipoIdentificacion,ValorDocumentoIdentificacion,IdDepartamento,IdPuesto,FechaNacimiento,Visible)/*Inserta en la tabla Empleados*/
SELECT *
FROM OPENXML (@hdoc, '/Datos/Empleados/Empleado' , 1)/*Lee los contenidos del XML y para eso necesita un identificador,el PATH del nodo y el 1 que sirve
para retornar solo atributos*/
WITH(/*Dentro del WITH se pone el nombre y el tipo de los atributos a retornar*/
    Nombre VARCHAR(100),
	IdTipoIdentificacion int,
	ValorDocumentoIdentificacion VARCHAR(10),
	IdDepartamento int,
	IdPuesto int,
	FechaNacimiento date,
	Visible bit
    )
 
INSERT INTO dbo.Administradores(Usuario,Contraseña,Nombre,Tipo)/*Inserta en la tabla Administradores*/
SELECT *
FROM OPENXML (@hdoc, '/Datos/Usuarios/Usuario' , 1)/*Lee los contenidos del XML y para eso necesita un identificador,el PATH del nodo y el 1 que sirve
para retornar solo atributos*/
WITH(/*Dentro del WITH se pone el nombre y el tipo de los atributos a retornar*/
    	Username VARCHAR(50),
	Pasword VARCHAR(50),
	Nombre VARCHAR(50),
	Tipo int
    )
    
EXEC sp_xml_removedocument @hdoc/*Remueve el documento XML de la memoria*/
