CREATE TRIGGER [dbo].[trgAsociarEmpleadoDeduccion]
ON [dbo].[Empleado]
AFTER INSERT
AS



--tabla temporal donde vamos a almacenar las deducciones obligatorias
DECLARE @t TABLE(IdTipoDeduccion INT,porcentaje money)
DECLARE @d INT




-- seleccionamos todas las deducciones obligatorias y las ponermos en @t
INSERT INTO @t (IdTipoDeduccion,porcentaje)
SELECT [ID],[Valor]
  FROM [dbo].[TipoDeduccion]
  WHERE [Obligatorio] = 1

--insertamos las deducciones obligatorias
INSERT INTO [dbo].[DeduccionesXEmpleado]
           ([IdEmpleado]
           ,[IdTipoDeduccion]
		   ,[Monto]
		   ,[Visible])
select IsNull(ID,0), t.IdTipoDeduccion, t.porcentaje,1
from Inserted ,@t t