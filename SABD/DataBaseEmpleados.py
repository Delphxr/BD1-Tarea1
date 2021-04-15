#pip install pyodbc
import pyodbc


def get_puestos_BD():
    """[Ejecutamos el stored procedure para obtener los puestos]

    Returns:
        [touple]: [tuplo con todos los puestos en la BD]
    """    
    cursor = conn.cursor()
    cursor.execute(
        """
        DECLARE
            @OutResultCode INT
        
        EXEC dbo.GetPuestos
            @OutResultCode OUTPUT
        """
    )
    puestos = tuple(cursor)
    cursor.close()
    return (puestos)

def get_puestos_by_ID(Id):
    cursor = conn.cursor()
    cursor.execute(
        """
        DECLARE
            @OutResultCode INT
        
        EXEC dbo.GetPuestosByID
            ?,
            @OutResultCode OUTPUT
        """,(Id)
    )
    puesto = tuple(cursor)
    cursor.close()
    return (puesto[0])

def insertar_puesto_BD(Id,Nombre,SalarioXHora):
    """[Insertamos un puesto a la base de datos]

    Args:
        Id ([int]): [id (primary key) del puesto a ser insertado]
        Nombre ([string]): [nombre del puesto]
        SalarioXHora ([int]): [Salario que se gana por hora]
    """    
    cursor = conn.cursor()
    cursor.execute(
        """
        DECLARE
            @OutResultCode INT
        
        EXEC dbo.InsertarPuesto
            ?,
            ?,
            ?,
            @OutResultCode OUTPUT
        """,
        (Id,Nombre,SalarioXHora)
    )
    conn.commit()
    cursor.close()

def editar_puesto_BD(IdPuesto,Nombre,SalarioXHora):
    """[editamos un puesto de la BD]

    Args:
        IdPuesto ([int]): [id del puesto a editar]
        Nombre ([string]): [nombre del puesto]
        SalarioXHora ([int]): [Salario que se gana por hora]
    """    
    cursor = conn.cursor()
    cursor.execute(
        """
        DECLARE
            @OutResultCode INT
        
        EXEC dbo.EditarPuesto
            ?,
            ?,
            ?,
            @OutResultCode OUTPUT
        """,
        (IdPuesto,Nombre,SalarioXHora)
    )
    conn.commit()
    cursor.close()

# -------------------------------------------- #

def get_empleados_BD():
    """[obtenemos un tuplo con los empleados]

    Returns:
        [tuple]: [tuplo con los empleados]
    """    
    cursor = conn.cursor()
    cursor.execute(
        """
        DECLARE
            @OutResultCode INT
        
        EXEC dbo.GetEmpleados
            @OutResultCode OUTPUT
        """
    )
    empleados = tuple(cursor)
    cursor.close()
    return (empleados)

def insertar_empleado_BD(Nombre,TipoDI, ValorDI,Departamento,Puesto,FechaNacimiento):
    """[Insertamos un empleado a la BD]

    Args:
        Nombre ([string]): [nombre del empleaso]
        TipoDI ([int]): [id del tipo de documento identificacion]
        ValorDI ([string]): [valor del documento de identidad]
        Departamento ([int]): [id del departamento]
        Puesto ([int]): [id del puesto]
        FechaNacimiento ([string]): [fecha de nacimiento en formato AAAA-MM-DD]
    """    
    cursor = conn.cursor()
    cursor.execute(
        """
        DECLARE
            @OutResultCode INT
        
        EXEC dbo.InsertarEmpleado
            ?,
            ?,
            ?,
            ?,
            ?,
            ?,
            @OutResultCode OUTPUT
        """,
        (Nombre,TipoDI, ValorDI,Departamento,Puesto,FechaNacimiento)
    )
    conn.commit()
    cursor.close()

def editar_empleado_BD(EmpleadoId,Nombre, IdTipoIdentificacion ,ValorDocumentoIdentificacion, IdDepartamento, Puesto, FechaNacimiento):
    """[editamos un empleado de la base de datos]

    Args:
        EmpleadoId ([int]): [id del empleado que vamos a editar]
        Nombre ([string]): [nombre del empleaso]
        TipoDI ([int]): [id del tipo de documento identificacion]
        ValorDI ([string]): [valor del documento de identidad]
        Departamento ([int]): [id del departamento]
        Puesto ([int]): [id del puesto]
        FechaNacimiento ([string]): [fecha de nacimiento en formato AAAA-MM-DD]
    """    
    cursor = conn.cursor()
    cursor.execute(
        """
        DECLARE
            @OutResultCode INT
        
        EXEC dbo.EditarEmpleado
            ?,
            ?,
            ?,
            ?,
            ?,
            ?,
            ?,
            @OutResultCode OUTPUT
        """,
        (EmpleadoId, Nombre, IdTipoIdentificacion, ValorDocumentoIdentificacion, IdDepartamento, Puesto, FechaNacimiento)
    )
    conn.commit()
    cursor.close()

# -------------------------------------------- #

def get_departamentos_BD():
    """[obtenemos los departamentos de la base de datos]

    Returns:
        [touple]: [tuplo con todos los departamentos en la bd]
    """    
    cursor = conn.cursor()
    cursor.execute(
        """
        DECLARE
            @OutResultCode INT
        
        EXEC dbo.GetDepartamentos
            @OutResultCode OUTPUT
        """
    )
    departamentos = tuple(cursor)
    cursor.close()
    return (departamentos)

def get_tipos_di_BD():
    """[obtenemos de la BD los tipos de DI]

    Returns:
        [tuple]: [tuplo con los tipos de DI]
    """    
    cursor = conn.cursor()
    cursor.execute(
        """
        DECLARE
            @OutResultCode INT
        
        EXEC dbo.GetTiposDocIdent
            @OutResultCode OUTPUT
        """
    )
    tipos_di = tuple(cursor)
    cursor.close()
    return (tipos_di)

# -------------------------------------------- #

#hacemos una coneccion on la base de datos
conn = pyodbc.connect(
    "Driver={SQL Server};"
    "Server=OSWALDO\SQLEXPRESS;"
    "Database=PlanillaObrera_BD;"
    "Trusted_Connection=yes;"
)

