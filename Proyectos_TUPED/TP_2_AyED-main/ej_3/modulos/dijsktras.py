from ej_3.modulos.monticulos import MonticuloBinarioMin

def dijkstra_min(un_grafo,inicio):
    """
    Esta función devuelve un grafo con los costos mínimos de viajar desde
    una ciudad inicio hacia las demas del grafo.

    Parameters
    ----------
    un_grafo : TYPE: Grafo
        Un grafo con las aristas(caminos), los vertices(ciudades) y ponderaciones(costos por ruta).
    inicio : TYPE: Vertice
        Un vertice(ciudad) inicial desde donde se quiere viajar.

    Returns
    -------
    None.

    """
    cp = MonticuloBinarioMin()         
    
    for vertice in un_grafo:
        vertice.asignar_distancia(9999)
    inicio.asignar_distancia(0)
    cp.construir_monticulo([(v.obtener_distancia(),v) for v in un_grafo])
    
    
    
    while not cp.esta_vacia():
        
        vertice_actual = cp.eliminar_min()
        #elimina la raíz, el elemento mas pequeño
        for vertice_siguiente in vertice_actual.obtener_conexiones():
            
            nueva_distancia = vertice_actual.obtener_distancia() + vertice_actual.obtener_ponderacion(vertice_siguiente)
            
            if nueva_distancia < vertice_siguiente.obtener_distancia():    
                vertice_siguiente.asignar_distancia(nueva_distancia)
                vertice_siguiente.asignar_predecesor(vertice_actual)
                cp.decrementar_clave(vertice_siguiente,nueva_distancia)
                
#%%

from ej_3.modulos.monticulos import MonticuloBinarioMax
  
def dijkstra_max(un_grafo,inicio):
    """
    Esta función devuelve un grafo con los pesos máximo transportables
    desde una ciudad inicio a las demás del grafo.
    

    Parameters
    ----------
    un_grafo : TYPE: Grafo
        Un grafo con las aristas(caminos), los vertices(ciudades) y ponderaciones(capacidad de peso por ruta).
    inicio : TYPE: Vertice
        Un vertice(ciudad) inicial desde donde se quiere viajar.

    Returns
    -------
    None.

    """
    cp = MonticuloBinarioMax()
    inicio.asignar_distancia(9999)
    cp.construir_monticulo([(v.obtener_distancia(),v) for v in un_grafo]) 
    #lista detuplas por comprensión
    while not cp.esta_vacia():
        
        vertice_actual = cp.eliminar_max()
        #elimina la raíz (nodo de origen), el elemento mas grande, lo retorna
        
        for vertice_siguiente in vertice_actual.obtener_conexiones():
            
            nueva_distancia = min(vertice_actual.obtener_distancia(),vertice_actual.obtener_ponderacion(vertice_siguiente))
            
            if nueva_distancia > vertice_siguiente.obtener_distancia():    
                vertice_siguiente.asignar_distancia(nueva_distancia)
                vertice_siguiente.asignar_predecesor(vertice_actual)
                cp.decrementar_clave(vertice_siguiente,nueva_distancia)
                