#Практическая работа №1, вариант 14 КМБО-03-22 Кромский Петр
library ('lmtest')

data=swiss
#оценим среднее значение переменных Education, Agriculture и Catholic
mean(data$Education) #среднее значение Education равно 10.98
mean(data$Agriculture) #среднее значение Agriculture 50.66
mean(data$Catholic) #среднее значение Catholic равно 41.14

#оценим дисперсию
var(data$Education) #дисперсия Education равна 92.46
var(data$Agriculture) #дисперсия Agriculture 515.80
var(data$Catholic) # дисперсия Catholic равна 1739.30

#оценим СКО (среднее квадратическое отклоение)
sd(data$Education) #СКО Education равно 9.62
sd(data$Agriculture) #СКО Agriculture равно 22.71
sd(data$Catholic) #СКО Catholic равно 41.71

model1 = lm(Education~Agriculture,data)
summary(model1)
#Ed = -0.27Ag + 24.7, коэффициент детерминации средний, отрицательная линейная зависимость есть
# R^2=0.40

model2 = lm(Education~Catholic,data)
summary(model2)
#Ed = -0.04*Ca + 12.44, коэффициент детерминации очень маленький, нет зависимости между переменными
#R^2=0.30
