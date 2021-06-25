ALTER TRIGGER [dbo].[TR_CambiosDeducciones] ON [dbo].[DeduccionesXEmpleado]
AFTER UPDATE,INSERT 
AS

declare @idEMP int = (select top 1 inserted.IdEmpleado FROM inserted)
declare @new sql_variant
declare @old sql_variant
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
		exec dbo.NuevoHistorial 
					  @inIdEmpleado = @idEMP
					, @inValorModificado = 'MontoDeduccion'
					, @inValorAnterior = @old
					, @inValorNuevo = @new
					-- parametros de salida
					, @OutResultCode = @output OUTPUT
	END
 
	IF UPDATE(Visible)
	BEGIN
		set @new = (select top 1 inserted.Visible FROM inserted)
		set @old = (select top 1 deleted.Visible FROM deleted)
		exec dbo.NuevoHistorial 
					  @inIdEmpleado = @idEMP
					, @inValorModificado = 'DeduccionActiva'
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
		exec dbo.NuevoHistorial 
					  @inIdEmpleado = @idEMP
					, @inValorModificado = 'NuevaDeduccion'
					, @inValorAnterior = @old
					, @inValorNuevo = @new
					-- parametros de salida
					, @OutResultCode = @output OUTPUT
END