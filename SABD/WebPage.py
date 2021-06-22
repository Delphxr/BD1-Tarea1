#pip install flask
from flask import Flask, redirect, url_for, render_template, request, session, flash
import os
from werkzeug.utils import secure_filename
 

#encargado de comunicar entre el front end y la BD
import Logic

 

app = Flask(__name__)  # creamos la pagina
# key para tener los datos de inicio de secion encriptados
app.secret_key = "c8gd6qlgK4N2*XtLeHa2ykCj!fQrR(a@R)t4TaLee43c$F9&)2w6"

#para que los archivos a subirse mayores a 1Mb no sean recibidos
#app.config['MAX_CONTENT_LENGTH'] = 1024 * 1024
#solo recibimos archivos xml
app.config['UPLOAD_EXTENSIONS'] = ['.xml']
app.config['UPLOAD_PATH'] = 'uploads'
  


# ---------------------------------------------- #

#verificamos si hay una sesión iniciada, retornamos true o false
def verificar_sesion():
    if "user" in session and "password" in session: #verificamos que el usuario alla iniciado sesion
        return True
    else:
        return False

#verificamos si el usuario tiene los permisos necesarios
def has_permisos():
    if session["permiso"] == "Administrador":
        return True
    else:
        return False



# pagina de inicio de sesión
@app.route("/login/", methods=["POST", "GET"])
def login():
    if request.method == "POST":
        username = request.form["username"]
        password = request.form["password"]

        usuarios = Logic.get_administradores() #obtenemos los usuarios de la BD
        

        for usuario in usuarios:
            if usuario[0] == username and usuario[1] == password:
                session["user"] = username
                session["password"] = password
                session["permiso"] = usuario[2]

                #obtenemos el nombre del usuario y su id:
                datos_usuario = Logic.get_empleados_by_User(usuario[3])
                session["name"] = datos_usuario[1]
                session["puesto"] = datos_usuario[2]
                session["user_id"] = datos_usuario[0]

                return redirect(url_for("home"))
        return render_template("login.html")
    else:
        if "user" in session:
            return redirect(url_for("home"))
        else:
            return render_template("login.html")


 
# pagina de cerrar sesión
@app.route("/logout/")
def logout():
    if "user" in session and "password" in session:
        flash("Se ha cerrado la sesión", "info")
    
    session.pop("user", None)
    session.pop("password", None)
    return redirect(url_for("login"))

# ---------------------------------------------- #

#pagina principal
@app.route("/home/")
def home():
    if verificar_sesion(): 
        return render_template("homepage.html", permiso=session["permiso"], nombre=session["name"])
    else:
        return redirect(url_for("login")) 

#pagina de ajustes
@app.route("/settings/",methods=["POST", "GET"])
def ajustes():
    if request.method == "POST":

        if "delete" in request.form:
            Logic.clear_bd()
        else:

            uploaded_file = request.files['xml']

            filename = secure_filename(uploaded_file.filename)
            if filename != '':
                file_ext = os.path.splitext(filename)[1]
                if file_ext not in app.config['UPLOAD_EXTENSIONS']:
                    flash("Archivo no valido", "error")
                    redirect(url_for("ajustes")) 
                
                APP_ROOT = os.path.dirname(os.path.abspath(__file__))
                UPLOAD_FOLDER = os.path.join(APP_ROOT, 'uploads')
                app.config['UPLOAD_PATH'] = UPLOAD_FOLDER
                p = os.path.join(app.config['UPLOAD_PATH'], filename)
                num = 2              


                while os.path.exists(p):
                    newfilename = str(num) + filename
                    p = os.path.join(app.config['UPLOAD_PATH'], newfilename)
                    num += 1
                uploaded_file.save(p) #guardamos el archivo
                
                #obtenemos la ruta del archivo en el d irectorio
                ruta_del_archivo = p
                ruta_del_archivo = str(ruta_del_archivo)

                Logic.cargar_xml(ruta_del_archivo)
                flash("Se ha cargado correctamente el archivo", "info")
     
    if verificar_sesion() and has_permisos():
        return render_template("ajustes.html")
    else:
        flash("No tiene los permisos para realizar esta acción", "info")
        return redirect(url_for("login")) 
# ---------------------------------------------- #

#pagina de listar puestos
@app.route("/listar_puestos/")
def listar_puestos():
    if verificar_sesion():
        return render_template("listar_puestos.html", puestos=Logic.get_puestos())
    else:
        return redirect(url_for("login")) 


#pagina de edicion de puestos
@app.route("/editar_puestos/", methods=["POST", "GET"])
def editar_puestos():
    if request.method == "POST":
        editado = request.form["editado"]
        nombre = request.form["nombre"]
        salarioXHora = request.form["SalarioXHora"]

        Logic.editar_puestos(editado,nombre,salarioXHora)

        return redirect(url_for("home"))
    
    if verificar_sesion() and has_permisos():
        return render_template("editar_puestos.html", puestos=Logic.get_puestos())
    else:
        flash("No tiene los permisos para realizar esta acción", "info")
        return redirect(url_for("login"))


#edicion especifica de un empleado
@app.route("/editar_puesto_especifico/<puesto>", methods=["POST", "GET"])
def editar_puesto_esp(puesto):
    if request.method == "POST":
        editado = request.form["editado"]
        nombre = request.form["nombre"]
        salarioXHora = request.form["SalarioXHora"]

        Logic.editar_puestos(editado,nombre,salarioXHora)

        return redirect(url_for("home"))
    
    if verificar_sesion() and has_permisos():
        return render_template("editar_puestos.html", puestos=Logic.get_puestos_by_id(puesto))
    else:
        flash("No tiene los permisos para realizar esta acción", "info")
        return redirect(url_for("login"))


#pagina de insertar de puestos
@app.route("/insertar_puestos/", methods=["POST", "GET"])
def insertar_puestos():
    if request.method == "POST":
        nombre = request.form["nombre"]
        salarioXHora = request.form["SalarioXHora"]

        Logic.insert_puestos(nombre,salarioXHora)

        return redirect(url_for("home"))

    if verificar_sesion() and has_permisos():
        return render_template("insertar_puestos.html")
    else:
        flash("No tiene los permisos para realizar esta acción", "info")
        return redirect(url_for("login"))


@app.route("/ocultar_puesto/<puesto>", methods=["POST", "GET"])
def ocultar_puesto(puesto):
    if verificar_sesion() and has_permisos():
        borrado = Logic.ocultar_puesto(puesto)
        if borrado == False:
            flash("Hay empleados que poseen ese puesto!", "error")
        return redirect(url_for("listar_puestos"))
    else:
        flash("No tiene los permisos para realizar esta acción", "info")
        return redirect(url_for("login"))

# ---------------------------------------------- #

#pagina de listar empleados
@app.route("/listar_empleados/")
def listar_empleados():
    if verificar_sesion():
        return render_template("listar_empleados.html", empleados=Logic.get_empleados())
    else:
        return redirect(url_for("login")) 


#pagina de filtracion(busqueda) de empleados
@app.route("/filtrar_empleados/", methods=["POST", "GET"])
def filtrar_empleados():
    if request.method == "POST":
        nombre = request.form["nombre"]

        return render_template("filtrar_empleados.html",
        empleados=Logic.get_empleados(),
        busqueda=nombre
        )
    
    else:
        if verificar_sesion():
            return render_template("filtrar_empleados.html",
            empleados=Logic.get_empleados(),
            busqueda=""
            )
        else:
            return redirect(url_for("login"))


#pagina de insertar nuevo empleado
@app.route("/insertar_empleados/", methods=["POST", "GET"])
def insertar_empleados():
    if request.method == "POST":
        nombre = request.form["nombre"]
        tipodi = request.form["tipodi"]
        valordi = request.form["valordi"]
        departamento = request.form["departamento"]
        puesto = request.form["puesto"]
        nacimiento = request.form["nacimiento"]

        Logic.insert_empleado(nombre,tipodi,valordi,departamento,puesto,nacimiento)

        return redirect(url_for("home"))
    else:
        if verificar_sesion() and has_permisos():
            return render_template("insertar_empleados.html",
            tipos_di=Logic.get_tipos_di(),
            departamentos=Logic.get_departamentos(),
            puestos=Logic.get_puestos()
            )
        else:
            flash("No tiene los permisos para realizar esta acción", "info")
            return redirect(url_for("login")) 

#editar un empleado
@app.route("/editar_empleados/", methods=["POST", "GET"])
def editar_empleados():
    if request.method == "POST":

        editado = request.form["editado"]
        nombre = request.form["nombre"]
        tipodi = request.form["tipodi"]
        valordi = request.form["valordi"]
        departamento = request.form["departamento"]
        puesto = request.form["puesto"]
        nacimiento = request.form["nacimiento"]

        Logic.editar_empleado(editado,nombre,tipodi,valordi,departamento,puesto,nacimiento)
        return redirect(url_for("home"))
    else:
        if verificar_sesion() and has_permisos():
            return render_template("editar_empleados.html",
            empleados=Logic.get_empleados(), 
            tipos_di=Logic.get_tipos_di(),
            departamentos=Logic.get_departamentos(),
            puestos=Logic.get_puestos()
            )

        else:
            flash("No tiene los permisos para realizar esta acción", "info")
            return redirect(url_for("login")) 

#editar un empleado especifico
@app.route("/editar_empleados_especifico/<empleado>", methods=["POST", "GET"])
def editar_empleados_esp(empleado):
    if request.method == "POST":

        editado = request.form["editado"]
        nombre = request.form["nombre"]
        tipodi = request.form["tipodi"]
        valordi = request.form["valordi"]
        departamento = request.form["departamento"]
        puesto = request.form["puesto"]
        nacimiento = request.form["nacimiento"]

        Logic.editar_empleado(editado,nombre,tipodi,valordi,departamento,puesto,nacimiento)
        return redirect(url_for("home"))
    else:
        if verificar_sesion() and has_permisos():
            return render_template("editar_empleados.html",
            empleados=Logic.get_empleados_by_id(empleado), 
            tipos_di=Logic.get_tipos_di(),
            departamentos=Logic.get_departamentos(),
            puestos=Logic.get_puestos()
            )
 
        else:
            flash("No tiene los permisos para realizar esta acción", "info")
            return redirect(url_for("login")) 


@app.route("/ocultar_empleado/<empleado>/<origen>", methods=["POST", "GET"])
def ocultar_empleado(empleado,origen):
    if verificar_sesion() and has_permisos():
        Logic.ocultar_empleado(empleado)
        return redirect(url_for(origen))
    else:
        flash("No tiene los permisos para realizar esta acción", "info")
        return redirect(url_for("login"))



# ---------------------------------------------- #

#pagina de planilla semanal
@app.route("/listar_semana_planilla/")
def listar_semana_planilla():
    if verificar_sesion() and not has_permisos():
        datos = Logic.get_planilla_semana(session["user_id"])
        return render_template("listar_semana.html",
                                planillas=datos[0] ,
                                detalles_salario=datos[1],
                                deducciones=datos[2])
    else:
        flash("No hay nada que ver aquí", "info")
        return redirect(url_for("login")) 

#pagina de planilla año
@app.route("/listar_anno_planilla/")
def listar_anno_planilla():
    if verificar_sesion() and not has_permisos():
        datos = Logic.get_planilla_mes(session["user_id"])
        return render_template("listar_anno.html", planillas=datos[0],
                                                    deducciones=datos[1])
    else:
        flash("No hay nada que ver aquí", "info")
        return redirect(url_for("login")) 


# ---------------------------------------------- #


 

@app.route("/test/<user_id>", methods=["POST", "GET"])
def test(user_id=None):


    if user_id == None:
        return redirect(url_for("home"))
    else:

        if request.method == "POST":
            tipo = request.form["btn"]
            if tipo == "new":
                tipo = request.form["tipodi"]
                monto = request.form["SalarioXHora"]
                Logic.asociar_deduccion(user_id,tipo,monto)

            elif tipo=="delete":
                Logic.desasociar_deduccion(request.form["id"])

            elif tipo == "edit":
                monto = request.form["SalarioXHora"]
                id_deduccion = request.form["id"]
                Logic.editar_deduccion(id_deduccion,monto)
            return redirect(url_for("test",user_id=user_id))

        datos_usuario = Logic.get_empleados_by_id(user_id)[0]
        name = datos_usuario[1] 
        puesto = datos_usuario[8]  


        return render_template("test.html", 
                            tipos_deduccion=Logic.get_tipos_deduccion(),
                            deducciones=Logic.get_deducciones_empleado(user_id),
                            name=name,
                            puesto=puesto)

@app.route("/")
def inicio():
    return redirect(url_for("home"))


# ejecutamos la pagina
if __name__ == "__main__":
    app.run(debug=True)

