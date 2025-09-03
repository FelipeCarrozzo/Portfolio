import tensorflow as tf
import numpy as np

celcius = np.array([-40, -10, 0, 8, 15, 22, 38], dtype=float)
farenhait = np.array([-40, 14, 32, 46, 59, 72, 100], dtype=float)

"""frameword KERAS"""
#especifico las capas de entrada y salida por separado
# capa = tf.keras.layers.Dense(units=1, input_shape=[1]) #units = neuronas: 1 - input_shape = 1 entrada
# modelo = tf.keras.Sequential([capa]) #modelo secuencial.

oculta1 = tf.keras.layers.Dense(units=3, input_shape=[1]) #units = neuronas: 1 - input_shape = 1 entrada
oculta2 = tf.keras.layers.Dense(units=3)
salida = tf.keras.layers.Dense(units=1)
modelo = tf.keras.Sequential([oculta1, oculta2, salida]) #modelo secuencial.

#ahora lo preparo para ser entrenado

modelo.compile(
    optimizer = tf.keras.optimizers.Adam(0.1),
    loss = 'mean_squared_error' #error cuadratico medio
)

print('Comenzando entrenamiento...')
historial = modelo.fit(celcius, farenhait, epochs=500, verbose=False)
print('Modelo entrenado!')

#Modelo entrenado. Veo el resultado de funcion de perdida: que tan mal están los resultados en cada vuelta


import matplotlib.pyplot as plt
plt.xlabel('# Epoca')
plt.ylabel('Magnitud de perdida')
plt.plot(historial.history['loss'])
plt.show()

#ahora que el modelo está entrenado, lo uso para predecir valores

print('Hagamos una predicción!')
resultado = modelo.predict([50.0])
print('El resultado es ' + str(resultado) + ' farenhait!')

#veo los pesos de la capa
# print('Variables internas del modelo')
# print(capa.get_weights())


