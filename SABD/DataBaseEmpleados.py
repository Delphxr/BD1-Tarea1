#pip install pyodbc
import pyodbc


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
    "Database=Prueba1;"
    "Trusted_Connection=yes;"
)

if __name__ == "__main__":
    read(conn)
    insert(conn)
    update(conn)
    delete(conn)

    conn.close()