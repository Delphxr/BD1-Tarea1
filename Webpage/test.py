#pip install flask
from flask import Flask, redirect, url_for, render_template, request, session, flash

#pip install flask-sqlalchemy
import sqlalchemy

IMAGE_FOLDER = "img/"

app = Flask(__name__)  # creamos la pagina
# key para tener los datos de inicio de secion encriptados
app.secret_key = "c8gd6qlgK4N2*XtLeHa2ykCj!fQrR(a@R)t4TaLee43c$F9&)2w6"
#folder de imagenes
app.config["UPLOAD_FOLDER"] = IMAGE_FOLDER
app.config['MAX_CONTENT_LENGTH'] = 16 * 1024 * 1024


# definimos la ruta de la funcoin en la pagina, en este o la pagina principal
@app.route("/test/")
def test():
    test_list = ["1", "dos", "tres", "4tro"]
    argumento_prueba = "aguacate"
    # usamos un archivo html en vez de escribir todo por strings
    return render_template("hello_world.html", argumento_prueba=argumento_prueba, test_list=test_list)




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


#verificamos si hay una sesión iniciada, retornamos true o false
def verificar_sesion():
    if "user" in session and "password" in session: #verificamos que el usuario alla iniciado sesion
        return True
    else:
        return False


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



#pagina de listar puestos
@app.route("/listar_empleados/")
def listar_empleados():
    if verificar_sesion():
        return render_template("listar_empleados.html")
    else:
        return redirect(url_for("login")) 


# con esto redireccionamos otra pagina
@app.route("/")
def redirect_to_login():
    return redirect(url_for("login"))
    # return redirect(url_for("invalido", dir="argumento")) #si queremos redireccionar a una funcoin que recibe argumentos lo hacemos así


# ejecutamos la pagina
if __name__ == "__main__":
    app.run(debug=True)
