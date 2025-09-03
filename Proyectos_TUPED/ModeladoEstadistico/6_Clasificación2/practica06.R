#Ejercicio 1 regresión logística----
rm(list = ls())
gc()
# Cargamos los paquetes que vamos a utilizar
library("data.table")
library("caret")
library("fastDummies") # Para dummy_cols()
library("pROC")
# Cargamos los datos
datos <- fread("./datos/c_consulta.csv", stringsAsFactors = T, sep = ";")

# Vemos que sexo es categórica, entonces hacemos a variable dummies
datos2 <- dummy_cols(datos, 
                     select_columns = "sexo",
                     remove_selected_columns = T)
str(datos2)
# Particionamos los datos
# Inicializamos la semilla aleatoria
set.seed(1234)
porc <- 0.8
# Encontramos el n?mero de observaciones de los datos
N <- nrow(datos2)
# Encontramos el tama?o de la partici?n de entrenamiento
tamanio <- floor(porc*N) # Usamos floor() para eliminar los decimales
# Encontramos el conjunto de indices de entrenamiento
train.ind <- sample(seq_len(N),size = tamanio)
# Separamos los datos
datos.train <- datos2[train.ind,]
datos.test <- datos2[-train.ind,]
#
table(datos.train$clases_consulta)
table(datos.test$clases_consulta)
# Generamos el modelo
modelo <- glm(clases_consulta ~ ., 
              datos.train, 
              family = "binomial")
summary(modelo)
# Predecimos en los datos de test
datos.pred <- predict(modelo, datos.test, type = "response")
pred.modelo <- ifelse(datos.pred > 0.5,1,0)
# Graficamos la curva ROC
plot.roc(pred.modelo,datos.test$clases_consulta)
auc(pred.modelo,datos.test$clases_consulta) # AUC = 0.6667
# Con el modelo anterior daba 0.4054 el AUC
#Calculamos el porcentaje:
porc.pos <- round(mean(pred.modelo == datos.test$clases_consulta),3)*100
porc.pos # El 81.6 % de las clasificaciones es correcta, antes teníamos el 78.9%
#Ejercicio 2 regresión logística----
rm(list = ls())
gc()
# Cargamos los paquetes que vamos a utilizar
library("readxl")
library("caret")
library("pROC")
library("fastDummies")
# 
datos <- read_excel("./datos/demencia.xls")
# a)
str(datos)
#Eliminamos la variable ID
datos$ID <- NULL
datos$T3DEMEN <- factor(datos$T3DEMEN)
datos$HIGHBP <- factor(datos$HIGHBP)
datos$WINE <- factor(datos$WINE)
summary(datos)
# Vemos los datos
plot(datos, col=datos$T3DEMEN)
# b)
# Hacemos las variables dummies
datos <- dummy_cols(datos, 
                    select_columns = c("WINE","HIGHBP"),
                    remove_selected_columns = T)
str(datos)
summary(datos)
# Inicializamos la semilla aleatoria
set.seed(1234)
porc <- 0.8
# Encontramos el n?mero de observaciones de los datos
N <- nrow(datos)
# Encontramos el tama?o de la partici?n de entrenamiento
tamanio <- floor(porc*N) # Usamos floor() para eliminar los decimales
# Encontramos el conjunto de indices de entrenamiento
train.ind <- sample(seq_len(N),size = tamanio)
# Separamos los datos
datos.train <- datos[train.ind,]
datos.test <- datos[-train.ind,]
#
table(datos.train$T3DEMEN)
table(datos.test$T3DEMEN)
# Encontramos el modelo
modelo <- glm(T3DEMEN~., datos.train, family = "binomial")
summary(modelo)
#El modelo queda:
#             Estimate Std. Error z value Pr(>|z|)    
# (Intercept) -5.06671    3.30066  -1.535 0.124770    
# AGE          0.11669    0.03325   3.509 0.000449 ***
# MMSE        -0.28767    0.05774  -4.982  6.3e-07 ***
# WINE_0       1.27928    0.78647   1.627 0.103821    
# WINE_1       0.98891    0.77848   1.270 0.203973    
# WINE_2            NA         NA      NA       NA    
# HIGHBP_0     1.18991    0.75354   1.579 0.114314    
# HIGHBP_1          NA         NA      NA       NA
# c)
# Las variables relevantes para el modelo son AGE y MMSE
# d)
# Predecimos en los datos de test
datos.pred <- predict(modelo, datos.test, type = "response")
pred.modelo <- ifelse(datos.pred > 0.5,1,0)
confusionMatrix(factor(pred.modelo),datos.test$T3DEMEN)
#           Reference
# Prediction  0  1
#          0 36  8
#          1  2  9
# 
# Accuracy : 0.8182
#Calculamos el porcentaje:
porc.pos <- round(mean(pred.modelo == datos.test$T3DEMEN),3)*100
porc.pos # El 81.8 % de las clasificaciones es correcta
# e) Probamos con un caso nuevo
dato.nuevo <- data.frame(AGE = 70, 
                         MMSE = 25, 
                         WINE_0 =0,
                         WINE_1 = 1, 
                         WINE_2 = 0, 
                         HIGHBP_0 = 0,
                         HIGHBP_1 = 1)
casoNuevo <- predict(modelo, newdata= dato.nuevo, type="response")
# La probabilidad del caso nuevo es 0.043 y como es menor a 0.5 debería ser categoría 0
#ejercicio3 k-NN---- 

rm(list = ls())
gc()
# Cargamos los paquetes que vamos a usar
library("caret")
library("class")
# Cargamos los datos
data("iris")
head(iris)
table(iris$Species)
# a) Validación simple
# Inicializamos la semilla aleatoria
set.seed(1234)
porc <- 0.8
# Encontramos el número de observaciones de los datos
N <- nrow(iris)
# Encontramos el tamaño de la partición de entrenamiento
tamanio <- floor(porc*N) # Usamos floor() para eliminar los decimales
# Encontramos el conjunto de indices de entrenamiento
train.ind <- sample(seq_len(N),size = tamanio)
# Separamos los datos
datos.train <- iris[train.ind,]
datos.test <- iris[-train.ind,]

k <- 5

# Entrenamos el modelo diciendole que tome 4 vecinos para cada punto
pred.knn <- knn(train = datos.train[, 1:4], 
                test = datos.test[, 1:4], 
                cl = datos.train$Species, 
                k = k)
# a) Evaluamos
mat.conf <- confusionMatrix(pred.knn,
                            datos.test$Species)
mat.conf$table
mat.conf$overall[1] #Accuracy = 0.866
# b) Error medio de la predicción
error <- mean(pred.knn!=datos.test$Species)
error # 0.133
# c) Ajustamos el n° de vecinos
# Vemos como varía el error de acuerdo a la cantidad de vecinos que tomemos
prediccion <- NULL
error <- NULL
# Armamos un vector con las clases de las observaciones de entrenamiento
clases <- datos.train$Species
# Iteramos para encontrar el k óptimo
for (i in 1:10) {
  prediccion <- knn(datos.train[1:4],
                    datos.test[1:4],
                    clases,
                    k=i)
  error[i] <- mean(prediccion!=datos.test$Species)
  
}
# Armamos un dataframe
knn.error <- as.data.frame(cbind(k=1:10,error = error))
# Graficamos el error en función del n° k de vecinos
plot(knn.error$error ~ knn.error$k, 
     type = "l", 
     col = "blue", 
     xlab = "k vecinos", 
     ylab = "Error",
     main = "Error vs k")
# Vemos que el k óptimo es 8 o 9
# Entrenamos el modelo diciendole que tome 8 vecinos para cada punto
pred.knn2 <- knn(train = datos.train[, 1:4], 
                 test = datos.test[, 1:4], 
                 cl = clases, 
                 k = 8)

# Evaluamos
mat.conf2 <- confusionMatrix(pred.knn2,
                             datos.test$Species)
mat.conf2$table
mat.conf2$overall[1] #Accuracy = 0.966
# Error medio de la predicción
error2 <- mean(pred.knn2!=datos.test$Species)
error2 # 0.033
#Ejercicio 4vecinos----
# 
rm(list = ls())
gc()
# Cargamos los paquetes que vamos a usar
library("data.table")
library("caTools") # Para sample.split()
library("caret")
# Cargamos los datos
glass <- fread("./datos/glass.csv", sep = ";")
# a) Exploramos los datos
head(glass)
summary(glass)
str(glass)
table(glass$Type)
# Graficamos los datos
plot(glass[,1:9], col = factor(glass$Type))
# b) Separamos los datos
# Como la columna de la clase es de tipo numérico, lo pasamos a factor
glass$Type <- factor(glass$Type)
# Inicializamos la semilla aleatoria
set.seed(1234)
# Encontramos el conjunto de indices de entrenamiento
ind.corte <- sample.split(glass$Type, SplitRatio = 0.7)
# Separamos los datos
glass.train <- subset(glass, ind.corte == T)
glass.test <- subset(glass, ind.corte == F)
# Vemos la relación de clases
table(glass.train$Type)
table(glass.test$Type)
# c) Determinamos el N° de vecinos óptimo
prediccion <- NULL
error <- NULL
clases <- glass.train$Type
for (i in 1:15) {
  prediccion <- knn(glass.train[,1:9],
                    glass.test[,1:9],
                    clases,
                    k=i)
  error[i] <- mean(prediccion!=glass.test$Type)
  
}
# Armamos un dataframe
knn.error <- as.data.frame(cbind(k=1:15,error = error))
# Graficamos el error en función del n° k de vecinos
plot(knn.error$error ~ knn.error$k, 
     type = "l", 
     col = "blue", 
     xlab = "k vecinos", 
     ylab = "Error",
     main = "Error vs k")
# En principio, el k óptimo sería 3 (no tomamos en 1)
modelo <- knn(glass.train[,1:9],
              glass.test[,1:9],
              clases,
              k=3)
# d) Obtenemos la matriz de confusión y las métricas
glass.conf <- confusionMatrix(modelo, 
                              glass.test$Type)
glass.conf$table
glass.conf$overall[1] #0.754
# Ejercicio 5 k-NN----
rm(list = ls())
gc()
# Cargamos los paquetes que vamos a usar
library("data.table")
library("caTools")
library("caret")
library("MASS")
intRR <- fread("./datos/datasetRR.csv", sep = ",", stringsAsFactors = T)
# 
head(intRR)
summary(intRR)
table(intRR$clase)
summary(is.na(intRR)) # Vemos que tiene valores NA

table(intRR$clase)
aux <- table(intRR$clase)/nrow(intRR)
aux
# b) Separamos en 10% test y 90% train
# Inicializamos la semilla aleatoria
set.seed(1234)
# Encontramos el conjunto de indices de entrenamiento
ind.corte <- sample.split(intRR$clase, SplitRatio = 0.9)
# Separamos los datos
datos.train <- na.omit(subset(intRR, ind.corte == T))
datos.test <- na.omit(subset(intRR, ind.corte == F))
# Vemos la relación de clases
table(datos.train$clase)
table(datos.test$clase)
# c) Modelo kNN
# Evaluamos el n° de vecinos cercanos
prediccion <- NULL
error <- NULL
clases <- datos.train$clase
#
col.buenas <- c(2:16)
for (i in 1:20) {
  prediccion <- knn(datos.train[,..col.buenas],
                    datos.test[,..col.buenas],
                    clases,
                    k=i)
  error[i] <- mean(prediccion!=datos.test$clase)
  
}
# Armamos un dataframe
knn.error <- as.data.frame(cbind(k=1:20,error = error))
# Graficamos el error en función del n° k de vecinos
plot(knn.error$error ~ knn.error$k, 
     type = "l", 
     col = "blue", 
     xlab = "k vecinos", 
     ylab = "Error",
     main = "Error vs k")
# En principio, el k óptimo sería 16
modelo <- knn(datos.train[,..col.buenas],
              datos.test[,..col.buenas],
              clases,
              k=16)
# Obtenemos la matriz de confusión
datos.conf <- confusionMatrix(modelo, datos.test$clase)
datos.conf$table

datos.conf$overall[1] # Accuracy = 0.728
# d) Encontramos un modelo LDA
modelo.lda <- lda(clase ~ ., data = datos.train[,2:17]) # No usamos ID
modelo.lda
# Testeamos
pred.lda <- predict(modelo.lda, 
                    newdata = datos.test[,2:17], 
                    type = "prob")
# Evaluamos el modelo
mat.conf.lda <- confusionMatrix(pred.lda$class,
                                datos.test$clase)
mat.conf.lda$table
mat.conf.lda$overall[1] # Accuracy = 0.724
# QDA
modelo.qda <- qda(clase ~., data = datos.train[,2:17]) # No usamos el ID
# Testeamos
pred.qda <- predict(modelo.qda, 
                    newdata = datos.test[,2:17], 
                    type = "prob")
# Evaluamos el modelo
mat.conf.qda <- confusionMatrix(pred.qda$class,
                                datos.test$clase)
mat.conf.qda$table
mat.conf.qda$overall[1] # Accuracy = 0.69 da peor
#Ejercicio 6 LDA y QDA/LOOCV----

# Cargamos los paquetes que vamos a utilizar
library("MASS")       # Para lda()
library("data.table") # Para abrir los datos
library("caret")      # Para confusionMatrix()
library("caTools")    # Para sample.split()
library("ggplot2")    # Para ggplot()
library("pROC")       # Para plot.roc() y auc()

# Cargamos los datos
datos <- fread("./datos/haberman.csv")
# a) Exploramos los datos
str(datos)
# Pasamos la clase a factor
datos$Estado <- factor(datos$Estado)
# Vemos la distribución de datos de la variable año de operación
ggplot(data = datos, aes(x = Estado, y = AnioOp, fill = Estado)) + geom_boxplot()
ggplot(data = datos, aes(x = Estado, y = Edad, fill = Estado)) + geom_boxplot()
ggplot(data = datos, aes(x = Estado, y = NumNodos, fill = Estado)) + geom_boxplot()
# Vamos a considerar todas las variables para el AD
# b) Validació simple 80%-20%
# Inicializamos la semilla aleatoria
set.seed(1234)
# Encontramos el conjunto de indices de entrenamiento
ind.corte <- sample.split(datos$Estado, SplitRatio = 0.8)
# Separamos los datos
datos.train <- subset(datos, ind.corte == T)
datos.test <- subset(datos, ind.corte == F)
# Vemos la relación de clases
table(datos.train$Estado)
table(datos.test$Estado)
# Entrenamos un modelo lda y uno qda
datos.adl <- lda(Estado ~ ., 
                 data = datos.train)
datos.adq <- qda(Estado ~ ., 
                 data = datos.train)
# Testeamos
datos.pred.adl <- predict(datos.adl, 
                          newdata = datos.test, 
                          type = "prob")
datos.pred.adq <- predict(datos.adq, 
                          newdata = datos.test, 
                          type = "prob")
# Vemos el porcentaje de bien clasificados
mean(datos.pred.adl$class==datos.test$Estado) # 73.77%
mean(datos.pred.adq$class==datos.test$Estado) # 73.77% igual
# Evaluamos con la curva ROC y AUC
plot.roc(datos.test$Estado,datos.pred.adl$posterior[,2])
auc(datos.test$Estado,datos.pred.adl$posterior[,2]) # AUC = 0.665
plot.roc(datos.test$Estado,datos.pred.adq$posterior[,2])
auc(datos.test$Estado,datos.pred.adq$posterior[,2]) # AUC = 0.581 peor
# LOOCV
datos.adl.loocv <- lda(x = datos[,1:3],
                       grouping = datos$Estado,
                       CV = T)
datos.adq.loocv <- qda(x = datos[,1:3],
                       grouping = datos$Estado,
                       CV = T)
# Evaluamos
plot.roc(datos$Estado,datos.adl.loocv$posterior[,2])
auc(datos$Estado,datos.adl.loocv$posterior[,2]) # AUC = 0.676
plot.roc(datos$Estado,datos.adq.loocv$posterior[,2])
auc(datos$Estado,datos.adq.loocv$posterior[,2]) # AUC = 0.684 un poco mejor
# c) k-fold cross validation
trControl <- trainControl(method  = "cv",
                          number  = 5) # 5 particiones de datos
# Entrenamos un modelo de lda y qda
datos.adl.cv <- train(Estado ~ .,
                      method     = "lda",
                      trControl  = trControl,
                      metric     = "Accuracy",
                      data       = datos)
datos.adq.cv <- train(Estado ~ .,
                      method     = "qda",
                      trControl  = trControl,
                      metric     = "Accuracy",
                      data       = datos)
# Obtenemos las predicciones
datos.predl.cv <- predict(datos.adl.cv,
                          type = "prob")
datos.predq.cv <- predict(datos.adq.cv,
                          type = "prob")
# Si queremos las clases predichas, el parámetro 
#  type = "raw" o no ponerlo
# Evaluamos el modelo
plot.roc(datos$Estado,datos.predl.cv[,2])
auc(datos$Estado,datos.predl.cv[,2]) # AUC = 0.7034
plot.roc(datos$Estado,datos.predq.cv[,2])
auc(datos$Estado,datos.predq.cv[,2]) # AUC = 0.7204
# Vemos que mejoró respecto a los anteriores métodos de
# validación.
#Ejercicio 7/modelo bayesiano----

rm(list = ls())
gc()
# Cargamos los paquetes que vamos a usar
library("data.table")
library("e1071")
library("naivebayes")
library("caret")
library("pROC")
# Cargamos los datos
titanic <- fread("./datos/titanic.csv")
# a) Exploramos los datos
head(titanic)
str(titanic)
# Vamos a cambiarle los nombre a Siblings/Spouses Aboard y a
# Parents/Children Aboard
colnames(titanic) # Vemos los nombres de las variables
colnames(titanic)[6] <- "heabordo" #hermanos/esposas a bordo
colnames(titanic)[7] <- "phabordo" #padres/hijos a bordo
# Vamos a pasar a factor las variables categóricas
titanic$Survived <- factor(titanic$Survived)
titanic$Pclass <- factor(titanic$Pclass)
titanic$Sex <- factor(titanic$Sex)
titanic$heabordo <- factor(titanic$heabordo)
titanic$phabordo <- factor(titanic$phabordo)
# Encontramos las tablas de frecuencias de cada categoría para cada variable
table(titanic$Survived)
table(titanic$Pclass)
table(titanic$Sex)
table(titanic$heabordo)
table(titanic$phabordo)
# Para clasificar usamos: Pclass, Sex, heabordo y phabordo
# b) Encontramos un clasificador naive Bayes con validación simple
# 80%-20%
# Inicializamos la semilla aleatoria
set.seed(1234)
porc <- 0.8
# Encontramos el número de observaciones de los datos
N <- nrow(titanic)
# Encontramos el tamaño de la partición de entrenamiento
tamanio <- floor(porc*N) # Usamos floor() para eliminar los decimales
# Encontramos el conjunto de indices de entrenamiento
train.ind <- sample(seq_len(N),size = tamanio)
# Separamos los datos
titanic.train <- titanic[train.ind,]
titanic.test <- titanic[-train.ind,]
# Vamos a usar las variables: Pclass, Sex, heabordo y phabordo
# Primero con el paquete e1071
modelo.titanic <- naiveBayes(Survived~Pclass+Sex+heabordo+phabordo,
                             data = titanic.train)
titanic.pred <- predict(modelo.titanic, titanic.test)
# Encontramos la matriz de confusión
conf.mat <- confusionMatrix(titanic.pred, titanic.test$Survived)
conf.mat$table
conf.mat$overall[1]
# Encontramos un modelo usando el paquete naivebayes
modelo.titanic2 <- naive_bayes(Survived~Pclass+Sex+heabordo+phabordo,
                               data = titanic.train)
titanic.pred2 <- predict(modelo.titanic2, titanic.test)
# Encontramos la matriz de confusión
conf.mat2 <- confusionMatrix(titanic.pred2, titanic.test$Survived)
conf.mat2$table
# c) Evaluamos el modelo
conf.mat$overall[1]   #Accuracy = 0.7640449
conf.mat2$overall[1]  #Accuracy = 0.7640449 da igual
# Lo pasamos a numerico
a1 <- ifelse(titanic.test$Survived == "1",0,1)
a2 <- ifelse(titanic.pred == "1",0,1)
plot.roc(x = a1, predictor = a2)
auc(a1, a2) # AUC = 0.758
a22 <- ifelse(titanic.pred2 == "1",0,1)
plot.roc(x = a1, predictor = a22)
auc(a1, a22) # AUC = 0.758 # Da igual
#Ejercicio 8/clasificador bayesiano----
rm(list = ls())
gc()
# Cargamos los paquetes que vamos a usar
library("data.table")
library("e1071")
library("naivebayes")
library("caret")
# Cargamos los datos y ya pasamos los tipo chr a factor
datos <- fread("./datos/trenes.txt", stringsAsFactors = T)
# a) Exploramos los datos
head(datos)
str(datos)

table(datos$puntualidad)
# 
# b) Encontramos un clasificador naive Bayes con validación simple
# 80%-20%
# Inicializamos la semilla aleatoria
set.seed(1234)
porc <- 0.8
# Encontramos el número de observaciones de los datos
N <- nrow(datos)
# Encontramos el tamaño de la partición de entrenamiento
tamanio <- floor(porc*N) # Usamos floor() para eliminar los decimales
# Encontramos el conjunto de indices de entrenamiento
train.ind <- sample(seq_len(N),size = tamanio)
# Separamos los datos
datos.train <- datos[train.ind,]
datos.test <- datos[-train.ind,]
# Encontramos el modelo
modelo <- naive_bayes(puntualidad~., data = datos.train)
pred <- predict(modelo, datos.test)
# Evaluamos el modelo
mat.conf <- confusionMatrix(pred, datos.test$puntualidad)
mat.conf$table
mat.conf$overall[[1]] # Accuracy = 1
#  c)
datos2 <- fread("./datos/trenes2.txt", stringsAsFactors = T)
# Inicializamos la semilla aleatoria
set.seed(1234)
porc <- 0.8
# Encontramos el número de observaciones de los datos
N2 <- nrow(datos2)
# Encontramos el tamaño de la partición de entrenamiento
tamanio2 <- floor(porc*N2) # Usamos floor() para eliminar los decimales
# Encontramos el conjunto de indices de entrenamiento
train.ind2 <- sample(seq_len(N2),size = tamanio2)
# Separamos los datos
datos.train2 <- datos2[train.ind2,]
datos.test2 <- datos2[-train.ind2,]
# Encontramos un nuevo modelo
modelo2 <- naiveBayes(puntualidad~., data = datos.train2)
pred2 <- predict(modelo2, datos.test2)
# Evaluamos el nuevo modelo
mat.conf2 <- confusionMatrix(pred2, datos.test2$puntualidad)
mat.conf2$table
mat.conf2$overall[[1]] # Accuracy = 0.818

table(datos2$puntualidad)
# Mejoramos la clasificación
# Probamos 5-fold CV usando tune() del paquete e1071
tunecontrol <- tune.control(sampling = "cross",
                            cross = 5) # 5 particiones
modelo.cv <- tune(method = "naiveBayes",
                  train.x = puntualidad~., 
                  data = datos2,
                  tunecontrol = tunecontrol)
pred.cv <- predict(modelo.cv$best.model,datos2)

mat.conf.cv <- confusionMatrix(pred.cv,datos2$puntualidad)
mat.conf.cv$table
mat.conf.cv$overall[1] # Accuracy = 0.9230769
# Obviamente, si existiera la posibilidad de conseguir más datos
# con la categoría "muy_tarde" el modelo podría "aprender" más.