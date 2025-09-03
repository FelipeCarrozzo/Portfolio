""" ----> Importarción de los modulos <---- """

from TP2_AyED.ej_3.modulos.dijsktras import dijkstra_max
from ej_3.modulos.dijsktras import dijkstra_min
from ej_3.modulos.grafoyvertice import Grafo


""" 
----> Lectura del archivo y almacenamiento de datos <---- 
"""


with open ("rutas.txt", "r") as rutas:
    ciudades = []
    datos_ciudades = []
    for ruta in rutas:
        ruta = ruta.rstrip()
        de,a,peso,costo = ruta.split(",")
        datos_ruta = [de,a,int(peso),int(costo)]
        datos_ciudades.append(datos_ruta)
        
        if de not in ciudades:
            ciudades.append(de)
        if a not in ciudades:
            ciudades.append(a)


""" 
----> Solicitud del destino a analizar <---- 
"""
    

print("Partiendo desede Ciudad De Buenos Aires:", "\n", "De la siguiente lista de destinos, seleccione uno para conocer su máximo cuello de botella y el camino con menor costo de transporte.", "\n",ciudades[1:])
destino= input("Ingrese la ciudad destino: ")


""" 
----> Implementación del máximo cuello de botella <---- 
"""


grafo_ciudades_peso = Grafo()
    
for i in range(len(datos_ciudades)):
    
    grafo_ciudades_peso.agregar_arista(datos_ciudades[i][0],datos_ciudades[i][1],datos_ciudades[i][2]) 


print("\n","----------------", "\n")

dijkstra_max(grafo_ciudades_peso,grafo_ciudades_peso.obtener_vertice("CiudadBs.As."))



peso = 0                            # En la variable peso se guarda la capacidad máxima de peso transportable hacia el destino seleccionado
for i in grafo_ciudades_peso:
    if i.id == destino:
        peso = i.dist

nodo = grafo_ciudades_peso.obtener_vertice(destino)
recorrido = []
while nodo != None:
    recorrido.append(nodo.id)
    nodo = nodo.predecesor        
recorrido.reverse()


""" ----> Implementación del costo mínimo de transporte entre los caminos que tienen la misma o una mayor capacidad de peso a transportar <---- """         


grafo_ciudades_costo = Grafo()
    
for i in range(len(datos_ciudades)):
    if datos_ciudades[i][2] >= peso:
        grafo_ciudades_costo.agregar_arista(datos_ciudades[i][0],datos_ciudades[i][1],datos_ciudades[i][3]) 


dijkstra_min(grafo_ciudades_costo,grafo_ciudades_costo.obtener_vertice("CiudadBs.As."))




costo = 0                            # En la variable costo se guarda el costo mínimo de transporte hacia el destino seleccionado
for i in grafo_ciudades_costo:
    if i.id == destino:
        costo = i.dist        
        
nodo = grafo_ciudades_costo.obtener_vertice(destino)
recorrido2 = []
while nodo != None:
    recorrido2.append(nodo.id)
    nodo = nodo.predecesor        
recorrido2.reverse()

""" ----> Se muestran los resultados <---- """  

     
print("Para llegar a", destino,":", "\n", 
      "El peso máximo para transportar es:", peso,"kg", "\n",
      "Y su ruta es: ", recorrido, "\n",
      "El costo mínimo de transporte es:","${costo: .3f}".format(costo=costo ),
      "Y su ruta es: ",recorrido2)
