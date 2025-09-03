#BAYES INGENUO

library(e1071)
#Cargamos los datos del Titanic dese datasets
data("Titanic")
#Los almacenamos en un data frame
Titanic_df=as.data.frame(Titanic)
str(Titanic_df)
#Creamos una tabla de casos competos a partir de la frecuencia de cada uno
repeating_sequence=rep.int(seq_len(nrow(Titanic_df)), Titanic_df$Freq) 
#Esto repite cada caso seg�n la frecuencia dada en la col de la tabla.

#Creamos una nueva tabla repitiendo los casos seg�n el modelo anterior.
Titanic_dataset=Titanic_df[repeating_sequence,]
#Ya no necesitamos la tabla de frecuencias m�s.
Titanic_dataset$Freq=NULL
head(Titanic_dataset)
library(naivebayes)

# Ajustamos un modelo de naive bayes con la librer�a e1071
m.e1071 <- naiveBayes(Survived ~ ., data = Titanic_dataset)
m.e1071 # vemos el modelo
# realizamos la prediccion con el modelo
predicciones.m<-predict(m.e1071,Titanic_dataset)

# Matriz de confusi�n 
table(predicciones.m,Titanic_dataset$Survived)


#___________________________________________________________
#Discriminante Lineal

library(MASS)
data("Aids2")
str(Aids2)
# Modelo
ad=lda(status~diag+age,data=Aids2)
#predicci�n
probs=predict(ad,newdata=Aids2,type="prob")
data.frame(probs)[1:5,]
table(probs$class,Aids2$status)
mean(probs$class==Aids2$status) #porcentaje de bien clasificados
# Curva ROC
library(pROC)
plot.roc(Aids2$status,probs$posterior[,2])


#An�lisis Discriminante cuadr�tico
set.seed(8558)
grupoA_x <- seq(from = -3, to = 4, length.out = 100)
grupoA_y <- 6 + 0.15 * grupoA_x - 0.3 * grupoA_x^2 + rnorm(100, sd = 1)
grupoA <- data.frame(variable_z = grupoA_x, variable_w = grupoA_y, grupo = "A")

grupoB_x <- rnorm(n = 100, mean = 0.5, sd = 0.8)
grupoB_y <- rnorm(n = 100, mean = 2, sd = 0.8)
grupoB <- data.frame(variable_z = grupoB_x, variable_w = grupoB_y, grupo = "B")

datos <- rbind(grupoA, grupoB)
datos$grupo <- as.factor(datos$grupo)

plot(datos[, 1:2], col = datos$grupo, pch = 19)

library(ggplot2)
library(ggpubr)
p1 <- ggplot(data = datos, aes(x = variable_z, fill = grupo)) +
  geom_histogram(position = "identity", alpha = 0.5)
p2 <- ggplot(data = datos, aes(x = variable_w, fill = grupo)) +
  geom_histogram(position = "identity", alpha = 0.5)
ggarrange(p1, p2, nrow = 2, common.legend = TRUE, legend = "bottom")


#Contraste de normalidad Shapiro-Wilk para cada variable en cada grupo
library(reshape2)
datos_tidy <- melt(datos, value.name = "valor")
library(dplyr)
datos_tidy %>%
  group_by(grupo, variable) %>% 
  summarise(p_value_Shapiro.test = round(shapiro.test(valor)$p.value,5))
# La variable Z no se distribuye de forma normal en el grupo A.

modelo_qda <- qda(grupo ~ variable_z + variable_w, data = datos)
modelo_qda

predicciones <- predict(object = modelo_qda, newdata = datos)
table(datos$grupo, predicciones$class,
      dnn = c("Clase real", "Clase predicha"))

trainig_error <- mean(datos$grupo != predicciones$class) * 100
paste("trainig_error=",trainig_error,"%")

install.packages('KlaR')
library(klaR)
partimat(formula = grupo ~ variable_z + variable_w, data = datos,
         method = "qda", prec = 400,
         image.colors = c("darkgoldenrod1", "skyblue2"),
         col.mean = "firebrick")

#______________________________________________________________
#KNN
#Ejemplo de un profesor

trabajo <- c(10,4,6,7,7,6,8,9,2,5,6,5,3,2,2,1,8,9,2,7)
examen <- c(9,5,6,7,8,7,6,9,1,5,7,6,2,1,5,5,9,10,4,6)
# Participaci�n en la clase, esta en una escala de 1 a 3 (1=m�ximo, 2=medio,3= m�nimo)
participacion <- c(1,2,1,1,1,2,2,1,3,3,3,2,3,3,2,2,1,1,3,3)

tabla <-data.frame(trabajo,examen,participacion)

plot(tabla[,1:2],main="Relaci�n entre trabajo en clase y examen 1",xlab="Trabajo en clase", ylab="Examen 1",col=tabla$participacion,pch=19)
legend("bottomright",legend=c("1","2","3"),pch=19,col=c(1,2,3))

#Nuevos Estudiantes
nuevos <- data.frame(trabajo=c(2,9),examen=c(3,8))
#Los agregamos
plot(tabla[,1:2],xlab="Trabajo en clase", ylab="Examen 1",col=tabla$participacion,pch=19)
legend("bottomright",legend=c("1","2","3"),pch=19,col=c(1,2,3))
points(nuevos,col="blue",pch=8,lwd=2)

#Modelo y predicci�n
library(class)
modelo <-knn(train = tabla[,-3], test=nuevos, cl = tabla$participacion, k=3)
modelo

#el primer nuevo alumno deber� ser clasificado con participaci�n 3,
#el segundo alumno deber� ser clasificado como participaci�n 1.



OTRO
otro <- data.frame(trabajo=c(6),examen=c(6))
modelo <-knn(train = tabla[,-3], test=otro, cl = tabla$participacion, k=4)
modelo
plot(tabla[,1:2],xlab="Trabajo en clase", ylab="Examen 1",col=tabla$participacion,pch=19)
legend("bottomright",legend=c("1","2","3"),pch=19,col=c(1,2,3))
points(otro,col="red",pch=8,lwd=2)