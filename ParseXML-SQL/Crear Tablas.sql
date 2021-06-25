USE [PlanillaObrera_BD]
GO
/****** Object:  Table [dbo].[DeduccionesXEmpleado]    Script Date: 24/06/2021 04:13:09 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeduccionesXEmpleado](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[IdEmpleado] [int] NOT NULL,
	[IdTipoDeduccion] [int] NOT NULL,
	[Monto] [money] NOT NULL,
	[Visible] [bit] NOT NULL,
 CONSTRAINT [PK_DeduccionesXEmpleado] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DeduccionesXMesXEmpleado]    Script Date: 24/06/2021 04:13:09 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeduccionesXMesXEmpleado](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Monto] [money] NOT NULL,
	[IdPlanillaXMesXEmpleado] [int] NOT NULL,
	[IdMovimiento] [int] NOT NULL,
	[IdEmpleado] [int] NOT NULL,
	[IdMes] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Departamentos]    Script Date: 24/06/2021 04:13:09 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Departamentos](
	[ID] [int] NOT NULL,
	[Nombre] [varchar](128) NOT NULL,
 CONSTRAINT [PK_dbo.Departamentos] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Empleado]    Script Date: 24/06/2021 04:13:09 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Empleado](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](128) NOT NULL,
	[IdTipoIdentificacion] [int] NOT NULL,
	[ValorDocumentoIdentidad] [varchar](16) NOT NULL,
	[IdDepartamento] [int] NOT NULL,
	[IdPuesto] [int] NOT NULL,
	[IdUsuario] [int] NOT NULL,
	[FechaNacimiento] [date] NOT NULL,
	[Visible] [bit] NOT NULL,
 CONSTRAINT [PK_dbo.Empleados] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Feriados]    Script Date: 24/06/2021 04:13:09 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Feriados](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Fecha] [date] NOT NULL,
	[Nombre] [varchar](128) NOT NULL,
 CONSTRAINT [PK_dbo.Feriados] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Historial]    Script Date: 24/06/2021 04:13:09 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Historial](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[IdEmpleado] [int] NOT NULL,
	[ValorModificado] [varchar](100) NOT NULL,
	[ValorAnterior] [varchar](100) NOT NULL,
	[ValorNuevo] [varchar](100) NOT NULL,
	[Fecha] [date] NOT NULL,
 CONSTRAINT [PK_Historial] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Jornada]    Script Date: 24/06/2021 04:13:09 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Jornada](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[IdTipoJornada] [int] NOT NULL,
	[IdEmpleado] [int] NOT NULL,
 CONSTRAINT [PK_dbo.Jornada] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MarcasAsistencia]    Script Date: 24/06/2021 04:13:09 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MarcasAsistencia](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[FechaEntrada] [datetime] NOT NULL,
	[FechaSalida] [datetime] NOT NULL,
	[ValorDocumentoIdentidad] [varchar](24) NOT NULL,
 CONSTRAINT [PK_dbo.MarcasAsistencia] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MesPlanilla]    Script Date: 24/06/2021 04:13:09 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MesPlanilla](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[FechaInicio] [date] NOT NULL,
	[FechaFin] [date] NOT NULL,
 CONSTRAINT [PK_dbo.MesPlanilla] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MovimientoDeduccion]    Script Date: 24/06/2021 04:13:09 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MovimientoDeduccion](
	[ID] [int] NOT NULL,
	[IdTipoDeduccion] [int] NOT NULL,
 CONSTRAINT [PK_dbo.MovimientoDeduccion] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MovimientoHoras]    Script Date: 24/06/2021 04:13:09 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MovimientoHoras](
	[ID] [int] NOT NULL,
	[IdMarcaAsistencia] [int] NOT NULL,
 CONSTRAINT [PK_dbo.MovimientoHoras] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MovimientoPlanilla]    Script Date: 24/06/2021 04:13:09 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MovimientoPlanilla](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Fecha] [date] NOT NULL,
	[Monto] [money] NOT NULL,
	[IdTipoMov] [int] NOT NULL,
	[IdEmpleado] [int] NOT NULL,
	[Visible] [bit] NOT NULL,
 CONSTRAINT [PK_dbo.MovimientoPlanilla] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PlanillaXMesXEmpleado]    Script Date: 24/06/2021 04:13:09 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PlanillaXMesXEmpleado](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SalarioNeto] [money] NOT NULL,
	[SalarioBruto] [money] NOT NULL,
	[TotalDeducciones] [money] NOT NULL,
	[IdEmpleado] [int] NOT NULL,
	[idMes] [int] NOT NULL,
 CONSTRAINT [PK_dbo.PlanillaXMesXEmpleado] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PlanillaXSemanaXEmpleado]    Script Date: 24/06/2021 04:13:09 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PlanillaXSemanaXEmpleado](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SalarioBruto] [money] NOT NULL,
	[TotalDeducciones] [money] NOT NULL,
	[SalarioNeto] [money] NOT NULL,
	[IdEmpleado] [int] NOT NULL,
	[IdSemana] [int] NOT NULL,
	[IdMovimientoPlanilla] [int] NOT NULL,
	[IdPlanillaXMesXEmpleado] [int] NOT NULL,
 CONSTRAINT [PK_dbo.PlanillaXSemanaXEmpleado] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Puestos]    Script Date: 24/06/2021 04:13:09 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Puestos](
	[ID] [int] NOT NULL,
	[Nombre] [varchar](128) NOT NULL,
	[SalarioXHora] [money] NOT NULL,
	[Visible] [bit] NOT NULL,
 CONSTRAINT [PK_dbo.Puestos] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SemanaPlanilla]    Script Date: 24/06/2021 04:13:09 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SemanaPlanilla](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[FechaInicio] [date] NOT NULL,
	[Fechafin] [date] NOT NULL,
	[IdMes] [int] NULL,
 CONSTRAINT [PK_dbo.SemanaPlanilla] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoDeduccion]    Script Date: 24/06/2021 04:13:09 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoDeduccion](
	[ID] [int] NOT NULL,
	[Nombre] [varchar](50) NOT NULL,
	[Obligatorio] [bit] NOT NULL,
	[Porcentual] [bit] NOT NULL,
	[Valor] [money] NOT NULL,
 CONSTRAINT [PK_dbo.TipoDeduccion] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tipoDocIdent]    Script Date: 24/06/2021 04:13:09 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tipoDocIdent](
	[ID] [int] NOT NULL,
	[Nombre] [varchar](128) NOT NULL,
 CONSTRAINT [PK_dbo.tipoDocIdent] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoJornada]    Script Date: 24/06/2021 04:13:09 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoJornada](
	[ID] [int] NOT NULL,
	[Nombre] [varchar](128) NOT NULL,
	[HoraEntrada] [time](7) NOT NULL,
	[HoraSalida] [time](7) NOT NULL,
 CONSTRAINT [PK_dbo.TipoJornada] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoMovimiento]    Script Date: 24/06/2021 04:13:09 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoMovimiento](
	[ID] [int] NOT NULL,
	[Nombre] [varchar](128) NOT NULL,
 CONSTRAINT [PK_dbo.TipoMovimiento] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Usuarios]    Script Date: 24/06/2021 04:13:09 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Usuarios](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Username] [varchar](128) NOT NULL,
	[Pwd] [varchar](128) NOT NULL,
	[Tipo] [int] NOT NULL,
 CONSTRAINT [PK_Usuarios] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MovimientoPlanilla] ADD  CONSTRAINT [DF_MovimientoPlanilla_Visible]  DEFAULT ((1)) FOR [Visible]
GO
ALTER TABLE [dbo].[Puestos] ADD  CONSTRAINT [DF_dbo.Puestos_Visible]  DEFAULT ((1)) FOR [Visible]
GO
ALTER TABLE [dbo].[DeduccionesXEmpleado]  WITH CHECK ADD  CONSTRAINT [FK_DeduccionesXEmpleado_Empleado] FOREIGN KEY([IdEmpleado])
REFERENCES [dbo].[Empleado] ([ID])
GO
ALTER TABLE [dbo].[DeduccionesXEmpleado] CHECK CONSTRAINT [FK_DeduccionesXEmpleado_Empleado]
GO
ALTER TABLE [dbo].[DeduccionesXEmpleado]  WITH CHECK ADD  CONSTRAINT [FK_DeduccionesXEmpleado_TipoDeduccion] FOREIGN KEY([IdTipoDeduccion])
REFERENCES [dbo].[TipoDeduccion] ([ID])
GO
ALTER TABLE [dbo].[DeduccionesXEmpleado] CHECK CONSTRAINT [FK_DeduccionesXEmpleado_TipoDeduccion]
GO
ALTER TABLE [dbo].[DeduccionesXMesXEmpleado]  WITH CHECK ADD  CONSTRAINT [FK_dbo.DeduccionesXMesXEmpleado_dbo.Empleados] FOREIGN KEY([IdEmpleado])
REFERENCES [dbo].[Empleado] ([ID])
GO
ALTER TABLE [dbo].[DeduccionesXMesXEmpleado] CHECK CONSTRAINT [FK_dbo.DeduccionesXMesXEmpleado_dbo.Empleados]
GO
ALTER TABLE [dbo].[DeduccionesXMesXEmpleado]  WITH CHECK ADD  CONSTRAINT [FK_dbo.DeduccionesXMesXEmpleado_dbo.MesPlanilla] FOREIGN KEY([IdMes])
REFERENCES [dbo].[MesPlanilla] ([ID])
GO
ALTER TABLE [dbo].[DeduccionesXMesXEmpleado] CHECK CONSTRAINT [FK_dbo.DeduccionesXMesXEmpleado_dbo.MesPlanilla]
GO
ALTER TABLE [dbo].[DeduccionesXMesXEmpleado]  WITH CHECK ADD  CONSTRAINT [FK_dbo.DeduccionesXMesXEmpleado_dbo.MovimientoPlanilla] FOREIGN KEY([IdMovimiento])
REFERENCES [dbo].[MovimientoPlanilla] ([ID])
GO
ALTER TABLE [dbo].[DeduccionesXMesXEmpleado] CHECK CONSTRAINT [FK_dbo.DeduccionesXMesXEmpleado_dbo.MovimientoPlanilla]
GO
ALTER TABLE [dbo].[DeduccionesXMesXEmpleado]  WITH CHECK ADD  CONSTRAINT [FK_dbo.DeduccionesXMesXEmpleado_dbo.PlanillaXMesXEmpleado] FOREIGN KEY([IdPlanillaXMesXEmpleado])
REFERENCES [dbo].[PlanillaXMesXEmpleado] ([ID])
GO
ALTER TABLE [dbo].[DeduccionesXMesXEmpleado] CHECK CONSTRAINT [FK_dbo.DeduccionesXMesXEmpleado_dbo.PlanillaXMesXEmpleado]
GO
ALTER TABLE [dbo].[Empleado]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Empleados_dbo.Departamentos] FOREIGN KEY([IdDepartamento])
REFERENCES [dbo].[Departamentos] ([ID])
GO
ALTER TABLE [dbo].[Empleado] CHECK CONSTRAINT [FK_dbo.Empleados_dbo.Departamentos]
GO
ALTER TABLE [dbo].[Empleado]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Empleados_dbo.Puestos] FOREIGN KEY([IdPuesto])
REFERENCES [dbo].[Puestos] ([ID])
GO
ALTER TABLE [dbo].[Empleado] CHECK CONSTRAINT [FK_dbo.Empleados_dbo.Puestos]
GO
ALTER TABLE [dbo].[Empleado]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Empleados_dbo.tipoDocIdent] FOREIGN KEY([IdTipoIdentificacion])
REFERENCES [dbo].[tipoDocIdent] ([ID])
GO
ALTER TABLE [dbo].[Empleado] CHECK CONSTRAINT [FK_dbo.Empleados_dbo.tipoDocIdent]
GO
ALTER TABLE [dbo].[Empleado]  WITH CHECK ADD  CONSTRAINT [FK_Empleado_Usuarios] FOREIGN KEY([IdUsuario])
REFERENCES [dbo].[Usuarios] ([ID])
GO
ALTER TABLE [dbo].[Empleado] CHECK CONSTRAINT [FK_Empleado_Usuarios]
GO
ALTER TABLE [dbo].[Historial]  WITH CHECK ADD  CONSTRAINT [FK_Historial_Empleado] FOREIGN KEY([IdEmpleado])
REFERENCES [dbo].[Empleado] ([ID])
GO
ALTER TABLE [dbo].[Historial] CHECK CONSTRAINT [FK_Historial_Empleado]
GO
ALTER TABLE [dbo].[Jornada]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Jornada_dbo.Empleados] FOREIGN KEY([IdEmpleado])
REFERENCES [dbo].[Empleado] ([ID])
GO
ALTER TABLE [dbo].[Jornada] CHECK CONSTRAINT [FK_dbo.Jornada_dbo.Empleados]
GO
ALTER TABLE [dbo].[Jornada]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Jornada_dbo.TipoJornada] FOREIGN KEY([IdTipoJornada])
REFERENCES [dbo].[TipoJornada] ([ID])
GO
ALTER TABLE [dbo].[Jornada] CHECK CONSTRAINT [FK_dbo.Jornada_dbo.TipoJornada]
GO
ALTER TABLE [dbo].[MovimientoDeduccion]  WITH CHECK ADD  CONSTRAINT [FK_dbo.MovimientoDeduccion_dbo.TipoDeduccion] FOREIGN KEY([IdTipoDeduccion])
REFERENCES [dbo].[TipoDeduccion] ([ID])
GO
ALTER TABLE [dbo].[MovimientoDeduccion] CHECK CONSTRAINT [FK_dbo.MovimientoDeduccion_dbo.TipoDeduccion]
GO
ALTER TABLE [dbo].[MovimientoDeduccion]  WITH CHECK ADD  CONSTRAINT [FK_MovimientoDeduccion_MovimientoPlanilla] FOREIGN KEY([ID])
REFERENCES [dbo].[MovimientoPlanilla] ([ID])
GO
ALTER TABLE [dbo].[MovimientoDeduccion] CHECK CONSTRAINT [FK_MovimientoDeduccion_MovimientoPlanilla]
GO
ALTER TABLE [dbo].[MovimientoHoras]  WITH CHECK ADD  CONSTRAINT [FK_dbo.MovimientoHoras_dbo.MarcasAsistencia] FOREIGN KEY([IdMarcaAsistencia])
REFERENCES [dbo].[MarcasAsistencia] ([ID])
GO
ALTER TABLE [dbo].[MovimientoHoras] CHECK CONSTRAINT [FK_dbo.MovimientoHoras_dbo.MarcasAsistencia]
GO
ALTER TABLE [dbo].[MovimientoHoras]  WITH CHECK ADD  CONSTRAINT [FK_MovimientoHoras_MovimientoPlanilla] FOREIGN KEY([ID])
REFERENCES [dbo].[MovimientoPlanilla] ([ID])
GO
ALTER TABLE [dbo].[MovimientoHoras] CHECK CONSTRAINT [FK_MovimientoHoras_MovimientoPlanilla]
GO
ALTER TABLE [dbo].[MovimientoPlanilla]  WITH CHECK ADD  CONSTRAINT [FK_MovimientoPlanilla_TipoMovimiento] FOREIGN KEY([IdTipoMov])
REFERENCES [dbo].[TipoMovimiento] ([ID])
GO
ALTER TABLE [dbo].[MovimientoPlanilla] CHECK CONSTRAINT [FK_MovimientoPlanilla_TipoMovimiento]
GO
ALTER TABLE [dbo].[PlanillaXMesXEmpleado]  WITH CHECK ADD  CONSTRAINT [FK_dbo.PlanillaXMesXEmpleado_dbo.Empleados] FOREIGN KEY([IdEmpleado])
REFERENCES [dbo].[Empleado] ([ID])
GO
ALTER TABLE [dbo].[PlanillaXMesXEmpleado] CHECK CONSTRAINT [FK_dbo.PlanillaXMesXEmpleado_dbo.Empleados]
GO
ALTER TABLE [dbo].[PlanillaXMesXEmpleado]  WITH CHECK ADD  CONSTRAINT [FK_dbo.PlanillaXMesXEmpleado_dbo.MesPlanilla] FOREIGN KEY([idMes])
REFERENCES [dbo].[MesPlanilla] ([ID])
GO
ALTER TABLE [dbo].[PlanillaXMesXEmpleado] CHECK CONSTRAINT [FK_dbo.PlanillaXMesXEmpleado_dbo.MesPlanilla]
GO
ALTER TABLE [dbo].[PlanillaXSemanaXEmpleado]  WITH CHECK ADD  CONSTRAINT [FK_dbo.PlanillaXSemanaXEmpleado_dbo.Empleados] FOREIGN KEY([IdEmpleado])
REFERENCES [dbo].[Empleado] ([ID])
GO
ALTER TABLE [dbo].[PlanillaXSemanaXEmpleado] CHECK CONSTRAINT [FK_dbo.PlanillaXSemanaXEmpleado_dbo.Empleados]
GO
ALTER TABLE [dbo].[PlanillaXSemanaXEmpleado]  WITH CHECK ADD  CONSTRAINT [FK_dbo.PlanillaXSemanaXEmpleado_dbo.MovimientoPlanilla] FOREIGN KEY([IdMovimientoPlanilla])
REFERENCES [dbo].[MovimientoPlanilla] ([ID])
GO
ALTER TABLE [dbo].[PlanillaXSemanaXEmpleado] CHECK CONSTRAINT [FK_dbo.PlanillaXSemanaXEmpleado_dbo.MovimientoPlanilla]
GO
ALTER TABLE [dbo].[PlanillaXSemanaXEmpleado]  WITH CHECK ADD  CONSTRAINT [FK_dbo.PlanillaXSemanaXEmpleado_dbo.PlanillaXMesXEmpleado] FOREIGN KEY([IdPlanillaXMesXEmpleado])
REFERENCES [dbo].[PlanillaXMesXEmpleado] ([ID])
GO
ALTER TABLE [dbo].[PlanillaXSemanaXEmpleado] CHECK CONSTRAINT [FK_dbo.PlanillaXSemanaXEmpleado_dbo.PlanillaXMesXEmpleado]
GO
ALTER TABLE [dbo].[PlanillaXSemanaXEmpleado]  WITH CHECK ADD  CONSTRAINT [FK_dbo.PlanillaXSemanaXEmpleado_dbo.SemanaPlanilla] FOREIGN KEY([IdSemana])
REFERENCES [dbo].[SemanaPlanilla] ([ID])
GO
ALTER TABLE [dbo].[PlanillaXSemanaXEmpleado] CHECK CONSTRAINT [FK_dbo.PlanillaXSemanaXEmpleado_dbo.SemanaPlanilla]
GO
ALTER TABLE [dbo].[SemanaPlanilla]  WITH CHECK ADD  CONSTRAINT [FK_dbo.SemanaPlanilla_dbo.MesPlanilla] FOREIGN KEY([IdMes])
REFERENCES [dbo].[MesPlanilla] ([ID])
GO
ALTER TABLE [dbo].[SemanaPlanilla] CHECK CONSTRAINT [FK_dbo.SemanaPlanilla_dbo.MesPlanilla]
GO
