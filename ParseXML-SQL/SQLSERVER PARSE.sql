DECLARE @Datos xml
 
SELECT @Datos = D
FROM OPENROWSET (BULK 'D:\DatosXML.xml', SINGLE_BLOB) AS Datos(D)
    
DECLARE @hdoc int
    
EXEC sp_xml_preparedocument @hdoc OUTPUT, @Datos
INSERT INTO dbo.TipoDocIdent
SELECT *
FROM OPENXML (@hdoc, '/Datos/Tipos_de_Documento_de_Identidad/TipoDocuIdentidad' , 1)
WITH(
	Id int,
    Nombre VARCHAR(20)
    )
INSERT INTO dbo.Puestos
SELECT *
FROM OPENXML (@hdoc, '/Datos/Puestos/Puesto' , 1)
WITH(
	Id int,
    Nombre VARCHAR(50),
	SalarioXHora money
    )

INSERT INTO dbo.Departamentos
SELECT *
FROM OPENXML (@hdoc, '/Datos/Departamentos/Departamento' , 1)
WITH(
	Id int,
	IdJefe int,
    Nombre VARCHAR(50)
    )
    
    
DELETE FROM dbo.Empleados
DBCC CHECKIDENT ('Empleados', RESEED, 0)

INSERT INTO dbo.Empleados(Nombre,IdTipoIdentificacion,ValorDocumentoIdentificacion,IdDepartamento,IdPuesto,FechaNacimiento)
SELECT *
FROM OPENXML (@hdoc, '/Datos/Empleados/Empleado' , 1)
WITH(
    Nombre VARCHAR(100),
	IdTipoIdentificacion int,
	ValorDocumentoIdentificacion VARCHAR(10),
	IdDepartamento int,
	IdPuesto int,
	FechaNacimiento date
    )
 
DELETE FROM dbo.Usuarios
DBCC CHECKIDENT ('Usuarios', RESEED, 0)

INSERT INTO dbo.Usuarios(Username,Nombre,Pasword,tipo)
SELECT *
FROM OPENXML (@hdoc, '/Datos/Usuarios/Usuario' , 1)
WITH(
    Username VARCHAR(50),
	Nombre VARCHAR(100),
	Pasword Password,
	tipo int
    )
    
EXEC sp_xml_removedocument @hdoc
