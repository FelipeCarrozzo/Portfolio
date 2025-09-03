install.packages('caret')
library("caret")
install.packages('pROC')
library(pROC)

#---- 
#EJERCICIO 1: becas

#exploro el dataset
plot(beca)
becas <- na.omit(beca)
table(becas$beca)
#fijamos la semilla aleatoria (como en el juego Guerra)
set.seed(1234)

porc1 <- 0.7 #70 - 30
porc2 <- 0.8 #80 - 20
porc3 <- 0.9 #90 - 10
N <- nrow(becas)
N
tamanio1 <- floor(porc1*N) #elimino los decimales con
tamanio1
tamanio2 <- floor(porc2*N) #elimino los decimales con
tamanio2
tamanio3 <- floor(porc3*N) #elimino los decimales con
tamanio3

#encuentro el conjunto de índices de entrenamiento
entrenamiento1 <- sample(seq_len(N),size = tamanio1)
entrenamiento1
entrenamiento2 <- sample(seq_len(N),size = tamanio2)
entrenamiento2
entrenamiento3 <- sample(seq_len(N),size = tamanio3)
entrenamiento3

#separo los datos
entrenBecas1 <- becas[entrenamiento1,] #entrenamiento aleatorio
testBecas1 <- becas[-entrenamiento1,] #saca el complemento, el restante, lo que no está en train
entrenBecas2 <- becas[entrenamiento2,] #entrenamiento aleatorio
testBecas2 <- becas[-entrenamiento2,]
entrenBecas3 <- becas[entrenamiento3,] #entrenamiento aleatorio
testBecas3 <- becas[-entrenamiento3,]

#veo la proporcion de los datos
table(entrenBecas1$beca)
table(testBecas1$beca)

table(entrenBecas2$beca)
table(testBecas2$beca)

table(entrenBecas3$beca)
table(testBecas3$beca)

#encuentro el modelo de reg logística con datos de ENTRENAMIENTO
modelo.becas1 <- glm(beca~matematica, entrenBecas1, family = "binomial")
summary(modelo.becas1) #coeficientes de la transformación

modelo.becas2 <- glm(beca~matematica, entrenBecas2, family = "binomial")
summary(modelo.becas2)

modelo.becas3 <- glm(beca~matematica, entrenBecas3, family = "binomial")
summary(modelo.becas3)

#grafico el modelo
plot(beca~matematica, entrenBecas1, col = factor(entrenBecas1$beca))
curve(1/(1 + exp(-modelo.becas1$coefficients[1]-
                   modelo.becas1$coefficients[2]* x)),
      add = TRUE, col = 'green4')

plot(beca~matematica, entrenBecas2, col = factor(entrenBecas2$beca))
curve(1/(1 + exp(-modelo.becas2$coefficients[1]-
                   modelo.becas2$coefficients[2]* x)),
      add = TRUE, col = 'green4')

plot(beca~matematica, entrenBecas3, col = factor(entrenBecas3$beca))
curve(1/(1 + exp(-modelo.becas3$coefficients[1]-
                   modelo.becas3$coefficients[2]* x)),
      add = TRUE, col = 'green4')


#predecimos con datos de TESTEO

becas.pred1 <- predict(modelo.becas1, testBecas1, type = "response") 
becas.pred1
pred.modelo1 <- ifelse(becas.pred1 > 0.5,1,0)
pred.modelo1
#ROCK
plot.roc(pred.modelo1, testBecas1$beca)

becas.pred2 <- predict(modelo.becas2, testBecas2, type = "response") 
becas.pred2
pred.modelo2 <- ifelse(becas.pred2 > 0.5,1,0)
pred.modelo2
#ROCK
plot.roc(pred.modelo2, testBecas2$beca)

becas.pred3 <- predict(modelo.becas3, testBecas3, type = "response") 
becas.pred3
pred.modelo3 <- ifelse(becas.pred3 > 0.5,1,0)
pred.modelo3
#ROCK
plot.roc(pred.modelo3, testBecas3$beca)

#ÁREA BAJO LA CURVA
auc(pred.modelo1, entrenBecas1$beca) #0.7549
auc(pred.modelo2, entrenBecas2$beca)#0.9571
auc(pred.modelo3, entrenBecas3$beca)#0.3947



#----
#EJERCICIO 2: Default
install.packages('ISLR')
library(ISLR)
default <- Default


#exploro los datos
summary(default)
plot(default)

#paso a 0 y 1 el target para poder graficar
Default$default <- ifelse(Default$default=='Yes',1,0)
table(Default$default)

#fijo la alatoreidad con la semilla
set.seed(1234)
# 80 - 20
porcentaje <- 0.8
N <- nrow(Default)
tamanio <- floor(porcentaje*N)

#encuentro el conjunto de índices de entrenamiento
entrenDefault <- sample(seq_len(N),size = tamanio)
entrenDefault

#separo los datos
def.ent <- default[entrenDefault,] #entrenamiento aleatorio
def.test <- default[-entrenDefault,] #saca el complemento, el 
#restante, lo que no está en train

table(def.ent$default)
table(def.test$default)
#encuentro el modelo de reg logística
modelo.def <- glm(default~income, def.ent, family = "binomial")
summary(modelo.def)

#grafico el modelo y evaluo
plot(default~income, def.test, col = rainbow(3))

#agrego funcion ajustada
curve(1/(1 + exp(-modelo.def$coefficients[1]-
                   modelo.def$coefficients[2]* x)),
      add = TRUE, col = 'green4')

#predecimos los datossss
def.pred <- predict(modelo.def, newdata = def.test, type = "response") 
def.pred

pred.modelo <- ifelse(def.pred > 0.5,1,0)
pred.modelo

plot.roc(pred.modelo, def.test$balance)

auc(pred.modelo, def.test$beca) #area bajo la curva = 0.7263

