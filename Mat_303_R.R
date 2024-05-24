install.packages("ResourceSelection")
install.packages("pRoC")
install.packages("rpart.plot")
print("Installation complete")

#load csv
heart_data <- read.csv(file="heart_disease.csv", headerTRUE, sep=",")

#convert variables to factors

heart_data <-within(heart_data, {
    target <- factor(targer)
    sex <- factor(sex)
    cp <- factor(fbs)
    restecg <-factor(restecg)
    exang <-factor(exang)
    slope <-factor(ca)
    thal <-Factor(thal)
})

head(heart_data,10)

print("number of Variables")
ncol(heart_data)

print("Number of Rows")
nrow(heart_data)

#complete model

logit <- glm(target ~ age + trestbps + exang + thalach, data = heart_data,family = "binomial")

summary (logit)

libary(ResourceSelection)
Print("Hosmer-Lemeshow Goodness to Fit Test")
hl = hoslem.test(logist$y, fitted(logit), g=50)
hl

conf_int <- confint.default(logit, level=0.95)
round(conf_int,4)

#Make predictions on test data
pred <- predict(logit, newdata=heart_data, type='response')

#conver probability to class prediction - 1 or 0
pred_class <- ifelse(pred > 0.5, 1, 0)

#construct confusion matrix
conf.matrix <- table(heart_data$target, pred_class)
rownames(conf.matrix) <- paste("Actual", rownames(conf.matrix), sep= ":default=")
colnmames(conf.matrix) <-paste("Prediction", colnames(conf.matrix), sep =":default=")

#print conf matrix
print("Confusion Matrix")
format(conf.matrix, justify="centre", digit=2)

library(pRoC)

labels <- heart_data$target
prediction <-logit$fitted.values

roc <- roc(labels~ predictions)

print("Area Under the Curve (AUC)")
round(auc(roc),4)

princt("ROC Curve")

plot(roc, legacy.axes =TRUE)

print("Prediction: age is 50, resting blood pressure is 122, has excercise-induced angina, maximum heart rate achieved is 140")
newdata1 <-data.frame(age=50, trestbps=122, exang="1", thalach=140)
pred1 <-predict(logit, newdata1, type='response')
round (pred1, 4)

print("Prediction: age is 50, resting blood pressure is 130, has exercise-induced angina, maximum heart rate is 165")
newdata2 <-data.frame(age=50, trestbps=130, exang="0", thalach=165)
pred2 <- predict(logit, newdata2, type = 'response')
round(pred2,4)
