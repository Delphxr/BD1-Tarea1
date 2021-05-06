/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.MesPlantilla
	(
	ID int NOT NULL,
	FechaInicio date NOT NULL,
	FechaFin date NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.MesPlantilla ADD CONSTRAINT
	PK_MesPlantilla PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.MesPlantilla SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.SemanaPlantilla
	(
	ID int NOT NULL,
	IdMesPlantilla int NOT NULL,
	FechaInicio date NOT NULL,
	FechaFin date NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.SemanaPlantilla ADD CONSTRAINT
	PK_SemanaPlantilla PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.SemanaPlantilla ADD CONSTRAINT
	FK_SemanaPlantilla_MesPlantilla FOREIGN KEY
	(
	IdMesPlantilla
	) REFERENCES dbo.MesPlantilla
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.SemanaPlantilla SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.TipoJornada
	(
	ID int NOT NULL,
	Nombre varchar(50) NOT NULL,
	HoraInicio time(7) NOT NULL,
	HoraFIn time(7) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.TipoJornada ADD CONSTRAINT
	PK_TipoJornada PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.TipoJornada SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.TipoDocIdent
	(
	ID int NOT NULL,
	Nombre varchar(50) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.TipoDocIdent ADD CONSTRAINT
	PK_TipoDocIdent PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.TipoDocIdent SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.TipoDeduccion
	(
	ID int NOT NULL,
	Nombre varchar(50) NOT NULL,
	Obligatoria bit NOT NULL,
	Porcentual bit NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.TipoDeduccion ADD CONSTRAINT
	PK_TipoDeduccion PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.TipoDeduccion SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Puestos
	(
	ID int NOT NULL,
	Nombre varchar(50) NOT NULL,
	SalarioXHora money NOT NULL,
	Visible bit NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Puestos ADD CONSTRAINT
	PK_Puestos PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.Puestos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Departamentos
	(
	ID int NOT NULL,
	Nombre varchar(50) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Departamentos ADD CONSTRAINT
	PK_Departamentos PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.Departamentos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Empleados
	(
	ID int NOT NULL IDENTITY (1, 1),
	Nombre varchar(100) NOT NULL,
	IdTipoIdentificacion int NOT NULL,
	ValorDocumentoIdentificacion varchar(10) NOT NULL,
	IdDepartamento int NOT NULL,
	IdPuesto int NOT NULL,
	FechaNacimiento date NOT NULL,
	[Visible|] bit NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Empleados ADD CONSTRAINT
	PK_Empleados PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.Empleados ADD CONSTRAINT
	FK_Empleados_Departamentos FOREIGN KEY
	(
	IdDepartamento
	) REFERENCES dbo.Departamentos
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Empleados ADD CONSTRAINT
	FK_Empleados_Puestos FOREIGN KEY
	(
	IdPuesto
	) REFERENCES dbo.Puestos
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Empleados ADD CONSTRAINT
	FK_Empleados_TipoDocIdent FOREIGN KEY
	(
	IdTipoIdentificacion
	) REFERENCES dbo.TipoDocIdent
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Empleados SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Jornada
	(
	ID int NOT NULL IDENTITY (1, 1),
	IdEmpleado int NULL,
	IdTipoJornada int NULL,
	IdSemanaPlantilla int NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Jornada ADD CONSTRAINT
	PK_Jornada PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.Jornada ADD CONSTRAINT
	FK_Jornada_Empleados FOREIGN KEY
	(
	IdEmpleado
	) REFERENCES dbo.Empleados
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Jornada ADD CONSTRAINT
	FK_Jornada_TipoJornada FOREIGN KEY
	(
	IdTipoJornada
	) REFERENCES dbo.TipoJornada
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Jornada ADD CONSTRAINT
	FK_Jornada_SemanaPlantilla FOREIGN KEY
	(
	IdSemanaPlantilla
	) REFERENCES dbo.SemanaPlantilla
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Jornada SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.MarcaAsistencia
	(
	ID int NOT NULL,
	FechaEntrega datetime NOT NULL,
	FechaSalida datetime NOT NULL,
	IdJornada int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.MarcaAsistencia ADD CONSTRAINT
	PK_MarcaAsistencia PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.MarcaAsistencia ADD CONSTRAINT
	FK_MarcaAsistencia_Jornada FOREIGN KEY
	(
	IdJornada
	) REFERENCES dbo.Jornada
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.MarcaAsistencia SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.DeduccionXEmp
	(
	ID int NOT NULL,
	IdEmpleado int NOT NULL,
	IdTipoDeduccion int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.DeduccionXEmp ADD CONSTRAINT
	PK_DeduccionXEmp PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.DeduccionXEmp ADD CONSTRAINT
	FK_DeduccionXEmp_Empleados FOREIGN KEY
	(
	IdEmpleado
	) REFERENCES dbo.Empleados
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.DeduccionXEmp ADD CONSTRAINT
	FK_DeduccionXEmp_TipoDeduccion FOREIGN KEY
	(
	IdTipoDeduccion
	) REFERENCES dbo.TipoDeduccion
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.DeduccionXEmp SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Administradores
	(
	Usuario varchar(50) NOT NULL,
	Contraseña varchar(50) NOT NULL,
	Tipo int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Administradores ADD CONSTRAINT
	PK_Administradores PRIMARY KEY CLUSTERED 
	(
	Usuario
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.Administradores SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
