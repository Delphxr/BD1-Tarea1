

//con esta funcoin convertimos el array en una tabla en html
function getHTMLTablaSalario(data){

    var tabla = ''
    $.each(data, function( index, value ) {
        tabla = tabla + '<tr >'+
        '<th>'+value[0]+'</th>'+
        '<td>'+value[1]+'</td>'+
        '<td>'+value[2]+'</td>'+
        '<td>'+value[3]+'</td>'+
        '<td>'+value[4]+'</td>'+
        '<td>'+value[5]+'</td>'+
        '<td>'+value[6]+'</td>';
        
      });


    return tabla;
};

//con esta funcoin convertimos el array en una tabla en html
function getHTMLTablaDeduccion(data){

    var tabla = ''
    $.each(data, function( index, value ) {
        tabla = tabla + '<tr >'+
        '<th>'+value[0]+'</th>'+
        '<td>'+value[1]+'</td>'+
        '<td>'+value[2]+'</td>'
        
      });


    return tabla;
};


//al presionar en unn boton de salario obtenemoos datos y los actualizamos en la pagina
$('.boton_salario').bind('click', function(e) {
    var data = ($(this).attr('data-button'));

    data = data.replace(/'/g, '"');
    data = JSON.parse(data);

    
    tabla = getHTMLTablaSalario(data);
    document.getElementById("tabla_popuot_detalles_salario").innerHTML = tabla;
});

//al presionar en unn boton de deduccion obtenemoos datos y los actualizamos en la pagina
$('.boton_deduccion').bind('click', function(e) {

    var data = ($(this).attr('data-button'));
    

    data = data.replace(/'/g, '"');
    data = JSON.parse(data);

    
    tabla = getHTMLTablaDeduccion(data);
    document.getElementById("tabla_popuot_detalles_deducciones").innerHTML = tabla;
});


