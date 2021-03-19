#ojo si esto no funciona poner en la terminal: pip install flask
from flask import Flask, redirect, url_for, render_template, request

app = Flask(__name__) #creamos la pagina

@app.route("/test/") #definimos la ruta de la funcoin en la pagina, en este o la pagina principal
def test():
    test_list = ["1", "dos", "tres", "4tro"]
    argumento_prueba = "aguacate"
    return render_template("hello_world.html",argumento_prueba=argumento_prueba, test_list=test_list) #usamos un archivo html en vez de escribir todo por strings




@app.route("/home/")
def home():
    return render_template("uso_base.html")


#pagina de inicio de sesión
@app.route("/login/", methods=["POST","GET"])
def login():
    if request.method == "POST":
        username = request.form["username"]
        password = request.form["password"]
        if username == "admin" and password == "1234": #el usuario y la contraseña
            return redirect(url_for("home"))
        else:
            return render_template("login.html")
    else:
        return render_template("login.html")


#con esto redireccionamos otra pagina
@app.route("/")
def redirect_to_login():
    return redirect(url_for("login")) #ponemos el nombre de la funcion a la que vamos a redireccionar
    # return redirect(url_for("invalido", dir="argumento")) #si queremos redireccionar a una funcoin que recibe argumentos lo hacemos así

#ejecutamos la pagina
if __name__ == "__main__":
    app.run(debug = True)