#Кромский Петр КМБО-03-22
#Практическая работа 2, вариант 14
library('lmtest')
library("GGally")
library("car")
data = swiss
help(swiss)

#проверим зависимость между переменными Catholic и Agriculture
model1 = lm(Catholic~Agriculture,data)
summary(model1)#коэффициент R маленький, значит линейной зависимости нет

#проверим зависимость между переменными Catholic и Education
model2 = lm(Catholic~Education,data)
summary(model2)#коэффициент R маленький, значит линейной зависимости нет

#проверим зависимость между переменными Agriculture и Education
model3 = lm(Agriculture~Education,data)
summary(model3)#коэффициент R средний, следовательно имеется линейная зависимость

#Зависимость Fertility от переменных Catholic, Education
model4 = lm(Fertility~Catholic+Education,data)
summary(model4)#R^2 = 0.56
vif(model4)

#Зависимость Fe от Ca и Ed 
model41 = lm(Fertility~Catholic+Agriculture,data)
summary(model41)#R^2 = 0.21, p is low
vif(model41)

#Зависимость Fertility от log(Catholic), Education
model5 = lm(Fertility~I(log(Catholic)) + Education,data)
summary(model5)#R^2 = 0.55, незначительное понижение (0.01), хуже чем у model4
vif(model5)

#Зависимость Fe от log(Ca) и Ag
model51 = lm(Fertility~I(log(Catholic)) + Agriculture,data)
summary(model51)#R^2 = 0.17
vif(model51)

#p is low, R^2 is low в дальнейшем откажемся от Agriculture в пользу Education (т.к Ag и Ed линейно зависимы)
model6 = lm(Fertility~Catholic+I(log(Education)),data)
summary(model6) #R^2=0.38, сильные потери
vif(model6)

#Зависимость Fe от Ca, Ed и log(Ag)
model7=lm(Fertility~Catholic+Eduction+I(log(Agriculture)),data)
summary(model7) #R^2=0.55,  p.Catholic 0 звезд
vif(model7)

#Зависимость Fe от log(Ed) и log(Ca)
model8=lm(Fertility~I(log(Education))+I(log(Catholic)),data)
summary(model8) #R^2=0.36 p.log(Catholic) 2 звезды
vif(model8)

#Не одна из моделей не превысила значений model4 => model4 лучшая

#
model9=lm(Fertility~Catholic+Education+I(Education^2),data)
summary(model9)
vif(model9)
#vif большой, Ed и Ed^2 лин. зависимы

#
model10=lm(Fertility~Catholic+I(Education^2),data)
summary(model10) #R^2=0.55 < model4R^2
vif(model10)

#model11 показывает себя незначительно лушче model4, однако превосходит ее во всем
model11=lm(Fertility~Education+I(Catholic^2),data)
summary(model11) #R^2=0.56 > model4R^2
vif(model11)

#model12 показывает себя незначительно хуже model4
model12=lm(Fertility~I(Education^2)+I(Catholic^2),data)
summary(model12) #R^2=0.56 > model4R^2
vif(model12)

# лучшие модели - (1)model11; (2)model4; (3)model12

summary(model11) #df = 47-3 = 44 degrees of freedom
t = pt(0.975, df=44)
t
#t = 0.8325548

print(74.5384779 - 2.2965289*0.8325548)
print(74.5384779 + 2.2965289*0.8325548)
#доверительный интервал свободного коэффициента [72.62649; 76.45046]
print(-0.7386581 - 0.1318106*0.8325548)
print(-0.7386581 + 0.1318106*0.8325548)
#доверительный интервал Education [-0.8483976; -0.6289186]
print(0.0010938 - 0.0002924*0.8325548)
print(0.0010938 + 0.0002924*0.8325548)
#доверительный интервал Catholic^2 [0.000850361; 0.001337239]

#Вывод о отвержении или невозможности отвергнуть статистическую гипотезу о том, что коэффициент равен 0

#Доверительный интервал свободного коэффициента [72.62649; 76.45046]
#0 не попадает в доверительный интервал => опровергаем гипотезу

#доверительный интервал Education [-0.8483976; -0.6289186]
#0 не попадает в доверительный интервал => опровергаем гипотезу

#доверительный интервал Catholic^2 [0.000850361; 0.001337239]
#0 не попадает в доверительный интервал => опровергаем гипотезу

new.data = data.frame(Fertility = 80.2, Education = 12, Catholic = 9.96)
predict(model11, new.data, interval = "confidence")
#Доверительный интервал для данного (одного) прогноза [62.69016; 68.87601]
