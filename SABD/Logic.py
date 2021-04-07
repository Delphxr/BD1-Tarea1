import DataBaseEmpleados
import operator


#de esta forma obtenemos los nombres en minuscula como llaves para los sort
def lower_getter(indice):
    def _getter(obj):
        return obj[indice].lower()
    return _getter


def get_empleados():
    """[obtenemos de la base de datos el tuplo con todos los empleados, ordenados alfabeticamente]

    Returns:
        [iterator]: [un iterador con los empleados]
    """    
    empleados = DataBaseEmpleados.read()
    empleados = sorted(empleados, key=lower_getter(1)) #ordenamos en orden alfabetico
    return empleados


def insert_empleado(Nombre, IdTipoIdentificacion ,ValorDocumentoIdentificacion, IdDepartamento, Puesto, FechaNacimiento):
    """[insertamos un elemento a la tabla de empleados de la base de dar]

    Args:
        Nombre ([string]): [nombre del empleado]
        IdTipoIdentificacion ([int]): [identificador del tipo de documento de identificacion, ver la tabla para mas info]
        ValorDocumentoIdentificacion ([int]): [valor del documento de identificacion]
        IdDepartamento ([int]): [id del departamenteo en el que trabaja el empleado]
        Puesto ([string]): [puesto en el que trabaja el empleado]
        FechaNacimiento ([string]): [fecha de nacimiento del empleado, en formato ano-mes-dia y de la forma = xxxx-xx-xx]
    """    
    DataBaseEmpleados.insert(Nombre, IdTipoIdentificacion ,ValorDocumentoIdentificacion, IdDepartamento, Puesto, FechaNacimiento)

def get_puestos():
    test = ((1,"Electricista",1200),(2,"prueba del Logic",1250))
    test = sorted(test, key=operator.itemgetter(1)) #ordenamos en orden alfabetico
    return test

def get_tipos_di():
    test = ((1,"Cedula Nacional"),(2,"Cedula Residente"),(3,"Prueba con el Logic"))
    return test

def get_departamentos():
    test = ((1, "Bodega de Materiales"),(2,"Prueba con el Logic"))
    return test

