import random
import string
import secrets

def generar_contrasena(longitud=12, usar_mayusculas=True, usar_numeros=True, usar_caracteres_especiales=True):
    caracteres = string.ascii_letters
    if usar_numeros:
        caracteres += string.digits
    if usar_caracteres_especiales:
        caracteres += string.punctuation

    if usar_mayusculas:
        caracteres = caracteres + string.ascii_uppercase

    contrasena = ''.join(secrets.choice(caracteres) for _ in range(longitud))
    return contrasena

def main():
    longitud = int(input("Ingresa la longitud de la contraseña deseada: "))
    usar_mayusculas = input("¿Incluir mayúsculas? (s/n): ").lower() == "s"
    usar_numeros = input("¿Incluir números? (s/n): ").lower() == "s"
    usar_caracteres_especiales = input("¿Incluir caracteres especiales? (s/n): ").lower() == "s"

    contrasena_generada = generar_contrasena(longitud, usar_mayusculas, usar_numeros, usar_caracteres_especiales)
    print("Contraseña generada:", contrasena_generada)

if __name__ == "__main__":
    main()
