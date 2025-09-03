#ejercicio1----
"Ejercicio 1 – Utilice los datos de la UNER, con los que encontró un modelo de 
regresión logística en el ejercicio 3 de la guía anterior, para encontrar un 
nuevo modelo para clasificar si el estudiante asistió a clases de consulta 
utilizando todas las variables disponibles de forma correcta."


install.packages('pROC')
install.packages('ISLR')
library(ISLR)
library(readxl)
library(caret)
library(pROC)

uner <- read.csv("C:/Users/usr/Documents/TUPED/2doAño/ModeladoEstadistico/1_Datasets/c_consulta.csv")
#ejercicio2----
"Ejercicio 2 – En el archivo “demencia.xls” se presentan datos de un estudio
sobre los factores de riesgo asociados con el Alzheimer. Se quiere determinar
si los incidentes de demencia pueden relacionarse con el consumo de vino y 
otras variables. 
El estudio se realizó sobre una muestra de adultos mayores entre los cuales 
hay algunos sin la enfermedad."
"REGRESION LINEAL"

demencia <- read_xls("C:/Users/usr/Documents/TUPED/2doAño/ModeladoEstadistico/1_Datasets/demencia.xls")
plot(demencia)
str(demencia)

filas <- nrow(demencia)
porc <- 0.8
tamanio <- porc*filas #217.6

#conjunto de entrenamiento
entrenamientogral <- sample(seq_len(filas), size=tamanio)
entren_demencia <- demencia[entrenamientogral,]
test_demencia <- demencia[-entrenamientogral,]

#veo la proporcion de los datos
table(entren_demencia$MMSE)
table(test_demencia$MMSE)

#encuentro el modelo de reg logística con datos de ENTRENAMIENTO
modelo_demencia<- glm(T3DEMEN~MMSE, entren_demencia, family = "binomial")
summary(modelo_demencia) #coeficientes de la transformación

#grafico el modelo
plot(T3DEMEN~MMSE, entren_demencia, col = factor(entren_demencia$MMSE))
curve(1/(1 + exp(-modelo_demencia$coefficients[1]-
                   modelo_demencia$coefficients[2]* x)),
      add = TRUE, col = 'green4')


#predecimos con datos de TESTEO
pred_demencia <- predict(modelo_demencia, test_demencia, type = "response") 
pred_demencia
pred_modeloDemencia <- ifelse(pred_demencia > 0.5,1,0)
pred_modeloDemencia

#ROCK
plot.roc(pred_modeloDemencia, test_demencia$MMSE)
auc(pred_modeloDemencia, entren_demencia$MMSE)
dim(pred_modeloDemencia)
dim(entren_demencia)

#ejercicio3----
"Ejercicio 3 - Utilice el dataset “iris” de R, separe en datos de entrenamiento
y testeo (80% train y 20% test) y con el algoritmo k-NN entrene un modelo de 
clasificación, utilizando un número k de vecinos de 5."

install.packages('class')
library(class)
library(caret)

data(iris)
class(iris)
unique(iris$Species)

set.seed(1234)
particion <- createDataPartition(iris$Species, p=0.8, list=FALSE)
entren_iris <- iris[particion,]
test_iris <- iris[-particion,]

prediccion <- knn(entren_iris, test_iris, k=1)
  