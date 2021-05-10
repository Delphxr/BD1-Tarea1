

var message = "agua = ";
var table = '<table class="table table-hover responsive">' +
'<thead class="thead-dark">' +
'    <tr>' +
'        <th scope="col">Dia de la Semana</th>' +
'        <th scope="col">Hora entrada</th>' +
'        <th scope="col">Hora salida</th>' +
'        <th scope="col">Horas ordinarias</th>'+
'        <th scope="col">Horas extras normales</th>'+
'        <th scope="col">Horas extras dobles</th>'+
'        <th scope="col">Total</th>'+
'    </tr>'+
'</thead>'+
'<tbody>'+
'    <tr>'+
'        <th>adios</th>'+
'        <td>adios</td>'+
'        <td>adios</td>'+
'        <td>adios</td>'+
'        <td>adios</td>'+
'        <td>adios</td>'+
'        <td>adios</td>'+
'    </tr>'+
'</tbody>'+
'</table>';

document.getElementById("test123").onclick = function(){
    document.getElementById("testbody123").innerHTML = table;
}

