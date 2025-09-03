from tkinter import *
from time import strftime

miVentana = Tk()
miVentana.title('Mi clock')

def time():
    miTiempo = strftime('%H:%M:%S %p')
    clock.config(text = miTiempo)
    clock.after(1000, time)

clock = Label(miVentana, font = ('arial', 40, 'bold'),
                                 background = 'dark green',
                                 foreground = 'white')
clock.pack(anchor = 'center')

time()
mainloop()

