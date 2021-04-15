import DataBaseEmpleados



#de esta forma obtenemos los nombres en minuscula como llaves para los sort
def lower_getter(indice):
    def _getter(obj):
        return obj[indice].lower()
    return _getter

# -------------------------------------------- #

def get_empleados():
    """[obtenemos de la base de datos el tuplo con todos los empleados, ordenados alfabeticamente]

    Returns:
        [tuple]: [un iterador con los empleados]
    """    
    empleados = DataBaseEmpleados.get_empleados_BD()

    # como recibimos los puestos por el Id, vamos a remplazarlo por el nombre
    for empleado in empleados:
        id_puesto = empleado[5]
        puesto = get_puestos_by_id(id_puesto)[0]
        empleado[5] = puesto[1]

    empleados = sorted(empleados, key=lower_getter(1)) #ordenamos en orden alfabetico
    return empleados

def get_empleados_by_id(Id):
    return DataBaseEmpleados.get_empleados_by_ID(Id)

def insert_empleado(Nombre, IdTipoIdentificacion ,ValorDocumentoIdentificacion, IdDepartamento, Puesto, FechaNacimiento):
    """[insertamos un elemento a la tabla de empleados de la base de datos]

    Args:
        Nombre ([string]): [nombre del empleado]
        IdTipoIdentificacion ([int]): [identificador del tipo de documento de identificacion, ver la tabla para mas info]
        ValorDocumentoIdentificacion ([int]): [valor del documento de identificacion]
        IdDepartamento ([int]): [id del departamenteo en el que trabaja el empleado]
        Puesto ([string]): [puesto en el que trabaja el empleado]
        FechaNacimiento ([string]): [fecha de nacimiento del empleado, en formato ano-mes-dia y de la forma = xxxx-xx-xx]
    """    
    DataBaseEmpleados.insertar_empleado_BD(Nombre, IdTipoIdentificacion ,ValorDocumentoIdentificacion, IdDepartamento, Puesto, FechaNacimiento)

def editar_empleado(EmpleadoId,Nombre, IdTipoIdentificacion ,ValorDocumentoIdentificacion, IdDepartamento, Puesto, FechaNacimiento):
    """[editamos los valores de un empleado en la tabla]

    Args:
        EmpleadoId ([int]): [id del empleado que vamos a editar]
        Nombre ([string]): [nombre del empleado]
        IdTipoIdentificacion ([int]): [identificador del tipo de documento de identificacion, ver la tabla para mas info]
        ValorDocumentoIdentificacion ([int]): [valor del documento de identificacion]
        IdDepartamento ([int]): [id del departamenteo en el que trabaja el empleado]
        Puesto ([string]): [puesto en el que trabaja el empleado]
        FechaNacimiento ([string]): [fecha de nacimiento del empleado, en formato ano-mes-dia y de la forma = xxxx-xx-xx]
    """    
    DataBaseEmpleados.editar_empleado_BD(EmpleadoId,Nombre, IdTipoIdentificacion ,ValorDocumentoIdentificacion, IdDepartamento, Puesto, FechaNacimiento)
# -------------------------------------------- #

def get_puestos():
    """[llamamos a la BD para que nos retorne los puestos]

    Returns:
        [tuple]: [tuplo con los puestos ordenados alfabeticamente]
    """    
    puestos = DataBaseEmpleados.get_puestos_BD()
    puestos = sorted(puestos, key=lower_getter(1)) #ordenamos en orden alfabetico
    return puestos

def get_puestos_by_id(id):
    return DataBaseEmpleados.get_puestos_by_ID(id)

def insert_puestos(Nombre, SalarioXHora):
    """[llamamos a la bd para que inserte un puesto con lod parametros recibidos]

    Args:
        Nombre ([string]): [nombre del puesto]
        SalarioXHora ([int]): [cantidad de dinero ganado por hora]
    """    
    puestos = DataBaseEmpleados.get_puestos_BD()
    Id = 1
    if len(puestos) > 0:
        last_touple = puestos[-1] #obtenemos el ultimo elemento que hay en los puestos, se supone que los IDs estan en orden ascendente y ordenados
        Id = last_touple[0] + 1
    DataBaseEmpleados.insertar_puesto_BD(Id,Nombre,SalarioXHora)

def editar_puestos(PuestoId,Nombre, SalarioXHora):
    DataBaseEmpleados.editar_puesto_BD(PuestoId,Nombre, SalarioXHora)

# -------------------------------------------- #

def get_tipos_di():
    """[llamamos a la base de datos y obtenemos los tipos de di]

    Returns:
        [tuple]: [tuplo con los tipos de di]
    """    
    tipos_di = DataBaseEmpleados.get_tipos_di_BD()
    return tipos_di

def get_departamentos():
    """[llamamos aabase de datos y obtenemos los departamentos]

    Returns:
        [tuple]: [tuplo con los departamentos en la BD]
    """    
    departamentos = DataBaseEmpleados.get_departamentos_BD()
    return departamentos

def get_administradores():
    return DataBaseEmpleados.get_administradores_BD()