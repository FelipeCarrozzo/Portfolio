#----
#librerias
library(data.table)
library(ggplot2)
library(dplyr)
library(rmatio)
#install.packages("rmatio")

#----
#Ejercicio 1
rm( list=ls() )
gc()
datos = fread("C:/Users/felip/OneDrive/Documentos/TUPED/3erAño/Mineria/Datos/Entrenamiento_ECI_2020.csv")

#dimension de los datos
dim(datos) #filas 16947 cols 52

#tipo de atributos
str(datos)

#medidas de resumen
summary(datos$Total_Amount)

#datos NaN
sum(is.na(datos)) #6477 Na's

#Transforme los datos de la variable objetivo (Stage)
str(datos$Stage)
table(datos$Stage)

#cambio a tipo fecha
datos$Account_Created_Date = as.Date(datos$Account_Created_Date,
                                     format = "%m/%d/%y")

datos$Opportunity_Created_Date = as.Date(datos$Opportunity_Created_Date,
                                     format = "%m/%d/%y")
datos$Quote_Expiry_Date = as.Date(datos$Quote_Expiry_Date,
                                         format = "%m/%d/%y")

datos$Last_Activity = as.Date(datos$Last_Activity,
                                  format = "%m/%d/%y")

datos$Last_Modified_Date = as.Date(datos$Last_Modified_Date,
                              format = "%m/%d/%y")

datos$Planned_Delivery_Start_Date = as.Date(datos$Planned_Delivery_Start_Date,
                                   format = "%m/%d/%y")

datos$Planned_Delivery_End_Date = as.Date(datos$Planned_Delivery_End_Date,
                                            format = "%m/%d/%y")

datos$Planned_Delivery_End_Date = as.Date(datos$Planned_Delivery_End_Date,
                                          format = "%m/%d/%y")


datos$Actual_Delivery_Date = as.Date(datos$Actual_Delivery_Date,
                                          format = "%m/%d/%y")


#Filtro STAGE
datos_filt <- datos %>%
  filter(Stage == "Closed Lost" | Stage == "Closed Won")

#cambio tipo de dato de Stage (Character - Factor)
datos_filt$Stage <- factor(datos_filt$Stage)
#checkeo cambio
class(datos_filt$Stage)

#grafico hasta los valores del 3er cuartil
#toma todos los valores, pero donde total_amount es menor a ese valor
ggplot(data = datos_filt[datos_filt$Total_Amount <= 4.604e+05,],
       aes(x = Stage, y = Total_Amount, fill = Stage))+
  geom_boxplot()

#GRAFICO DISPERSION
#genero un data.table para hacer el grafico
datosDisp <- data.table(TRF = datos_filt$TRF, Total_Amount = datos_filt$Total_Amount, 
                        Total_Taxable_Amount = datos_filt$Total_Taxable_Amount,
                        Stage = datos_filt$Stage)

#corroboro la cantidad de datos en el data.table
cantidad_datos <- unlist(lapply(datosDisp, length))
cantidad_datos

#intento graficar...
ggplot(data = datosDisp, aes(x = Stage, y = TRF)) + 
  geom_point()+
  theme(panel.background = element_rect(fill = "#67c9ff"))

ggplot(datosDisp, aes(x = Stage, y = Total_Amount, color = clase)) 
  geom_point() +
  labs(x = "TRF", y = "Total Amount", color = "Clase") +
  ggtitle("Gráfico de dispersión de TRF vs Total Amount por clase")

#-----
#Ejercicio 2
rm( list=ls() )
gc()

#abro carpeta con archivos .mat
ruta = "C:/Users/felip/OneDrive/Documentos/TUPED/3erAño/Mineria/Datos/archi.mat"
#abro .csv que tengo que reescribir
estadisticas = fread("C:/Users/felip/OneDrive/Documentos/TUPED/3erAño/Mineria/Datos/datasetRR.csv")


# Forma simple y rápida y eficiente (by Nassim)
nombres <- list.files(ruta, pattern = "*.mat",full.names = T) 
# Es T porque necesito que me devuelva la ruta con el nombre del archivo

#guardo en AUX(large list) todos los archivos
aux <- lapply(nombres, read.mat)

#Guardo esa lista con extension RADATA
#save(aux, file = "C:/Users/felip/OneDrive/Documentos/TUPED/3erAño/Mineria/Datos/ecgs.RDATA")

#Crear una función para procesar cada señal de ECG
procesar_señal <- function(señal) {
  # Calcular el tiempo total de la señal en segundos
  tiempo_total <- length(señal) / 300
}

pros_senal <- procesar_señal(aux[[14]][['val']])
pros_senal

#declaro las listas
tiempo_ecg = list()
min_ecg = list()
max_ecg = list()
media_ecg = list()
desv_ecg = list()


for (i in 1:200) {
  tiempo_ecg[i] <- procesar_señal(aux[[i]][['val']])
  min_ecg[i] <- min(aux[[i]][['val']])
  max_ecg[i] <- max(aux[[i]][['val']])
  media_ecg <- mean(aux[[i]][['val']])
  desv_ecg <- var(aux[[i]][['val']])
}

estad_nuevo <- cbind(estadisticas, tiempo_ecg, min_ecg, max_ecg, media_ecg, desv_ecg)
estad_nuevo

