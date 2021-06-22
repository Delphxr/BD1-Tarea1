import DataBaseEmpleados
from datetime import datetime



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

def get_empleados_by_User(Id):
    empleado = DataBaseEmpleados.get_empleados_by_User(Id)
    if empleado == ():
        empleado = [0,"Administrador","Administrador"]
    else:
        empleado = empleado[0]

    return empleado

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

def ocultar_empleado(Id):
    DataBaseEmpleados.cambiar_visibilidad_empleado_BD(Id,False)

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

def ocultar_puesto(Id):
    """[ocultamos un puesto de la BD]

    Args:
        Id ([int]): [Id del puesto a ocultar]

    Returns:
        [bool]: [True si se pudo borrar y false si no se pudo]
    """    
    puede_borrar = True
    empleados = get_empleados()
    puesto = get_puestos_by_id(Id)[0][1] #nombre del puesto que vamos a ocultar

    for empleado in empleados:
        if empleado[5] == puesto and empleado[7] == True: #si un empleado posee el puesto, y es visible, no podemos borrar
            puede_borrar = False

    if puede_borrar == True:
        DataBaseEmpleados.cambiar_visibilidad_puesto_BD(Id,False)
    return puede_borrar

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
    tipo_admin = ["", "Administrador", "Usuario"]
    administradores = DataBaseEmpleados.get_administradores_BD()
    for administrador in administradores:
        administrador[2] = tipo_admin[administrador[2]]
    
    return administradores

def get_planilla_semana(id):
    dias_semana = ["Viernes","Sabado","Domingo","Lunes","Martes","Miercoles","Jueves"]
    planillas = DataBaseEmpleados.get_planillas_semana(id)
    feriados = DataBaseEmpleados.get_feriados()
    lista_feriados = []
    for f in feriados:
        lista_feriados += [datetime.strptime(f[1], '%Y-%m-%d').date()]
    marcas_dias = []
    deducciones_dias = []

    salarioxhora = float(get_puestos_by_id(get_empleados_by_id(id)[0][5])[0][2])

    planillas = list(planillas)

    counter2 = 0

    while counter2 < len(planillas):
        horas_normales_semana = 0
        horas_extra_norm_semana = 0
        horas_extra_doble_semana = 0


        marcas_semana = DataBaseEmpleados.get_marcas_semana(id,planillas[counter2][5])
        deduc = DataBaseEmpleados.get_deducciones_semana(id,planillas[counter2][5])

        

        
        i = 0
        while i < len(deduc):
            deduc[i] = list(deduc[i])
            deduc[i][0] = deduc[i][3]
            deduc[i][2] = float(deduc[i][2])
            if deduc[i][2] >= 1:
                deduc[i][3] = deduc[i][2]
                deduc[i][1] = ""
                
            else:
                deduc[i][1] = deduc[i][2]
                deduc[i][2] = ""
            i+=1


        counter = 0
        marca_temp = []
        for marca in marcas_semana: 

            
            hora_entrada = marca[1]
            hora_salida = marca[2]
            horas = marca[3]
        
            horas_extra_normales = 0
            horas_extra_dobles = 0

            if (horas > 8):
                if hora_salida.strftime('%A') == "Sunday" or hora_salida.date() in lista_feriados:
                    horas_extra_dobles = horas-8
                else:
                    horas_extra_normales = horas-8
                horas = 8
            

            salario = (salarioxhora*horas) + (salarioxhora*horas_extra_normales)*1.5 + (salarioxhora*horas_extra_dobles)*2

            

            marca_temp += [[hora_entrada.strftime('%A'),hora_entrada.strftime("%I:%M %p"),hora_salida.strftime("%I:%M %p - %m/%d"),horas,horas_extra_normales,horas_extra_dobles,salario]]

            horas_normales_semana += horas
            horas_extra_norm_semana += horas_extra_normales
            horas_extra_doble_semana += horas_extra_dobles
            counter += 1
        
        marcas_dias += [marca_temp]
        deducciones_dias += [deduc]
        
        planillas[counter2] = list(planillas[counter2])
        planillas[counter2] = [counter2,float(planillas[counter2][1]),float(planillas[counter2][2]),float(planillas[counter2][3]),horas_normales_semana,horas_extra_norm_semana,horas_extra_doble_semana]


        counter2 +=1
  
    return [planillas,marcas_dias,deducciones_dias]
    


def get_planilla_mes(id):
    #Mes	Salario Bruto	Deducciones	 Salario Neto
    #[ID][SalarioNeto][SalarioBruto][TotalDeducciones][IdEmpleado][idMes]
    planillas = DataBaseEmpleados.get_planillas_mes(id)
    planillas = list(planillas)
    deducciones_mes = []

    counter2 = 0

    while counter2 < len(planillas):
        deduc = list(DataBaseEmpleados.get_deducciones_mes(planillas[counter2][4],planillas[counter2][5]))
        i = 0
        while i < len(deduc):
            deduc[i] = list(deduc[i])
            deduc[i][0] = deduc[i][6]
            deduc[i][1] = float(deduc[i][1])
            if deduc[i][1] >= 1:
                deduc[i][2] = deduc[i][1]
                deduc[i][1] = ""
                
            else:
                deduc[i][2] = ""

            i+=1

        deducciones_mes += [deduc]
        planillas[counter2] = list(planillas[counter2])
        planillas[counter2] = [counter2, planillas[counter2][5], planillas[counter2][2], planillas[counter2][3], planillas[counter2][1]]
 
        counter2 +=1
    
    return [planillas,deducciones_mes]
  

def get_deducciones_empleado(id):
    """[devolvemos las deducciones del empleado]

    Args:
        id ([int]): [id del empleado]

    Returns:
        [list]: [lista con las deducciones]
    """    
    deducciones = DataBaseEmpleados.get_deducciones_empleado(id)
    return deducciones



def get_tipos_deduccion():
    """[devolvemos los tipos de decuccciones]

    Returns:
        [list]: [lista con las deducciones]
    """    
    deducciones = DataBaseEmpleados.get_tipos_deduccion()
    i = 0
    while i < len(deducciones):
        deducciones[i] = list(deducciones[i])
        deducciones[i][2] = int(deducciones[i][2])
        deducciones[i][3] = int(deducciones[i][3])
        deducciones[i][4] = float(deducciones[i][4])
        i +=1

    return deducciones

def asociar_deduccion(id,tipo,monto):
    DataBaseEmpleados.asociar_deduccion(id,tipo,monto)

def desasociar_deduccion(id):
    DataBaseEmpleados.desasociar_deduccion(id)

def editar_deduccion(id,monto):
    DataBaseEmpleados.editar_deduccion(id,monto)

def clear_bd():
    DataBaseEmpleados.limpiar_tablas()

def cargar_xml(ruta):
    DataBaseEmpleados.cargar_xml_BD(ruta)
