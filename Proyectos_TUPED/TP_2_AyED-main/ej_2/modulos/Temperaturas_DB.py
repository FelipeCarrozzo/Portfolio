from ej_2.modulos.clases import ArbolAVL
from ej_2.modulos.clases import Iterador
from datetime import datetime 

#%%

class Temperaturas_DB:
    
    def __init__(self):
        """
        El constructor de la clase Temperaturas_DB inicializa un ArbolAVL 
        junto con un contador inicializado en cero declarado como "tamano".
        """
        self.mediciones = ArbolAVL()
        self.tamano = 0
        
    def __str__(self):
        """
        El método mágico __str__ muestra por consola una lista de tuplas que 
        contiene la fecha y la temperatura.
        """ 
        lista=[]
        for nodo in self.mediciones:
            lista.append([str(nodo.clave.date()), nodo.valor]) #date() retorna solo el formato fecha, no el formato hora
        return str(lista)

    def __iter__(self):
        return str(self.mediciones)
    

#%%        

    def guardar_temperatura(self,fecha,temperatura):
        """
        Método que agrega a la base de datos una clave y un valor 
        (en este caso, fecha y temperatura, respectivamente), los cuales
        se pasan por parámetro.
        """
        convertir_fecha = datetime.strptime(fecha,"%d/%m/%Y")
        self.mediciones.agregar(convertir_fecha,temperatura)
        self.tamano += 1
        

    def devolver_temperatura(self,fecha):
        """
        Método que retorna el valor (temperatura) en una fecha exacta.
        Recibe por parámetro una clave (fecha).
        """
        convertir_fecha = datetime.strptime(fecha,"%d/%m/%Y")
        temp = self.mediciones.obtener(convertir_fecha)
        return temp
    

    def max_temp_rango(self,fecha1, fecha2):
        """
        Método que retorna, dentro de un rango de fechas, la máxima 
        temperatura registrada. Se pasa por parámetro dos claves (fechas).
        """
        f_uno = datetime.strptime(fecha1, "%d/%m/%Y")
        f_dos = datetime.strptime(fecha2, "%d/%m/%Y")
        temp_max = self.mediciones.obtener(f_uno)  #O(log n)
        
        iterador = Iterador(self.mediciones,f_uno)
        for i in iterador:
            if i.clave <= f_dos and i.clave >= f_uno:
                if i.valor > temp_max:
                    temp_max = i.valor
            else:
                break
        return temp_max
    

    def min_temp_rango(self,fecha1, fecha2):
        """
        Método que retorna, dentro de un rango de fechas, la mínima 
        temperatura registrada. Se pasa por parámetro dos claves (fechas).
        """
        f_uno = datetime.strptime(fecha1, "%d/%m/%Y")
        f_dos = datetime.strptime(fecha2, "%d/%m/%Y")
        temp_min = self.mediciones.obtener(f_uno)
        iterador = Iterador(self.mediciones,f_uno)
        for i in iterador:
            if i.clave <= f_dos:
                if i.valor < temp_min:
                    temp_min = i.valor 
            else:
                break
        return temp_min
    
    

    def temp_extremos_rango(self,fecha1,fecha2):
        """
        Método que devuelve la primer y última temperatura en un rango
        de fecha. Se pasa por parámetro dos claves (fechas).
        """
        min_ = self.min_temp_rango(fecha1, fecha2)
        max_ = self.max_temp_rango(fecha1, fecha2)
        return min_,max_
    
    

    def borrar_temperatura(self,fecha):
        """
        Método para borrar una temperatura (y por lo tanto una fecha) de 
        la base de datos. Se recibe por parametro la clave a borrar (fecha).
        """
        fecha_conv = datetime.strptime(fecha, "%d/%m/%Y")
        self.mediciones.eliminar(fecha_conv) 
        self.tamano -= 1
    

    def mostrar_temperaturas(self,fecha1,fecha2):
        """
        Método para mostrar la totalidad de temperaturas 
        medidas entre una fecha y otra.
        """
        f_uno = datetime.strptime(fecha1, "%d/%m/%Y") 
        f_dos = datetime.strptime(fecha2, "%d/%m/%Y") 
        iterador = Iterador(self.mediciones,f_uno) 
        lista=[]
        for i in iterador:
            if i.clave <= f_dos:
                    lista.append((str(i.clave.date()),i.valor))
            else:
                break
        return(lista) 
    


    def mostrar_cantidad_muestras(self):
        """
        Método que retorna un entero (int) que representa el
        tamaño de la base de datos. No recibe ningún dato por parámetro.
        """
        return self.tamano
    
#%%

if __name__ == "__main__":
    obj=Temperaturas_DB()
    obj.guardar_temperatura("20/10/2022",30)
    obj.guardar_temperatura("21/09/2022",27)
    obj.guardar_temperatura("06/08/2022",26)
    obj.guardar_temperatura("29/10/2022",25)
    obj.guardar_temperatura("07/03/2022",23)
    obj.guardar_temperatura("09/01/2022",22)
    obj.guardar_temperatura("15/06/2022",12)
    obj.guardar_temperatura("19/07/2022",10)
    obj.guardar_temperatura("03/12/2022",5)

    # ----------------------------------------------------------------------
    print("Delvolver temp",obj.devolver_temperatura("29/10/2022"))
    # -------------------------------------------------------------------
    print("MAX temp en un rango",obj.max_temp_rango("07/03/2022", "29/10/2022"))
    # ----------------------------------------------------------------------
    print("MIN temp en un rango",obj.min_temp_rango("07/03/2022", "29/10/2022"))
    # -------------------------------------------------------------------
    print("Borrar temperatura"), obj.borrar_temperatura("29/10/2022")
    # -------------------------------------------------------------------
    print("max y min en un rango",obj.temp_extremos_rango("07/03/2022", "29/10/2022"))
    # -------------------------------------------------------------------
    print("mostrar temps en un rango:") 
    print(obj.mostrar_temperaturas("07/03/2022", "20/10/2022"))
    # -------------------------------------------------------------------
    print("mostrar cantidad de muestras registradas:", obj.mostrar_cantidad_muestras())
    # -------------------------------------------------------------------    
    # print(obj) 
