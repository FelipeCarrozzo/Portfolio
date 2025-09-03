library(data.table)
#IMPORTO EL DATASET EN EL SCRIPT
#fuente: https://www.kaggle.com/datasets/noriuk/us-education-datasets-unification-project
data <- fread("C:/Users/usr/Documents/TUPED/2doAño/ModeladoEstadistico/TP_Final/Cancer_Wisconsin_Diagnostic.csv")
#tamaño de filas y columnas
dim(data)
#veo el nombre de las variables y su tipo de dato
str(data)
#veo qué variables tienen valores NA
sapply(data, function(x) sum(is.na(x)))
#solo la variable 'concave points_worst' tiene NA

#veo los nombres de todas las variables
names(data)
#visualizo las primeras 6 lineas
head(data)
