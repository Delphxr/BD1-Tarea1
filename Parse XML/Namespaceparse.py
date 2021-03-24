import xml.etree.ElementTree as ET

tree = ET.parse('NamespaceXML.xml')
root = tree.getroot()
#Diccionario con prefijos
ns = {'real_person': 'http://people.example.com',
      'role': 'http://characters.example.com'}
for actor in root.findall('real_person:actor', ns):
    name = actor.find('real_person:name', ns)
    print(name.text)
    for char in actor.findall('role:character', ns):
        print(' |-->', char.text)
