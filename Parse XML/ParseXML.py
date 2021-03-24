import xml.etree.ElementTree as ET

#Parse XML
tree = ET.parse('prueba.xml')
root = tree.getroot()
#Buscar elementos
for country in root.findall('country'):#Busca solo elementos con el tag que sean
                                        #hijos directos
    rank = country.find('rank').text#Busca solo el primer hijo de la tag
    name = country.get('name') #Accesa a los atributos
    print(name,rank)
#Modificar XML
#Agregar un atributo update y agrega +1 al rango
for rank in root.iter('rank'):#Busca el tag rank en todo los subarboles
    new_rank = int(rank.text)+1
    rank.text = str(new_rank)
    rank.set('updated','yes')
tree.write('output.xml')#Ejecuta las modificaciones
#Remover elementos
for country in root.findall('country'):
    rank = int(country.find('rank').text)
    if rank > 50:
        root.remove(country)
tree.write('output.xml')
