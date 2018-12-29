## SARIMA model test for Canadian Bankruptcy Data

setwd("/Users/Mahsa/Desktop/")

library(forecast)
library(tseries)

# creating workable versions of training and validation sets of data 
data <- read.csv("train.csv", header = TRUE)
test <- read.csv("test.csv",header = TRUE)
train <- ts(data = data$Bankruptcy_Rate[1:300], start= 1987, frequency = 12)
valid <- ts(data = data$Bankruptcy_Rate[301:336], start= 2012, frequency = 12)
data <- ts(data = data$Bankruptcy_Rate, start= 1987, frequency = 12)

# plotting values and log values from data 
par(mfrow = c(1,1))
plot(train,ylab="Bankrupcy Rate")

par(mfrow = c(2,1))
plot(log(train), main = "Log Transformed Canadian Bankruptcy Rates, 1987 to 2014", ylab = "log of bankruptcy rate")
acf(log(train))

# checking for non constant variance using Box Cox 
lambda <- BoxCox.lambda(train)
lambda
train.new <- BoxCox(train, lambda = 'auto')

# removing trend apparent in data
ndiffs(train.new)
adf.test(train.new)

# data differenced once according the ADF test suggestion
adf.test(diff(train.new))

# p.value improved and one difference of data has made the time series stationary

# looking at ACF and PACF of differenced data 
par(mfrow = c(2,1))
acf(diff(train.new), main = 'Ordinarily-Differenced Data', lag.max = 96)
pacf(diff(train.new), main = '', lag.max = 96)

# checking for seasonal effect; nsdiffs indicate that there is no seasonality in data so D = 0 for our SARIMA
train.wotrend <- diff(train.new)
nsdiffs(train.wotrend)


# choosing appropriate model based on spikes in plots, iterating towards the best
# m = 12, D = 0, d = 1, p = 4 or 5, q = 0 or 1, P = 1 or 2, Q = 1 
m1 <- arima(train.new, order=c(5,1,0), seasonal = list(order = c(2,0,1), period = 12), method = "ML")
summary(m1)

m2 <- arima(train.new, order=c(4,1,0), seasonal = list(order = c(1,0,1), period = 12), method = "ML")
summary(m2)

m3 <- arima(train.new, order=c(4,1,1), seasonal = list(order = c(1,0,1), period = 12), method = "ML")
summary(m3)

m4 <- arima(train.new, order=c(4,1,0), seasonal = list(order = c(2,0,1), period = 12), method = "ML")
summary(m4)

m1_valid <- forecast(m1, h = 36,level=95)
m2_valid <- forecast(m2, h = 36,level=95)
m3_valid <- forecast(m3, h = 36,level=95)
m4_valid <- forecast(m4, h = 36,level=95)

# Using InvBoxCox for RMSE values of validations of each model

sqrt(mean((InvBoxCox(m1_valid$mean,lambda)-valid)^2))

sqrt(mean((InvBoxCox(m2_valid$mean,lambda)-valid)^2))

sqrt(mean((InvBoxCox(m3_valid$mean,lambda)-valid)^2))

sqrt(mean((InvBoxCox(m4_valid$mean,lambda)-valid)^2))

# smallest value for RMSE is for m1, with 0.255362

# rebuilding the forecast on the original training data set

data.new <- BoxCox(data, lambda = lambda)
m1.new <- arima(x = data.new, order = c(5, 1, 0), seasonal = list(order = c(2, 0, 1), period = 12), method = "ML")

m1.fitted<- InvBoxCox(fitted(m1.new),lambda)

# generating forecasts to be plotted of full training set 
m1_test <- forecast(m1.new, h = 36, level = 95)
m1_test.mean <- InvBoxCox(m1_test$mean,lambda)
m1_test.lower <- InvBoxCox(m1_test$lower,lambda)
m1_test.upper <- InvBoxCox(m1_test$upper,lambda)

# plotting forecasts with bankruptcy rate data
par(mfrow=c(1,1))
plot(data, main = "Forecasts for Canadian Bankruptcy Rates",ylab="Bankrupcy Rate",xlim=c(1987,2018))
lines(m1_test.mean,type='l',col='green')
lines(m1_test.lower,type='l',col='navy')
lines(m1_test.upper,type='l',col='navy')
lines(m1.fitted,type='l',col='red')
legend("topleft", legend = c("Observed", "Predicted", "Prediction Interval","Fitted"), lty = 1, col =  c("black", "green", "navy", "red"), cex = 0.4)

# Residual Assumptions tests
par(mfrow=c(3,1))
plot(m1$residuals, main = "Residuals vs. Time", ylab = "Residuals")
abline(h = 0, col = "red")
acf(m1$residuals, main = "ACF of Residuals")
qqnorm(m1$residuals)
qqline(m1$residuals, col = "red")


# Values for predictions
m1_test.mean
