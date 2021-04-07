#pip install flask
from flask import Flask, redirect, url_for, render_template, request, session, flash

#pip install flask-sqlalchemy
import sqlalchemy

#encargado de comunicar entre el front end y la BD
import Logic



app = Flask(__name__)  # creamos la pagina
# key para tener los datos de inicio de secion encriptados
app.secret_key = "c8gd6qlgK4N2*XtLeHa2ykCj!fQrR(a@R)t4TaLee43c$F9&)2w6"


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



#pagina principal
@app.route("/home/")
def home():
    if verificar_sesion():
        return render_template("homepage.html")
    else:
        return redirect(url_for("login")) 


#pagina de listar puestos
@app.route("/listar_puestos/")
def listar_puestos():
    if verificar_sesion():
        return render_template("listar_puestos.html")
    else:
        return redirect(url_for("login")) 


#pagina de edicion de puestos
@app.route("/editar_puestos/")
def editar_puestos():
    if verificar_sesion():
        return render_template("editar_puestos.html")
    else:
        return redirect(url_for("login"))


#pagina de insertar de puestos
@app.route("/insertar_puestos/")
def insertar_puestos():
    if verificar_sesion():
        return render_template("insertar_puestos.html")
    else:
        return redirect(url_for("login"))



#pagina de listar empleados
@app.route("/listar_empleados/")
def listar_empleados():
    if verificar_sesion():
        return render_template("listar_empleados.html", empleados=Logic.get_empleados())
    else:
        return redirect(url_for("login")) 

@app.route("/filtrar_empleados/", methods=["POST", "GET"])
def filtrar_empleados():
    if request.method == "POST":
        nombre = request.form["nombre"]
        return render_template("filtrar_empleados.html", empleados=Logic.get_empleados(), busqueda=nombre)
    else:
        if verificar_sesion():
            return render_template("filtrar_empleados.html", empleados=Logic.get_empleados(),busqueda="")
        else:
            return redirect(url_for("login")) 


#pagina de insertar nuevo empleado
@app.route("/insertar_empleados/", methods=["POST", "GET"])
def insertar_empleados():
    if request.method == "POST":
        nombre = request.form["nombre"]
        #tipodi = request.form["tipodi"]
        tipodi = 8
        valordi = request.form["valordi"]
        #departamento = request.form["departamento"]
        departamento = 9
        puesto = request.form["puesto"]
        nacimiento = request.form["nacimiento"]

        Logic.insert_empleado(nombre,tipodi,valordi,departamento,puesto,nacimiento)

        return redirect(url_for("home"))
    else:
        if verificar_sesion():
            return render_template("insertar_empleados.html")
        else:
            return redirect(url_for("login")) 

#editar un empleado
@app.route("/editar_empleados/", methods=["POST", "GET"])
def editar_empleados():
    if request.method == "POST":

        editado = request.form["editado"]
        nombre = request.form["nombre"]
        #tipodi = request.form["tipodi"]
        tipodi = 8
        valordi = request.form["valordi"]
        #departamento = request.form["departamento"]
        departamento = 9
        puesto = request.form["puesto"]
        nacimiento = request.form["nacimiento"]


        return redirect(url_for("home"))
    else:
        if verificar_sesion():
            return render_template("editar_empleados.html")
        else:
            return redirect(url_for("login")) 



# con esto redireccionamos al login apenas ingresar a la pagina
@app.route("/")
def redirect_to_login():
    return redirect(url_for("login"))
    # return redirect(url_for("invalido", dir="argumento")) #si queremos redireccionar a una funcoin que recibe argumentos lo hacemos así


# ejecutamos la pagina
if __name__ == "__main__":
    app.run(debug=True)