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
    return (tuple(cursor))

def insertar_puesto_BD(Id,Nombre,SalarioXHora):
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