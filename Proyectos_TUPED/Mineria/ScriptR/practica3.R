# 1
## limpio la memoria
rm( list=ls() )
gc()
# Cargamos los paquetes que vamos a usar
library("data.table") # para usar fread()

# Descargamos los datos

datos <- fread("C:/Users/alumno/Documents/MineriaDeDatos2024/merval.csv")


N <- dim(datos)[1]

datos_ts <- ts(data = datos$V1, frequency = 20)

ts.plot(datos_ts, gpars = list(xlab = "meses",
                               ylab = "Merval", 
                               main = "2002 - 2003"))


matriz <- matrix(datos$V1, ncol = 6, byrow = TRUE)
matriz

conv_dataTable <- data.table(matriz)
conv_dataTable

# 2
## limpio la memoria
rm( list=ls() )
gc()
# Cargamos los paquetes que vamos a usar
library("data.table") # para usar fread()

# Descargamos los datos

datos <- fread("C:/Users/alumno/Documents/MineriaDeDatos2024/Entrenamiento_ECI_2020.csv")
datos
daots.column()
