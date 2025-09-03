import requests
from PIL import Image
from io import BytesIO
from selenium import webdriver
import time
from selenium.webdriver.chrome.service import Service as ChromeService
from selenium.webdriver.common.by import By
import pywhatkit as kit

condicion = int(input('Ingrese un numero del 0 al 10: '))  # Cambia esto a tu condición

if condicion == 0:
    # URL de la imagen que deseas mostrar
    imagen_url0 = 'https://imgs.search.brave.com/EeoyXABI7kUZrZxYYc4Qr5f8FCXC_AujfZSwegCUpR0/rs:fit:860:0:0/g:ce/aHR0cHM6Ly90cm9t/ZS5jb20vcmVzaXpl/ci84a1plTDQ2RVBy/eGJMSmt5VFpCZWZl/ZFJHWms9LzY0MHgw/L3NtYXJ0L2ZpbHRl/cnM6Zm9ybWF0KGpw/ZWcpOnF1YWxpdHko/NzUpL2Nsb3VkZnJv/bnQtdXMtZWFzdC0x/LmltYWdlcy5hcmNw/dWJsaXNoaW5nLmNv/bS9lbGNvbWVyY2lv/LzZBUU9RVzdCQUpD/V0hERkVIM1dWRk5X/TDY0LmpwZw'

    # Realizar una solicitud GET para descargar la imagen
    response = requests.get(imagen_url0)


    if response.status_code == 200:
        # Convertir la respuesta a una imagen PIL
        imagen = Image.open(BytesIO(response.content))

        # Mostrar la imagen
        imagen.show()
    else:
        print('No se pudo descargar la imagen')

elif condicion == 1:
    print('USTED HA HACKEADO LA NASA')

elif condicion == 2:
    kit.playonyt("https://www.youtube.com/watch?v=33yUBNZ8GMo")    

else:
    print('La condición no se cumple')
