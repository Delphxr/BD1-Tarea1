-- Creamos las tablas necesarias para el funcionamiento de la BD
-- Usamos este procedure para que sean iguales en todas las instancias de la BD

-- Creamos la tabla para el tipo de documento de identidad
CREATE TABLE dbo.TipoDocumentoIdentidad (
	Id INT NOT NULL PRIMARY KEY,
	Nombre VARCHAR(128) NOT NULL,
)

-- Creamos la tabla para los puestos
CREATE TABLE dbo.Puesto (
	Id INT IDENTITY(1,1) NOT NULL,
	-- Como el mapeo es mediante el nombre, el nombre es el primary key
	Nombre VARCHAR(128) NOT NULL PRIMARY KEY,
	SalarioXHora INT NOT NULL
)

-- Creamos la tabla para el departamento
CREATE TABLE dbo.Departamento(
	Id INT NOT NULL PRIMARY KEY,
	Nombre VARCHAR(128) NOT NULL
)

-- Creamos la tabla para los empleados
CREATE TABLE dbo.Empleado(
	Id INT IDENTITY(1,1) PRIMARY KEY,
	Nombre VARCHAR(128) NOT NULL,
	IdTipoDocumentoIdentidad INT NOT NULL FOREIGN KEY REFERENCES dbo.TipoDocumentoIdentidad(Id),
	ValorDocumentoIdentificacion INT NOT NULL,
	IdDepartamento INT NOT NULL FOREIGN KEY REFERENCES dbo.Departamento(Id),
	Puesto VARCHAR(128) NOT NULL FOREIGN KEY REFERENCES dbo.Puesto(Nombre),
	FechaNacimiento VARCHAR(128) NOT NULL
)