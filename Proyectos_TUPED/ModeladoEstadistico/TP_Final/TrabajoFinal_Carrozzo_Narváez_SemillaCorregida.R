#Trabajo Práctico Final Modelado Estadístico - Carrozzo, Narváez

library(data.table)
library(caret)
library(pROC)
library(dplyr)
library(GGally)

#feli
datos <-read.csv ("C:/Users/usr/Documents/TUPED/2doAño/ModeladoEstadistico/TP_Final/Cancer_Wisconsin_Diagnostic.csv", sep =',')
#mica
datos <- read.csv('C:/Users/micae/OneDrive/Escritorio/TUPED/Modelado estadistico/Cancer_Wisconsin_Diagnostic.csv', sep =',')

#Exploro los datos----
str(datos)
#Cambio el tipo de la variable DIAGNOSIS de char a factor
datos <- datos %>% 
  mutate(diagnosis = as.factor(diagnosis))
#chequeo el cambio 
str(datos)


barplot(table(datos$diagnosis), ylim = c(0, 500), xlab = 'Diagnóstico (B=benigno, M=maligno)',
        ylab = 'Cantidad de tumores', col = c("blue", "red"),
        main = "Distribución del diagnóstico")
legend("topright", legend = c("Benigno", "Maligno"), fill = c("blue", "red"))

plot(datos$radius_mean, pch = 16, col = ifelse(datos$diagnosis == "M", "red", "blue"),
     xlab = "RADIO", ylab = "DIAGNÓSTICO", main = "Dispersión: Radio del tumor vs Diagnóstico")

#le sumo al radio y el diagnóstico la cantidad de puntos de concavidad
plot(datos$concave.points_worst ~ datos$radius_worst,
     col = ifelse(datos$diagnosis == "M", "red", "blue"),
     xlab = "Mayor radio", ylab = "Puntos de concavidad",
     main = "Peor Radio vs Mayor cantidad de puntos de concavidad")
legend("bottomright", legend = c("Benigno", "Maligno"), fill = c("blue", "red"))

#CAMBIOS EN EL DATASET----
#CAMBIO Y PONGO QUE BENIGNO SEA 0 Y MALIGNO SEAN 1
datos$diagnosis <- ifelse(datos$diagnosis == "B", 0, 1)
#saco las columnas 1 y 33 
head(datos)
datos <- datos[2:32]
head(datos)


#MODELO N°1----
#H0: EXISTE RELACIÓN SIGNIFITCATIVA ENTRE EL DIAGNOSTICO y TODAS LAS VARIABLES 
#UTLIZAMOS EL MODELO DE REGRESIÓN LOGISTICA MÚLTIPLE

#Definimos el porcentaje de division para entrenamiento y testeo
set.seed(6854)
porc <- 0.8
N <- nrow(datos)
tamanio <- floor(porc*N)

#muestreo
train.ind <- sample(seq_len(N), size = tamanio)

#division de los datos
datos.train <- datos[train.ind,] #entrenamiento
datos.test <-  datos[-train.ind,] #testeo


# Verificar si hay valores NA en el dataframe
hay_na <- apply(datos, 2, function(x) sum(is.na(x)) > 0)

# Mostrar las columnas que contienen valores NA
nombres_columnas_con_na <- colnames(datos)[hay_na]

#diagnosis enfuncion de todas las variables
todas <- diagnosis ~.

#PRIMERO PRUEBO HACER EL MODELO CON TODAS LAS VARIABLES
modelo_uno <- glm(todas, datos.train, family = "binomial")
summary(modelo_uno)

#PREDICCIÓN
prediccion_uno <- predict(modelo_uno, datos.test, type = "response")
pred.modelo_uno <- ifelse(prediccion_uno > 0.5,1,0)
plot.roc(pred.modelo_uno, datos.test$diagnosis)

#Area Bajo la Curva
auc(pred.modelo_uno, datos.test$diagnosis)

#MATRIZ DE CONFUSION PARA EL MODELO CON TODAS LAS VARIABLES 
Mconfusion_uno <- confusionMatrix(factor(pred.modelo_uno), factor(datos.test$diagnosis))
Mconfusion_uno$table

#Accuracy para el modelo con todas las variables = 0.9210526
#Sensitivity = 0.9066667
#Specificity = 0.9714

#MODELO 2 ----
#H0: EXISTE RELACION SIGNIFICATIVA ENTRE EL DIAGNÓSTICO Y EL RADIO DEL TUMOR 
#UTLIZAMOS EL MODELO DE REGRESIÓN LOGISTICA SIMPLE
#hago el modelo con el diagnostico y el radio 
modelo_dos <- glm(diagnosis~radius_worst, datos.train, family = "binomial")
summary(modelo_dos)
plot(diagnosis~radius_worst, datos.train, col = ifelse(datos.train$diagnosis == 0, "blue", "red"))

#Curva ROC
prediccion_dos <- predict(modelo_dos, datos.test, type = "response")
pred.modelo_dos <- ifelse(prediccion_dos > 0.5,1,0)
plot.roc(pred.modelo_dos, datos.test$diagnosis)

#Area Bajo la Curva
auc(pred.modelo_dos, datos.test$diagnosis)
#MODELO N°3 ----
#H0: existe relacion significativa entre el diagnóstico y el radio y los puntos de concavidad
#UTLIZAMOS EL MODELO DE REGRESIÓN LOGISTICA
modelo_tres <- glm(diagnosis~radius_worst + concave.points_worst, datos.train, family = "binomial")
summary(modelo_tres)

prediccion_tres <- predict(modelo_tres, datos.test, type = "response")
pred.modelo_tres <- ifelse(prediccion_tres > 0.5,1,0)

#Curva ROC
plot.roc(pred.modelo_tres, datos.test$diagnosis)
#Area Bajo la Curva
auc(pred.modelo_tres, datos.test$diagnosis)


#MATRICES DE CONFUSIÓN ----

Mconfusion_uno <- confusionMatrix(factor(pred.modelo_uno), factor(datos.test$diagnosis))
Mconfusion_uno$table
#Accuracy = 0.9561404
#Sensitivity = 0.96 
#Specificity = 0.9487179 

Mconfusion_dos <- confusionMatrix(factor(pred.modelo_dos), factor(datos.test$diagnosis))
Mconfusion_dos$table
#Accuracy = 0.8947368
#Sensitivity = 0.9466667
#Specificity = 0.7948718 

Mconfusion_tres <- confusionMatrix(factor(pred.modelo_tres), factor(datos.test$diagnosis))
Mconfusion_tres$table
#Accuracy = 0.9211
#Sensitivity = 0.9143
#Specificity = 0.9318

#GRÁFICOS DE LAS MATRICES DE CONFUSIÓN
plot(Mconfusion_uno$table, col = c("#FF0000", "#0000FF"), main = "Matriz de Confusión", xlab = "Valor Real", ylab = "Predicción")
plot(Mconfusion_dos$table, col = c("#FF0000", "#0000FF"), main = "Matriz de Confusión", xlab = "Valor Real", ylab = "Predicción")
plot(Mconfusion_tres$table, col = c("#FF0000", "#0000FF"), main = "Matriz de Confusión", xlab = "Valor Real", ylab = "Predicción")
