from ej_3.modulos.dijsktras import dijkstra_min

class Vertice:
    """
    Clase que inicializa un nodo/vertice.
    Sus componentes son:
        -Una clave ---> .id
            TYPE: str
        -Una distancia ---> .dist
            TYPE: int/float
        -Sus vecinos (nodos a los que está conectado) ---> .conectado_a
            TYPE: Vertice
        -Su predecesor ---> .predecesor
            TYPE: Vertice
    """
    def __init__(self,clave,dist=0):
        self.id = clave
        self.conectado_a = {}
        self.dist = dist
        self.predecesor = None

    def asignar_distancia(self,valor):
        """
        Recibe un valor y modifica la distancia del vertice.
        
        Parameters
        ----------
        valor : TYPE: int
        
        Returns
        -------
        None.

        """
        self.dist = valor
        
    def obtener_distancia(self):
        """
        obtiene la distancia del vertice y la devuelve.
        
        Returns
        -------
        la distancia del vertice.

        """
        return self.dist
    
    def agregar_vecino(self,vecino,ponderacion):
        """
        Agrega un vecino con su ponderación a un vertice.

        Parameters
        ----------
        vecino : TYPE: Vertice
            Vertice que se quiere agregar como vecino.
        ponderacion : TYPE: int
            Es el valor de la arista que une al vertice con el nuevo vecino.

        Returns
        -------
        None.

        """
        self.conectado_a[vecino] = ponderacion

    def __str__(self):
        return str(self.id) + ' conectado_a: ' + str([x.id for x in self.conectado_a]) + str([self.obtener_ponderacion(v) for v in self.conectado_a])

    def obtener_conexiones(self):
        """
        Obtiene las claves de los vertices vecinos del vertice y las devuelve.

        Returns
        -------
        TYPE
            DESCRIPTION.

        """
        return self.conectado_a.keys()
        #devuelve una lista con todas las claves que estén conectadas 
        #al vértice

    def obtener_id(self):
        """
        Obtiene la clave que identifica al vertice y la devuelve.

        Returns
        -------
        TYPE
            DESCRIPTION.

        """
        return self.id

    def obtener_ponderacion(self,vecino):
        """
        Obtiene la ponderación que posee un vertice hasta un vertice vecino.

        Parameters
        ----------
        vecino : TYPE: Vertice
            Vertice que está conectado al vertice.

        Returns
        -------
        TYPE: int
            Devuelve un número entero que representa la ponderación de un
            vertice a otro

        """
        return self.conectado_a[vecino]
    
    def asignar_predecesor(self, predecesor):
        """
        Este método asigna un vertice predecesor a un vertice.

        Parameters
        ----------
        predecesor : TYPE: Vertice
            Es el vertice que hace que se modifique la distancia de un vertice.

        Returns
        -------
        None.

        """
        self.predecesor = predecesor
        
    def __lt__(self, otro):
        return True
    
class Grafo:
    """ 
    Clase que inicializa un grafo. 
        Contiene un dicionario de vertices y la cantidad de 
        vertices que contiene este diccionario.
    """
    def __init__(self):
        self.lista_vertices = {}
        self.num_vertices = 0
   
    def __getitem__(self,clave):
        return self.obtener_vertice(clave)
    
    def agregar_vertice(self,clave):
        """
        Añade un vertice al grafo.

        Parameters
        ----------
        clave : TYPE: str
            La clave es el id del vertice.
            
        Returns
        -------
        nuevo_vertice : TYPE: Vertice
            DESCRIPTION.

        """
        self.num_vertices = self.num_vertices + 1
        nuevo_vertice = Vertice(clave)
        self.lista_vertices[clave] = nuevo_vertice
        return nuevo_vertice

    def obtener_vertice(self,n):
        """
        Este método comprueba si el vertice está en el diccionario de vertices y
        lo devuelve.

        Parameters
        ----------
        n : TYPE: Vertice
            Es el vertice que se quiere saber su existencia en la lista de
            vertices.

        Returns
        -------
        TYPE: Vertice
            Si el vertice existe, lo devuelve.
        
        NONE:
            Si el vertice no está en la lista, no devuelve nada.
        """
        if n in self.lista_vertices:
            return self.lista_vertices[n]
        else:
            return None

    def __contains__(self,n):
        return n in self.lista_vertices

    def agregar_arista(self,de,a,ponderacion):
        """
        Este método agrega una arista con ponderación entre dos vertices de un grafo.
        Si los vertices no están en el grafo, los crea y los agrega.

        Parameters
        ----------
        de : TYPE: Vertice
            Es el vertice desde donde parte la arista.
        a : TYPE
            Es el vertice a donde llega la arista.
        ponderacion : TYPE: int
            Es un valor que se le asigna a la arista.

        Returns
        -------
        None.

        """
        if de not in self.lista_vertices:
            nv = self.agregar_vertice(de)
        if a not in self.lista_vertices:
            nn = self.agregar_vertice(a)
        self.lista_vertices[de].agregar_vecino(self.lista_vertices[a],ponderacion)

    def obtener_vertices(self):
        """
        Devuelve las claves de los vertices del diccionario del grafo.

        Returns
        -------
        TYPE
            DESCRIPTION.

        """
        return self.lista_vertices.keys()

    def __iter__(self):
        return iter(self.lista_vertices.values()) 
    

if __name__ == "__main__":
    
    """ PRUEBAS """
    grafo = Grafo()
    
    # grafo.agregar_vertice('a')
    # grafo.agregar_vertice('b')
    # grafo.agregar_arista('a', 'b', 1)
    
    grafo.agregar_arista("a", "b", 5)
    grafo.agregar_arista("a", "c", 2)
    grafo.agregar_arista("a", "e", 7)
    grafo.agregar_arista("b", "e", 5)
    grafo.agregar_arista("c", "a", 3)
    grafo.agregar_arista("b", "c", 5)
    grafo.agregar_arista("e", "a", 5)
    grafo.agregar_arista("d", "e", 1)

    # print(grafo.obtener_vertice("a").obtener_ponderacion(grafo.obtener_vertice("b")))
    # vecinos = grafo.obtener_vertice("a").obtener_conexiones()
    # print("\n") 
    
        
    inicio=grafo.obtener_vertice("a")
    print(inicio)
    dijkstra_min(grafo,inicio)
    
    # for i in grafo:
    #     print (i)
    
    
    
    