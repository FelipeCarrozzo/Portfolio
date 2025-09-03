import random as rd

class Enjoy:

    def __init__(self):
        self.nroParticipante = 0

    def __iter__(self):
        return self
        
    def adivinarNumero(self):
        self.numeroRandom = rd.randint(0, 1000)
        print(self.numeroRandom)

        self.nroParticipante = int(input('Ingrese un numero del 0 al 1000: '))

        while 0 <= self.nroParticipante <= 1000:
            if self.nroParticipante > self.numeroRandom:
                print('El numero es menor')
                self.nroParticipante = int(input('Ingrese un numero del 0 al 1000: '))

            elif self.nroParticipante < self.numeroRandom:
                print('El numero es mayor')
                self.nroParticipante = int(input('Ingrese un numero del 0 al 1000: '))

            else:
                print(f'Felicidades! El número es el {self.numeroRandom}')
                break
    
    def fraseAleatoria(self):
        # Listas de palabras aleatorias para diferentes categorías
        self.sustantivos = ["perro", "gato", "pelota", "montaña", "coche"]
        self.verbos = ["corrió", "saltó", "bailó", "cantó", "comió"]
        self.adjetivos = ["feliz", "enorme", "colorido", "rápido", "divertido"]

        """Genera una oración aleatoria utilizando palabras aleatorias."""
        a = rd.choice(self.sustantivos)
        b = rd.choice(self.verbos)
        c = rd.choice(self.adjetivos)
        oracion = f"El {a} {b} {c} en el jardín."
        return oracion

if __name__ == '__main__':
    enjoy = Enjoy() # Instancio la clase
    print(enjoy.fraseAleatoria())  # Llamo al método
