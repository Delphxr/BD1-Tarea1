USE [PlanillaObrera_BD]
GO
/****** Object:  Trigger [dbo].[TR_CambiosDeducciones]    Script Date: 27/06/2021 07:37:37 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[TR_CambiosDeducciones] ON [dbo].[DeduccionesXEmpleado]
AFTER UPDATE,INSERT 
AS

declare @idEMP int = (select top 1 inserted.IdEmpleado FROM inserted)
declare @new sql_variant
declare @old sql_variant
declare @detalle varchar(100)
declare @output int

--para saber que hace el trigger
DECLARE @Action as char(1);
    SET @Action = (CASE WHEN EXISTS(SELECT * FROM INSERTED)
                         AND EXISTS(SELECT * FROM DELETED)
                        THEN 'U'  -- Set Action to Updated.
                        WHEN EXISTS(SELECT * FROM INSERTED)
                        THEN 'I'  -- Set Action to Insert.
                        WHEN EXISTS(SELECT * FROM DELETED)
                        THEN 'D'  -- Set Action to Deleted.
                        ELSE NULL -- Skip. It may have been a "failed delete".   
                    END)

IF @Action = 'U'
BEGIN
	IF UPDATE(Monto)
	BEGIN

		



		set @new = (select top 1 inserted.Monto FROM inserted)
		set @old = (select top 1 deleted.Monto FROM deleted)
		set @detalle = (Select top 1 nombre from dbo.TipoDeduccion t where t.id = (select top 1 inserted.IdTipoDeduccion FROM inserted))
		set @detalle = 'MontoDeduccion ' + @detalle
		exec dbo.NuevoHistorial 
					  @inIdEmpleado = @idEMP
					, @inValorModificado = @detalle
					, @inValorAnterior = @old
					, @inValorNuevo = @new
					-- parametros de salida
					, @OutResultCode = @output OUTPUT
	END
 
	IF UPDATE(Visible)
	BEGIN
		set @new = (select top 1 inserted.Visible FROM inserted)
		set @old = (select top 1 deleted.Visible FROM deleted)
		set @detalle = (Select top 1 nombre from dbo.TipoDeduccion t where t.id = (select top 1 inserted.IdTipoDeduccion FROM inserted))
		set @detalle = 'DeduccionActiva ' + @detalle
		exec dbo.NuevoHistorial 
					  @inIdEmpleado = @idEMP
					, @inValorModificado = @detalle
					, @inValorAnterior = @old
					, @inValorNuevo = @new
					-- parametros de salida
					, @OutResultCode = @output OUTPUT
	END
END

IF @Action = 'I'
BEGIN
		set @new = (select top 1 inserted.Monto FROM inserted)
		set @old = 0
		set @detalle = (Select top 1 nombre from dbo.TipoDeduccion t where t.id = (select top 1 inserted.IdTipoDeduccion FROM inserted))
		set @detalle = 'NuevaDeduccion ' + @detalle
		exec dbo.NuevoHistorial 
					  @inIdEmpleado = @idEMP
					, @inValorModificado = @detalle
					, @inValorAnterior = @old
					, @inValorNuevo = @new
					-- parametros de salida
					, @OutResultCode = @output OUTPUT
END
 

