from random import randint, choices

nombres = ['Leandro', 'Mariela', 'Gastón', 'Andrea', 'Antonio', 'Estela', 'Jorge', 'Agustina']
apellidos = ['Perez', 'Colman', 'Rodriguez', 'Juarez', 'García', 'Belgrano', 'Mendez', 'Lopez']

niveles_de_riesgo = [1, 2, 3]
descripciones_de_riesgo = ['crítico', 'moderado', 'bajo']
# probabilidades de aparición de cada tipo de paciente
probabilidades = [0.1, 0.3, 0.6] 


class Paciente:
    """Se define una clase Paciente"""    
    def __init__(self,orden):
        """
        
        Parameters
        ----------
        orden : TYPE int
            El constructor de la clase Paciente guarda nombres, apellidos,
            las probabilidades de cada nivel de riesgo, la descripción y el 
            orden
            
        Returns
        -------
        None.

        """
        n = len(nombres)
        self._nombre = nombres[randint(0, n-1)]
        self._apellido = apellidos[randint(0, n-1)]
        self._riesgo = choices(niveles_de_riesgo, probabilidades)[0] #retorna los niveles de riesgo según sus probabilidades
        self._descripcion = descripciones_de_riesgo[self._riesgo-1]
        self._orden = orden
        
    def __str__(self):
          """
        Returns
        -------
        cad : TYPE any
            Método mágico que imprime por consola los datos personales de los 
            pacientes: nombre, apellido, nivel de riesgo y descripición.

        """
          cad = self._nombre + ' '
          cad += self._apellido + '\t -> '
          cad += str(self._riesgo) + '-' + self._descripcion
          return cad    
        
        
    def __lt__(self,other):
        if self._riesgo == other._riesgo:
            return self._orden < other._orden
        return self._riesgo < other._riesgo
            
    def get_nombre(self):
        return self.__nombre
    
    def get_apellido(self):
        return self.__apellido
    
    def get_riesgo(self):
        return self.__riesgo
    
    def get_descripcion_riesgo(self):
        return self.__descripcion

if __name__ == "__main__":
    obj = Paciente(90)
    print(obj)