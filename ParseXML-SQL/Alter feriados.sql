CREATE TABLE dbo.Usuarios2(
	ID int NOT NULL IDENTITY(1, 1),
    Username varchar(128) NOT NULL,
	Pwd varchar(128) NOT NULL,
	Tipo int
    )
ON  [PRIMARY]
go

SET IDENTITY_INSERT dbo.Usuarios2 ON
go

IF EXISTS ( SELECT  *
            FROM    dbo.Usuarios ) 
    INSERT  INTO dbo.Usuarios2(ID,Username,Pwd,Tipo )
            SELECT  ID,
					Username,
					Pwd,
					Tipo
                    
            FROM    dbo.Usuarios TABLOCKX
go

SET IDENTITY_INSERT dbo.Usuarios2 OFF
go

DROP TABLE dbo.Usuarios
go

Exec sp_rename 'Usuarios2', 'Usuarios'