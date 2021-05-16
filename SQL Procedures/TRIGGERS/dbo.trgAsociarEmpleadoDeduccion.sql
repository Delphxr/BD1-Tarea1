CREATE TRIGGER dbo.trgAsociarEmpleadoDeduccion
ON [dbo].[Empleado]
AFTER INSERT
AS

--tabla temporal donde vamos a almacenar las deducciones obligatorias
DECLARE @t TABLE(IdTipoDeduccion INT)
DECLARE @d INT
SET @d = (SELECT ID FROM inserted)

-- seleccionamos todas las deducciones obligatorias y las ponermos en @t
INSERT INTO @t (IdTipoDeduccion)
SELECT [ID]
  FROM [dbo].[TipoDeduccion]
  WHERE [Obligatorio] = 1

--insertamos las deducciones obligatorias
INSERT INTO [dbo].[DeduccionesXEmpleado]
           ([IdEmpleado]
           ,[IdTipoDeduccion])
SELECT @d,IdTipoDeduccion FROM @t