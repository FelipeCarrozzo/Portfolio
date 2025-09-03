library(caret)
library(pROC)
library(ISLR)
library(readxl)

#A. Explore los datos. De qué tipo son las variables?
uner <- fread("C:/Users/usr/Documents/ModeladoEstadistico/ClasifSupervisada_rLogistica/c_consulta.csv") 
summary(uner)
plot(uner$examen_estadistica)
plot(uner$clases_consulta)

#sexo: cualitativa
#examen_estadistica: cuantitativa continua
#clases_consulta: dicotómica

#B. Genere un modelo con las variables adecuadas que prediga 
#la probabilidad de que el estudiante tenga que asistir a clases de consulta.

set.seed(19) #fijo la semilla
porcentaje <- 0.7 #divido el porcentaje utilizado para entrenamiento y para testeo
N <- nrow(uner) #cantidad de filas
tamanio <- floor(porcentaje*N) 

#encuentro el conjunto de índices de entrenamiento
#utilizo la validación simple: muestreo aleatorio
entrenamientoUNER <- sample(seq_len(N),size = tamanio)

#separo los datos
entrenamiento <- uner[entrenamientoUNER,] #entrenamiento aleatorio
testeo <- uner[-entrenamientoUNER,] #saca el complemento, el restante, lo que no está en train

#veo la proporcion de los datos
table(entrenamiento$clases_consulta)
table(testeo$clases_consulta)

#ahora encuentro el modelo de reg logística con datos de ENTRENAMIENTO
modeloUNER <- glm(clases_consulta~examen_estadistica, entrenamiento, family = "binomial")
summary(modeloUNER) #coeficientes de la transformación

#grafico el modelo
plot(clases_consulta~examen_estadistica, entrenamiento, col = rainbow(2))

curve(1/(1 + exp(-modeloUNER$coefficients[1]-
                   modeloUNER$coefficients[2]* x)),
      add = TRUE, col = 'green4')

#predecimos con datos de TESTEO
prediccion <- predict(modeloUNER, testeo, type = "response") 
 
prediccionModelo <- ifelse(prediccion> 0.5,1,0)

#ROC
plot.roc(prediccionModelo,testeo$clases_consulta)
#error: prediccionModelo tiene solo valores 'cero'
unique(prediccionModelo)
unique(testeo$clases_consulta)
#ÁREA BAJO LA CURVA
auc(prediccion, entrenamiento$clases_consulta)

#MATRIZ DE CONFUSIÓN
matrizDeConfianza <- confusionMatrix(factor(prediccionModelo), 
                                factor(testeo$clases_consulta))
matrizDeConfianza$table
