peso <- c(74,92,63,72,58,76,85,78,67,91,85,73,62,80,72)
altura <- c(168,196,170,175,162,183,169,190,172,188,186,176,170,176,179)

#Importante: visualizo los datos graficandolos
plot(altura~peso, pch = 1, col = "red")
#mismo gráfico
plot(altura, peso, col = "blue")

#Los datos tienen districución normal?
#H0, mi hipotesis nula es que tienen distri normal
shapiro.test(altura)
#acepto H0
shapiro.test(peso)
#acepto H0

# Ahora grafico con qqnorm() y agrego qqline() para ver la recta
qqnorm(altura)
qqline(altura)

#mientras mas cerca estén los datos de la recta, mas normal es la distribución
qqnorm(peso)
qqline(peso)

#Verifico la homocedasticidad
var.test(peso, altura)

#Verifico si exisite correlación entren las dos variables
cor.test(peso,altura)
