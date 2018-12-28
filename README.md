# Time Series Project for Canadian BankruptcyRate Prediction

Team members: Tian Qi, Jessica W, Divya Bhargavi, Mahsa Ashabi


# Overview

The goal of this class project is to use an appropriate time series modeling approach to predict Canadian monthly bankruptcy rates. With a collection of monthly bankruptcy rates data from January 1987 to December 2014, we aim to predict the bankruptcy rates for the following 36-month period. There are also corresponding data on unemployment rates, population rates, and Housing Price Index that could be used to predict forecast bankruptcy rates. Because of this, we used both univariate (SARIMA, SMOOTHING) and multivariate time series model (SARIMAX, VAR). 

Our approach includes a basic EDA to visualize the series explore the underlying relationships between them. The validation data is the subset data from 2011 to 2014, we used the validation data to tune parameters for each model. Then we refit the model on whole data we have, make the prediction for next 3 years (2015-2017) and compare it with the true value. We used RMSE as the loss function.

# Result

The whole training time of four models is less than 3 mins. Our final model is the emsemble of four models, which is the average of their predictions, this gives RMSE 0.19 on test data, and we rank top **3** among 22 teams in the class competition. The top 1 solution used ensemble of **10** models of type SARIMA, SARIMAX, VAR and VARX, which I think is not really useful in real life/industry.
