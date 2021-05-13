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
CREATE TABLE dbo.[dbo.Puestos]
	(
	ID int NOT NULL,
	Nombre varchar(128) NOT NULL,
	SalarioXHora money NOT NULL,
	Visible bit NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.[dbo.Puestos] ADD CONSTRAINT
	[DF_dbo.Puestos_Visible] DEFAULT ((1)) FOR Visible
GO
ALTER TABLE dbo.[dbo.Puestos] ADD CONSTRAINT
	[PK_dbo.Puestos] PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.[dbo.Puestos] SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.[dbo.Departamentos]
	(
	ID int NOT NULL,
	Nombre varchar(128) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.[dbo.Departamentos] ADD CONSTRAINT
	[PK_dbo.Departamentos] PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.[dbo.Departamentos] SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.[dbo.tipoDocIdent]
	(
	ID int NOT NULL,
	Nombre varchar(128) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.[dbo.tipoDocIdent] ADD CONSTRAINT
	[PK_dbo.tipoDocIdent] PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.[dbo.tipoDocIdent] SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.[dbo.Empleado]
	(
	ID int NOT NULL IDENTITY (1, 1),
	Nombre varchar(128) NOT NULL,
	IdTipoIdentificacion int NOT NULL,
	ValorDocumentoIdentidad varchar(16) NOT NULL,
	IdDepartamento int NOT NULL,
	IdPuesto int NOT NULL,
	FechaNacimiento date NOT NULL,
	Visible bit NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.[dbo.Empleado] ADD CONSTRAINT
	[PK_dbo.Empleado] PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.[dbo.Empleado] ADD CONSTRAINT
	[FK_dbo.Empleado_dbo.Puestos] FOREIGN KEY
	(
	IdPuesto
	) REFERENCES dbo.[dbo.Puestos]
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.[dbo.Empleado] ADD CONSTRAINT
	[FK_dbo.Empleado_dbo.Departamentos] FOREIGN KEY
	(
	IdDepartamento
	) REFERENCES dbo.[dbo.Departamentos]
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.[dbo.Empleado] ADD CONSTRAINT
	[FK_dbo.Empleado_dbo.tipoDocIdent] FOREIGN KEY
	(
	IdTipoIdentificacion
	) REFERENCES dbo.[dbo.tipoDocIdent]
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.[dbo.Empleado] SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.[dbo.TipoJornada]
	(
	ID int NOT NULL,
	Nombre varchar(128) NOT NULL,
	HoraEntrada time(7) NOT NULL,
	HoraSalida time(7) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.[dbo.TipoJornada] ADD CONSTRAINT
	[PK_dbo.TipoJornada] PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.[dbo.TipoJornada] SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.[dbo.Jornada]
	(
	ID int NOT NULL,
	IdTipoJornada int NOT NULL,
	IdEmpleado int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.[dbo.Jornada] ADD CONSTRAINT
	[PK_dbo.Jornada] PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.[dbo.Jornada] ADD CONSTRAINT
	[FK_dbo.Jornada_dbo.TipoJornada] FOREIGN KEY
	(
	IdTipoJornada
	) REFERENCES dbo.[dbo.TipoJornada]
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.[dbo.Jornada] ADD CONSTRAINT
	[FK_dbo.Jornada_dbo.Empleado] FOREIGN KEY
	(
	IdEmpleado
	) REFERENCES dbo.[dbo.Empleado]
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.[dbo.Jornada] SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.[dbo.MarcasAsistencia]
	(
	ID int NOT NULL,
	FechaEntrada datetime NOT NULL,
	FechaSalida datetime NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.[dbo.MarcasAsistencia] ADD CONSTRAINT
	[PK_dbo.MarcasAsistencia] PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.[dbo.MarcasAsistencia] SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.[dbo.TipoMovimiento]
	(
	ID int NOT NULL,
	Nombre varchar(128) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.[dbo.TipoMovimiento] ADD CONSTRAINT
	[PK_dbo.TipoMovimiento] PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.[dbo.TipoMovimiento] SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.[dbo.Feriados]
	(
	ID int NOT NULL,
	Fecha date NOT NULL,
	Nombre varchar(128) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.[dbo.Feriados] ADD CONSTRAINT
	[PK_dbo.Feriados] PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.[dbo.Feriados] SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.[dbo.TipoDeduccion]
	(
	ID int NOT NULL,
	Nombre varchar(50) NOT NULL,
	Obligatorio bit NOT NULL,
	Porcentual bit NOT NULL,
	Valor money NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.[dbo.TipoDeduccion] ADD CONSTRAINT
	[PK_dbo.TipoDeduccion] PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.[dbo.TipoDeduccion] SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Usuarios
	(
	ID int NOT NULL,
	Username varchar(128) NOT NULL,
	Pwd varchar(128) NOT NULL,
	Tipo int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Usuarios ADD CONSTRAINT
	PK_Usuarios PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.Usuarios SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.[dbo.MesPlanilla]
	(
	ID int NOT NULL IDENTITY (1, 1),
	Fecha date NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.[dbo.MesPlanilla] ADD CONSTRAINT
	[PK_dbo.MesPlanilla] PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.[dbo.MesPlanilla] SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.[dbo.SemanaPlanilla]
	(
	ID int NOT NULL IDENTITY (1, 1),
	FechaInicio date NOT NULL,
	Fechafin date NOT NULL,
	IdMes int NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.[dbo.SemanaPlanilla] ADD CONSTRAINT
	[PK_dbo.SemanaPlanilla] PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.[dbo.SemanaPlanilla] ADD CONSTRAINT
	[FK_dbo.SemanaPlanilla_dbo.MesPlanilla] FOREIGN KEY
	(
	IdMes
	) REFERENCES dbo.[dbo.MesPlanilla]
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.[dbo.SemanaPlanilla] SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.[dbo.PlanillaXMesXEmpleado]
	(
	ID int NOT NULL,
	SalarioNeto money NOT NULL,
	SalarioBruto money NOT NULL,
	TotalDeducciones money NOT NULL,
	IdEmpleado int NOT NULL,
	idMes int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.[dbo.PlanillaXMesXEmpleado] ADD CONSTRAINT
	[PK_dbo.PlanillaXMesXEmpleado] PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.[dbo.PlanillaXMesXEmpleado] ADD CONSTRAINT
	[FK_dbo.PlanillaXMesXEmpleado_dbo.MesPlanilla] FOREIGN KEY
	(
	idMes
	) REFERENCES dbo.[dbo.MesPlanilla]
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.[dbo.PlanillaXMesXEmpleado] ADD CONSTRAINT
	[FK_dbo.PlanillaXMesXEmpleado_dbo.Empleado] FOREIGN KEY
	(
	IdEmpleado
	) REFERENCES dbo.[dbo.Empleado]
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.[dbo.PlanillaXMesXEmpleado] SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.[dbo.MovimientoPlanilla]
	(
	ID int NOT NULL,
	Fecha date NOT NULL,
	Monto money NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.[dbo.MovimientoPlanilla] ADD CONSTRAINT
	[PK_dbo.MovimientoPlanilla] PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.[dbo.MovimientoPlanilla] SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.[dbo.PlanillaXSemanaXEmpleado]
	(
	ID int NOT NULL IDENTITY (1, 1),
	SalarioBruto money NOT NULL,
	TotalDeducciones money NOT NULL,
	SalarioNeto money NOT NULL,
	IdEmpleado int NOT NULL,
	IdSemana int NOT NULL,
	IdMovimientoPlanilla int NOT NULL,
	IdPlanillaXMesXEmpleado int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.[dbo.PlanillaXSemanaXEmpleado] ADD CONSTRAINT
	[PK_dbo.PlanillaXSemanaXEmpleado] PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.[dbo.PlanillaXSemanaXEmpleado] ADD CONSTRAINT
	[FK_dbo.PlanillaXSemanaXEmpleado_dbo.Empleado] FOREIGN KEY
	(
	IdEmpleado
	) REFERENCES dbo.[dbo.Empleado]
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.[dbo.PlanillaXSemanaXEmpleado] ADD CONSTRAINT
	[FK_dbo.PlanillaXSemanaXEmpleado_dbo.MovimientoPlanilla] FOREIGN KEY
	(
	IdMovimientoPlanilla
	) REFERENCES dbo.[dbo.MovimientoPlanilla]
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.[dbo.PlanillaXSemanaXEmpleado] ADD CONSTRAINT
	[FK_dbo.PlanillaXSemanaXEmpleado_dbo.PlanillaXMesXEmpleado] FOREIGN KEY
	(
	IdPlanillaXMesXEmpleado
	) REFERENCES dbo.[dbo.PlanillaXMesXEmpleado]
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.[dbo.PlanillaXSemanaXEmpleado] ADD CONSTRAINT
	[FK_dbo.PlanillaXSemanaXEmpleado_dbo.SemanaPlanilla] FOREIGN KEY
	(
	IdSemana
	) REFERENCES dbo.[dbo.SemanaPlanilla]
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.[dbo.PlanillaXSemanaXEmpleado] SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.[dbo.MovimientoHoras]
	(
	ID int NOT NULL IDENTITY (1, 1),
	IdTipoMovimiento int NOT NULL,
	IdMovPlanilla int NOT NULL,
	IdMarcaAsistencia int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.[dbo.MovimientoHoras] ADD CONSTRAINT
	[PK_dbo.MovimientoHoras] PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.[dbo.MovimientoHoras] ADD CONSTRAINT
	[FK_dbo.MovimientoHoras_dbo.TipoMovimiento] FOREIGN KEY
	(
	IdTipoMovimiento
	) REFERENCES dbo.[dbo.TipoMovimiento]
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.[dbo.MovimientoHoras] ADD CONSTRAINT
	[FK_dbo.MovimientoHoras_dbo.MovimientoPlanilla] FOREIGN KEY
	(
	IdMovPlanilla
	) REFERENCES dbo.[dbo.MovimientoPlanilla]
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.[dbo.MovimientoHoras] ADD CONSTRAINT
	[FK_dbo.MovimientoHoras_dbo.MarcasAsistencia] FOREIGN KEY
	(
	IdMarcaAsistencia
	) REFERENCES dbo.[dbo.MarcasAsistencia]
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.[dbo.MovimientoHoras] SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.[dbo.MovimientoDeduccion]
	(
	ID int NOT NULL,
	IdTipoDeduccion int NOT NULL,
	IdMovPlanilla int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.[dbo.MovimientoDeduccion] ADD CONSTRAINT
	[PK_dbo.MovimientoDeduccion] PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.[dbo.MovimientoDeduccion] ADD CONSTRAINT
	[FK_dbo.MovimientoDeduccion_dbo.TipoDeduccion] FOREIGN KEY
	(
	IdTipoDeduccion
	) REFERENCES dbo.[dbo.TipoDeduccion]
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.[dbo.MovimientoDeduccion] ADD CONSTRAINT
	[FK_dbo.MovimientoDeduccion_dbo.MovimientoPlanilla] FOREIGN KEY
	(
	IdMovPlanilla
	) REFERENCES dbo.[dbo.MovimientoPlanilla]
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.[dbo.MovimientoDeduccion] SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.[dbo.DeduccionesXMesXEmpleado]
	(
	ID int NOT NULL,
	Monto money NOT NULL,
	IdPlanillaXMesXEmpleado int NOT NULL,
	IdMovimiento int NOT NULL,
	IdEmpleado int NOT NULL,
	IdMes int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.[dbo.DeduccionesXMesXEmpleado] ADD CONSTRAINT
	[FK_dbo.DeduccionesXMesXEmpleado_dbo.PlanillaXMesXEmpleado] FOREIGN KEY
	(
	IdPlanillaXMesXEmpleado
	) REFERENCES dbo.[dbo.PlanillaXMesXEmpleado]
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.[dbo.DeduccionesXMesXEmpleado] ADD CONSTRAINT
	[FK_dbo.DeduccionesXMesXEmpleado_dbo.MovimientoPlanilla] FOREIGN KEY
	(
	IdMovimiento
	) REFERENCES dbo.[dbo.MovimientoPlanilla]
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.[dbo.DeduccionesXMesXEmpleado] ADD CONSTRAINT
	[FK_dbo.DeduccionesXMesXEmpleado_dbo.MesPlanilla] FOREIGN KEY
	(
	IdMes
	) REFERENCES dbo.[dbo.MesPlanilla]
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.[dbo.DeduccionesXMesXEmpleado] ADD CONSTRAINT
	[FK_dbo.DeduccionesXMesXEmpleado_dbo.Empleado] FOREIGN KEY
	(
	IdEmpleado
	) REFERENCES dbo.[dbo.Empleado]
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.[dbo.DeduccionesXMesXEmpleado] SET (LOCK_ESCALATION = TABLE)
GO
COMMIT