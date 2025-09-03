#DATASET MAMMALS en LIBRERIA MASS
library(MASS)
data(mammals)
dim(mammals)
#Gráficos generales
plot(mammals$body, mammals$brain)

#reduzco la distribucion de valores con log()
#aux va a reemplazar a "mammals"
aux <- log(mammals)
boxplot(aux)
#a) exploracion de datos
summary(aux)

#b) verificar si los supuestos se cumplen, y verificar correlación
shapiro.test(aux$body)
shapiro.test(aux$brain)
#tienen distribución normal
#verifico homocedasticidad
var.test(aux$body, aux$brain)
cor.test(aux$body, aux$brain, method = "pearson")
qqnorm(aux$body)
qqline(aux$body)
#
qqnorm(aux$brain)
qqline(aux$brain)
