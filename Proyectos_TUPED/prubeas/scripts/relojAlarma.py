import time
import datetime
import winsound

def reproducirAlarma():
    print('ALARMA')
    for i in range(3):
        winsound.Beep(1000, 1000)
        time.sleep(1)
horaAlarma = input('Ingrese hora (00 - 23): ')
minutoAlarma = input('Ingrese minuto (00 - 59): ')

#Vamos a crear un bucle principal que verificará 
#continuamente la hora actual y activará la alarma
#cuando corresponda.

while True:
    now = datetime.datetime.now()
    if now.hour == horaAlarma and now.minute == minutoAlarma:
        reproducirAlarma()
        break
    time.sleep(60)

if __name__ == '__main__':
    print("Reloj alarma en funcionamiento...")
    print("Presiona Ctrl+C para detener la alarma.")
    try:
        while True:
            now = datetime.datetime.now()
            if now.hour == horaAlarma and now.minute == minutoAlarma:
                reproducirAlarma()
                break
            time.sleep(60)
    except KeyboardInterrupt:
        print('Reloj alarma detenido')