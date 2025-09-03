class MonticuloBinario:
    
    
    def __init__(self):
        """
        En el inicializador, se declaran dos variables: "lista_monticulo"
        inicializa una lista de Python con el valor cero. "tamano_actual"
        inicializa un contador en cero. Este se va a ir incrementando en el 
        caso de que se agregue un nodo, y decrementará cuando se elimine un nodo.
        """
        self.lista_monticulo = [0] #el 1er elemento del monticulo simepre se inicializa con cero, cla de prioridad
        self.tamano_actual = 0

    def __iter__(self):
        for i in self.lista_monticulo:
            yield i
        
    def __str__(self):
        return str(self.lista_monticulo)
    
    def __len__(self):
        return self.tamano_actual
    

  
    def infilt_arriba(self,i):
        """
        Método "infilt_arriba" para recuperar la propiedad de montículo comparando
        el ítem recién agregado con su padre. Si el ítem recién agregado es menor
        que su padre, entonces podemos intercambiar el ítem con su padre.
        Recibe por parámetro un índice.

        Parameters
        ----------
        i : TYPE: índice
            Es el índice del nodo que se quiere infiltrar.

        Returns
        -------
        None.

        """
        while i // 2 > 0:
          if self.lista_monticulo[i] < self.lista_monticulo[i // 2]:
             tmp = self.lista_monticulo[i // 2]
             self.lista_monticulo[i // 2] = self.lista_monticulo[i]
             self.lista_monticulo[i] = tmp
          i = i // 2 
    
    
    def insertar(self,k):
        """
        Método "insertar"  para agregar un ítem a una lista. Añade el elemento
        al final de la lista. Esto garantiza que se mantendrá la propiedad de
        estructura completa del árbol.
        Recibe por parámetro un elemento.
        Utiliza el método "infilt_arriba".

        Parameters
        ----------
        k : TYPE: Int.
            Este valor representa el riesgo del paciente.

        Returns
        -------
        None.

        """
        self.lista_monticulo.append(k)
        self.tamano_actual = self.tamano_actual + 1
        self.infilt_arriba(self.tamano_actual) 
        

    def eliminar_min(self):
        """
        Método "eliminar_min" para eliminar la raíz. Este es el elemento
        mas pequeño.
        No recibe parametros.
        Utiliza el método "infilt_abajo".

        Returns
        -------
        valorSacado : TYPE: Int.
            Es el riesgo del paciente.

        """
        valorSacado = self.lista_monticulo[1] #toma la raíz
        self.lista_monticulo[1] = self.lista_monticulo[self.tamano_actual] #llevo el último elemento insertado a la raíz (temporalmente)
        self.tamano_actual = self.tamano_actual - 1 #se descuenta un elemento
        self.lista_monticulo.pop()
        self.infilt_abajo(1)
        return valorSacado
    

    def infilt_abajo(self,i):
        """
        Método "infilt_abajo" para recuperar la propiedad de montículo comparando
        el ítem de la raíz con su hijo mas chico.
        Si la clave de la raíz es menor que la clave de su hijo_min,
        entonces podemos intercambiar el ítem con su hijo.
        Esta acción se va repetir hasta que el nodo padre sea menor que
        ambos nodos hijos.
        Recibe por parámetro un índice.

        Parameters
        ----------
        i : TYPE: índice
            Es el índice del nodo que se quiere infiltrar.

        Returns
        -------
        None.
        """
        while (i * 2) <= self.tamano_actual:
            hm = self.hijo_min(i)
            if self.lista_monticulo[i] > self.lista_monticulo[hm]:
                tmp = self.lista_monticulo[i]
                self.lista_monticulo[i] = self.lista_monticulo[hm]
                self.lista_monticulo[hm] = tmp
            i = hm
            
    def hijo_min(self,i):
        """
        Este método compara ambos nodos hijo de un nodo padre. 
        La función utiliza los índices para hacer referencia a cada vertice.
        El vertice hijo que sea más chico será designado como el hijo_min.
        El índice del nodo padre es lo que recibe la función como parámetro. 
        

        Parameters
        ----------
        i : TYPE: Index
            Es el índice del nodo padre.

        Returns
        -------
        i * 2: TYPE: Index
            Es índice del hijo izquierdo del vertice padre.
        i * 2 + 1: TYPE: Index
            Es el índice del hijo derecho del vertice padre.

        """
        if i * 2 + 1 > self.tamano_actual:
            return i * 2
        else:
            if self.lista_monticulo[i*2] < self.lista_monticulo[i*2+1]:
                return i * 2
            else:
                return i * 2 + 1

if __name__ == "__main__":
    mont=MonticuloBinario()
    mont.infilt_arriba(1)
    mont.insertar(2)
    mont.insertar(2)
    print(mont)
    print(mont.tamano_actual)
