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
        Nombre ([string]): [description]
        TipoDI ([int]): [description]
        ValorDI ([string]): [description]
        Departamento ([int]): [description]
        Puesto ([int]): [description]
        FechaNacimiento ([string]): [description]
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
    pass

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

def read():
    print("read")
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM [dbo].[Test_1]")
    return (tuple(cursor))

#insertamos un elemento en la tabla
def insert(Nombre, IdTipoIdentificacion ,ValorDocumentoIdentificacion, IdDepartamento, Puesto, FechaNacimiento):
    print("create")
    cursor = conn.cursor()
    cursor.execute(
        "INSERT INTO [dbo].[Test_1] (Nombre, IdTipoIdentificacion ,ValorDocumentoIdentificacion, IdDepartamento, Puesto, FechaNacimiento) values(?,?,?,?,?,?)",
        (Nombre, IdTipoIdentificacion ,ValorDocumentoIdentificacion, IdDepartamento, Puesto, FechaNacimiento)
    )
    conn.commit()


#modificamos un elemento en la tabla
def update():
    print("update")
    cursor = conn.cursor()
    cursor.execute(
        "UPDATE [dbo].[Test_1] SET Nombre = ? WHERE Nombre = ?",
        ("Figeruno fugofugo","Antonio Fronteras")
    )
    conn.commit()
    read()
    print()

#eliminamos un elemento en la tabla
def delete():
    print("delete")
    cursor = conn.cursor()
    cursor.execute(
        "DELETE FROM [dbo].[Test_1] WHERE Id > 2"
    )
    conn.commit()
    read()
    print()

#hacemos una coneccion on la base de datos
conn = pyodbc.connect(
    "Driver={SQL Server};"
    "Server=OSWALDO\SQLEXPRESS;"
    "Database=PlanillaObrera_BD;"
    "Trusted_Connection=yes;"
)

if __name__ == "__main__":
    read()
    insert()
    update()
    delete()

    conn.close()