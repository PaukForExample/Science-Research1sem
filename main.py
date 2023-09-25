import pandas
import  numpy as np
from sklearn.tree import DecisionTreeClassifier

#Обработаем набор данных
data=pandas.read_csv("StudentsPerformance.csv")

#Выбор основных признаков
data=data.loc[:,data.columns.isin(['gender', 'lunch', 'test preparation course', 'reading score', 'writing score', 'math score'])]
data_se1=data.dropna()
data_se1['gender']=np.where(data_se1['gender']=='male',0,1)
data_se1['lunch'] = np.where(data_se1['lunch'] == 'standard', 0, 1)

#Поиск среднего значения reading score и определение два класса: выше среднего(0), ниже или равно(1)
mean_reading_score = data_se1['reading score'].mean()
data_se1['reading score'] = np.where(data_se1['reading score'] > mean_reading_score, 0, 1 )
data_se1
#Аналогично для writing score и maths score
mean_writing_score = data_se1['writing score'].mean()
data_se1['writing score'] = np.where(data_se1['writing score'] > mean_writing_score, 0, 1 )
data_se1
mean_math_score = data_se1['math score'].mean()
data_se1['math score']=np.where(data_se1['math score']>mean_math_score,0,1)
data_se1

#Выбор целевого признака
data_se1['test preparation course']=np.where(data_se1['test preparation course']=='none',0,1)
TestPr=data_se1.loc[:,data_se1.columns.isin(['test preparation course'])]
X=data_se1.loc[:,data_se1.columns.isin(['gender','lunch','reading score', 'writing score', 'math score'])]
X

from sklearn.model_selection import train_test_split
x_train, x_val, y_train, y_val=train_test_split(X,TestPr,test_size=0.4,random_state=153)

#Построенте дерева
tree=DecisionTreeClassifier(random_state=165)
tree=tree.fit(x_train,y_train)
X

from sklearn.metrics import*

validation_acc1 = accuracy_score(y_val, tree.predict(x_val))
#print('Точность валидации:', validation_acc1)

#Оценка точности построенного классификатора с помощью метрик precision, recall и f1
precision = precision_score(y_val, tree.predict(x_val))
recall = recall_score(y_val, tree.predict(x_val))
f1 = f1_score(y_val, tree.predict(x_val))
#print(f'значение precision: {precision}', f'значение recall: {recall}', f'значение f1 меры: {f1}', sep ='\n')

#Точность валидации = 0.685
#precision = 0.5666666666666667
#recall = 0.13076923076923078
#f1 = 0.21250000000000002

tree.feature_importances_

#Построение классификатора случайный лес
from sklearn.ensemble import RandomForestClassifier
forest=RandomForestClassifier()
#Обучение
forest=forest.fit(x_train,y_train.values.ravel())
#Оценим его качество с помощью метрик
accuracy2 = accuracy_score(y_val, forest.predict(x_val))
precision2 = precision_score(y_val, forest.predict(x_val))
recall2 = recall_score(y_val, forest.predict(x_val))
f1_2 = f1_score(y_val, forest.predict(x_val))
#print(f'точность валидации: {accuracy2}', f'значение precision: {precision2}', f'значение recall: {recall2}', f'значение f1 меры: {f1_2}', sep ='\n')

#Точность валидации = 0.6875
#precision = 0.5714285714285714
#recall = 0.15384615384615385
#f1 = 0.24242424242424246

#Метрики совпадают

#Подбор различных комбинаций гиперпараметров с помощью GridSearch
from sklearn.model_selection import GridSearchCV

params = {'n_estimators':[i for i in range(50, 500, 10)],
          'criterion':['gini', 'entropy'],
          'min_samples_leaf': [1, 2, 3, 4],
          'max_features':['sqrt', 'log2']}

clf = GridSearchCV(forest, params, cv = 3 )
clf.fit(x_train, y_train.values.ravel())
best_params = clf.best_params_
best_forest = clf.best_estimator_
#лучшие параметры случайного леса: 'n_estimators' = 50 , 'critetion' = 'gini', 'max_features' = log2', 'min_samples_leaf' = 4
best_params

accuracy = accuracy_score(y_val, best_forest.predict(x_val))
precision = precision_score(y_val, best_forest.predict(x_val))
recall = recall_score(y_val, best_forest.predict(x_val))
f1 = f1_score(y_val, best_forest.predict(x_val))
print(f'точность валидации: {accuracy}', f'значение precision: {precision}', f'значение recall: {recall}', f'значение f1 меры: {f1}', sep ='\n')
#метрики recall и f1 повысились, поэтому можно сделать вывод, что случайный лес сработал лучше решающего дерева

#Построение случайного леса с наилучшими характеристиками
from sklearn.model_selection import GridSearchCV
params = {'n_estimators':[i for i in range(50, 500, 10)],
          'criterion':['gini', 'entropy'],
          'min_samples_leaf': [1, 2, 3, 4],
          'max_features':['sqrt', 'log2']}

clf = GridSearchCV(forest, params, cv = 3 )
clf.fit(x_train, y_train.values.ravel())
best_params = clf.best_params_
best_forest = clf.best_estimator_
print(best_params)

accuracy = accuracy_score(y_val, best_forest.predict(x_val))
precision = precision_score(y_val, best_forest.predict(x_val))
recall = recall_score(y_val, best_forest.predict(x_val))
f1 = f1_score(y_val, best_forest.predict(x_val))
print(f'точность валидации: {accuracy}', f'значение precision: {precision}', f'значение recall: {recall}', f'значение f1 меры: {f1}', sep ='\n')