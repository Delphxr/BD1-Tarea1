USE [PlanillaObrera_BD]
GO
/****** Object:  StoredProcedure [dbo].[SETNETO]    Script Date: 25/05/2021 01:37:51 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SETNETO]
AS
	declare @cntx int
	declare @cntrendx int

	set @cntx = 1;
	select @cntrendx = COUNT(0) from dbo.PlanillaXSemanaXEmpleado;

	while @cntx <= @cntrendx
	begin
		UPDATE dbo.PlanillaXSemanaXEmpleado
		SET SalarioNeto = (
				 SalarioBruto - TotalDeducciones
				 )
		WHERE ID = @cntx
		
		set @cntx = @cntx +1
	end

	set @cntx = 1;
	select @cntrendx = COUNT(0) from dbo.PlanillaXMesXEmpleado;

	while @cntx <= @cntrendx
	begin
		UPDATE dbo.PlanillaXMesXEmpleado
		SET SalarioNeto = (
				 SalarioBruto - TotalDeducciones
				 )
		WHERE ID = @cntx
		
		set @cntx = @cntx +1
	end

