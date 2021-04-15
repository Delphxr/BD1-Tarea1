#pip install flask
from flask import Flask, redirect, url_for, render_template, request, session, flash


#encargado de comunicar entre el front end y la BD
import Logic



app = Flask(__name__)  # creamos la pagina
# key para tener los datos de inicio de secion encriptados
app.secret_key = "c8gd6qlgK4N2*XtLeHa2ykCj!fQrR(a@R)t4TaLee43c$F9&)2w6"

# ---------------------------------------------- #

#verificamos si hay una sesión iniciada, retornamos true o false
def verificar_sesion():
    if "user" in session and "password" in session: #verificamos que el usuario alla iniciado sesion
        return True
    else:
        return False



# pagina de inicio de sesión
@app.route("/login/", methods=["POST", "GET"])
def login():
    if request.method == "POST":
        username = request.form["username"]
        password = request.form["password"]

        if username == "admin" and password == "1234":  # el usuario y la contraseña
            session["user"] = username
            session["password"] = password
            return redirect(url_for("home"))

        else:
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
        return render_template("homepage.html")
    else:
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
    
    if verificar_sesion():
        return render_template("editar_puestos.html", puestos=Logic.get_puestos())
    else:
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
    
    if verificar_sesion():
        return render_template("editar_puestos.html", puestos=Logic.get_puestos_by_id(puesto))
    else:
        return redirect(url_for("login"))


#pagina de insertar de puestos
@app.route("/insertar_puestos/", methods=["POST", "GET"])
def insertar_puestos():
    if request.method == "POST":
        nombre = request.form["nombre"]
        salarioXHora = request.form["SalarioXHora"]

        Logic.insert_puestos(nombre,salarioXHora)

        return redirect(url_for("home"))

    if verificar_sesion():
        return render_template("insertar_puestos.html")
    else:
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
        if verificar_sesion():
            return render_template("insertar_empleados.html",
            tipos_di=Logic.get_tipos_di(),
            departamentos=Logic.get_departamentos(),
            puestos=Logic.get_puestos()
            )
        else:
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
        if verificar_sesion():
            return render_template("editar_empleados.html",
            empleados=Logic.get_empleados(), 
            tipos_di=Logic.get_tipos_di(),
            departamentos=Logic.get_departamentos(),
            puestos=Logic.get_puestos()
            )

        else:
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
        if verificar_sesion():
            return render_template("editar_empleados.html",
            empleados=Logic.get_empleados_by_id(empleado), 
            tipos_di=Logic.get_tipos_di(),
            departamentos=Logic.get_departamentos(),
            puestos=Logic.get_puestos()
            )

        else:
            return redirect(url_for("login")) 

# ---------------------------------------------- #




@app.route("/test/<name>", methods=['GET', 'POST'])
def test(name):
    return f"Se ha recibido: {name}"

@app.route("/")
def inicio():
    return redirect(url_for("home"))


# ejecutamos la pagina
if __name__ == "__main__":
    app.run(debug=True)
