#ojo si esto no funciona poner en la terminal: pip install flask
from flask import Flask, redirect, url_for, render_template

app = Flask(__name__) #creamos la pagina

@app.route("/") #definimos la ruta de la funcoin en la pagina, en este o la pagina principal
def home():
    test_list = ["1", "dos", "tres", "4tro"]
    argumento_prueba = "aguacate"
    return render_template("hello_world.html",argumento_prueba=argumento_prueba, test_list=test_list) #usamos un archivo html en vez de escribir todo por strings



#en caso de que se ingrese una direccion que no existe se activa esta funcion (creo)
@app.route("/<dir>")
def invalido(dir):
    return f"La dirección: \"{dir}\" no existe!"


#con esto redireccionamos otra pagina
@app.route("/admin/")
def admin():
    return redirect(url_for("home")) #ponemos el nombre de la funcion a la que vamos a redireccionar
    # return redirect(url_for("invalido", dir="argumento")) #si queremos redireccionar a una funcoin que recibe argumentos lo hacemos así

#ejecutamos la pagina
if __name__ == "__main__":
    app.run()