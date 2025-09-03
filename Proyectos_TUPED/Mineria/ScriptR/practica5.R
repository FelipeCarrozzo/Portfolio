# install.packages('arules')
library(data.table)
library(arules)
library(dplyr)

# Algoritmo Apriori
#Liberamos la memoria
rm(list = ls())
gc()

#Abro los datos para exploracion
datos <- read.csv("C:/Users/felip/OneDrive/Documentos/TUPED/3erAño/Mineria/Datos/orders.csv", header = TRUE, sep = ";")
summary(datos)
class(datos)

#creo un objeto transacciones
transacciones <- read.transactions("C:/Users/felip/OneDrive/Documentos/TUPED/3erAño/Mineria/Datos/orders.csv", 
                                   header = TRUE, sep =  ";", format = "single", cols = c("order_id", "product_name"))

inspect(transacciones[1:3])
n.trans <- size(transacciones)

# Encontramos los itemsets frecuentes
soporte <- 0.001
itemsets_frec <- apriori(transacciones, 
                         parameter = list(support = soporte,
                                          target = "frequent itemsets"), 
                         control = list(verbose=F))
itemsets_frec

#los ordeno
itemsets <- sort(itemsets_frec, by = "support", decreasing = TRUE)

#muestro los primeros cinco
inspect(itemsets[1:5])

# Encontramos las reglas de asociación
confianza <- 0.7
reglas <- apriori(transacciones,
                  parameter = list(support = soporte,
                                   confidence = confianza,
                                   target = "rules"),
                  control = list(verbose = F))
reglas # Encontramos 4 reglas

# Ordenamos las reglas por confianza y las mostramos
inspect(sort(reglas, decreasing = TRUE, by = "confidence"))

size(reglas)

#----
#ejercicio 2
#Liberamos la memoria
rm(list = ls())
gc()

#cargo el archivo
load("C:/Users/felip/OneDrive/Documentos/TUPED/3erAño/Mineria/Datos/titanic.raw.RDATA")

confianza <- 0.8
soporte <- 0.005

reglas <- apriori(titanic.raw,
                  parameter = list(minlen=2, supp= 0.005,conf=0.8),
                  appearance = list(rhs=c("Survived=No", "Survived=Yes"),
                                   default="lhs"),
                  control = list(verbose=F))

inspect(reglas)
