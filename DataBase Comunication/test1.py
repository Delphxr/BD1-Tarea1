#pip install pyodbc
import pyodbc

#leemos una tabla
def read(conection):
    print("read")
    cursor = conection.cursor()
    cursor.execute("SELECT * FROM [dbo].[Test_1]")
    for row in cursor:
        print(row)
    print()

#creamos un elemento en la tabla
def create(conection):
    print("create")
    cursor = conection.cursor()
    cursor.execute(
        "INSERT INTO [dbo].[Test_1] (Nombre, IdTipoIdentificacion ,ValorDocumentoIdentificacion, IdDepartamento, Puesto, FechaNacimiento) values(?,?,?,?,?,?)",
        ("Antonio Fronteras",2 ,123456,5, "Jefe de cuidado del cabello","1975-5-10")
    )
    conection.commit()
    read(conection)
    print()

#modificamos un elemento en la tabla
def update(conection):
    print("update")
    cursor = conection.cursor()
    cursor.execute(
        "UPDATE [dbo].[Test_1] SET Nombre = ? WHERE Nombre = ?",
        ("Figeruno fugofugo","Antonio Fronteras")
    )
    conection.commit()
    read(conection)
    print()

#eliminamos un elemento en la tabla
def delete(conection):
    print("delete")
    cursor = conection.cursor()
    cursor.execute(
        "DELETE FROM [dbo].[Test_1] WHERE Id > 2"
    )
    conection.commit()
    read(conection)
    print()

#hacemos una coneccion on la base de datos
conn = pyodbc.connect(
    "Driver={SQL Server};"
    "Server=OSWALDO\SQLEXPRESS;"
    "Database=Prueba1;"
    "Trusted_Connection=yes;"
)


read(conn)
create(conn)
update(conn)
delete(conn)

conn.close()