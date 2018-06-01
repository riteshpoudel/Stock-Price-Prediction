rm(list=ls(all=TRUE))

library(plyr)
library(dplyr)
library(zoo)
library (DMwR)

##############################################################################################
########Please put FB_latest.csv, RiskandReturn.csv in a different directory#################
######And rest of the historical quotes data into a different directory######################
####### It is already stored in optimization directory#######################################
##############################################################################################


setwd("C:/Users/rites/Downloads/stock_prices")

##Function for pre-processing of data
CAGR <- function(x){
  
  ##flipping data to suit time series analysis
my.data <- x[nrow(x):1,]
  
  ## setting up date as date format
my.data$date <- as.Date(my.data$date)
  
  ##creating a new data frame to sort the data.
sorted.data <- my.data[order(my.data$date),]
  
  #removing the last row as it contains stocks price at moment when i downloaded data
  #sorted.data <- sorted.data[-nrow(sorted.data),]
  #calculating lenght of the data frame
data.length <- length(sorted.data$date)
  
  ## extracting the first date
time.min <- sorted.data$date[1]
  ##extracting the last date
time.max <- sorted.data$date[data.length]
  
  # creating a new data frame with all the dates in sequence
all.dates <- seq(time.min, time.max, by="day")
all.dates.frame <- data.frame(list(date=all.dates))
  
  #Merging all dates data frame and sorted data frame; all the empty cells are assigned NA vales
merged.data <- merge(all.dates.frame, sorted.data, all=T)
  
  ##Replacing all NA values with the values of the rows of previous day
final.data <- transform(merged.data, close = na.locf(close), open = na.locf(open), volume = na.locf(volume), high = na.locf(high), low =na.locf(low))

  ################################################################
  ######calculation of  CAGR(Compound Annual Growth Rate ) #######
  #### {((latest price/Oldest price)^1/#ofyears) - 1}*100 ########
  ################################################################
 
  ##Extracting closing price of the oldest date
old_closing_price <- final.data$close[1]
  
  ##extracting the closing price of the latest date
new_closing_price <- final.data$close[length(final.data$close)]
  
  ##extracting the starting year
start_date <- final.data$date[1]
start_year <- as.numeric(format(start_date, "%Y"))
  
  ##extracting the latest date
end_date <- final.data$date[length(final.data$date)]
end_year <- as.numeric(format(end_date, "%Y"))
  
CAGR_1 <- new_closing_price/old_closing_price
root <- 1/(end_year-start_year)

#Applying CARG formula
CAGR <- (((CAGR_1)^(root))-1)*100
  
return(CAGR)
}

##Reading all the files dropped in the working directory, applying preprocess function and calculate CAGR###
df<-data.frame()
temp = list.files(pattern="*.csv")
for(i in 1:length(temp)){
preproc <- CAGR(read.csv(temp[i]))
df<-rbind(df,data.frame(company = paste0(temp[i]),CAGR = preproc))
}

#Finding out top 5 performing companies
Top_performing <-df[order(df$CAGR,decreasing=T)[1:5],]

#Removing redundant enviroment variables
rm(i,temp)

#Preprocessing for next week forcasting for the top 5 performing compnies

preprocess <- function (y){
  
  
  ##flipping data to suit time series analysis
my.data <- y[nrow(y):1,]
  
my.data = select(my.data, -3:-6)
  
  ## setting up date as date format
my.data$date <- as.Date(my.data$date)
  
  ##creating a new data frame to sort the data.
sorted.data <- my.data[order(my.data$date),]
  
  #removing the last row as it contains stocks price at moment when i downloaded data
  #sorted.data <- sorted.data[-nrow(sorted.data),]
  #calculating lenght of the data frame
data.length <- length(sorted.data$date)
  
  ## extracting the first date
time.min <- sorted.data$date[1]
  ##extracting the last date
time.max <- sorted.data$date[data.length]
  
  # creating a new data frame with all the dates in sequence
all.dates <- seq(time.min, time.max, by="day")
all.dates.frame <- data.frame(list(date=all.dates))
  
  #Merging all dates data frame and sorted data frame; all the empty cells are assigned NA vales
merged.data <- merge(all.dates.frame, sorted.data, all=T)
  
  ##Replacing all NA values with the values of the rows of previous day
final.data <- transform(merged.data, close = na.locf(close))
return(final.data)
}
  
  
temp<-list()
temp<- as.vector.factor(Top_performing$company)

#Reading top 5 performing stocks as dataframe to do a time series forcasting
for (i in 1:length(temp)) {
assign(temp[i], preprocess(read.csv(temp[i])))
}

#removing unused enviroment variable
rm (df)
facebook <- facebook.csv




#Loading libraries for Time series forcasting
library("forecast")
library("stats")
library(TTR)
library (tseries)

facebook <- facebook.csv$close
fb_timeseries<- ts(facebook, frequency = 365)

#par(mfrow=c(1,1))
plot(fb_timeseries)

is.ts(fb_timeseries)

#ACF and PACF of real world data

#par(mfrow=c(1,1))
plot.ts(fb_timeseries)
acf(fb_timeseries)
pacf(fb_timeseries)


#Decomposition to trend seasonality and randomness component
fb_timeseriescomponents <- 
  decompose(fb_timeseries, type= "additive")

plot(fb_timeseriescomponents)
fb_timeseriescomponents$seasonal
fb_timeseriescomponents$trend
fb_timeseriescomponents$figure


#acf(fb_timeseries, lag.max=11, ci.type="ma")

# Differencing and ACF, PACF on
# Stationary and Non-Stationary Data

ndiffs(fb_timeseries)
nsdiffs(fb_timeseries)


#par(mfrow=c(1,1))
acf(fb_timeseries)
pacf(fb_timeseries)

fb_timeseriesdiff1 <- diff(fb_timeseries, differences=1)
fb_timeseriesdiff1

#ACF and PACF for Diff data
acf(as.numeric(fb_timeseriesdiff1))
pacf(as.numeric(fb_timeseriesdiff1))






#Holts HoltWinters

fb_HW1 <- HoltWinters(fb_timeseries)
fb_HW1
fb_HW1$fitted

#par(mfrow=c(1,1))
plot(fb_HW1)
fb_HW1$SSE
fb_residualsHW1 <- residuals(fb_HW1)
fb_residualsHW1
plot(fb_residualsHW1)
par(mfrow = c(1,1))
acf(fb_residualsHW1)
pacf(fb_residualsHW1)



#it predicts seasonal peaks well
fb_forecastHW1 <- 
  forecast.HoltWinters(fb_HW1, 
                       h=7)

summary (fb_forecastHW1)

#forecasting using Holts Winter model
par(mfrow = c(1, 1))
plot.forecast(fb_forecastHW1,
              shadecols="oldstyle")


#################################################################

#Forcasting using AUTO ARIMA
facebookAutoArima <- auto.arima(fb_timeseries,ic='aic')
facebookAutoArima
facebooktimeseriesforecastsAutoArima <- forecast.Arima(facebookAutoArima, 
                                                       h=7)
plot.forecast(facebooktimeseriesforecastsAutoArima)

summary (facebooktimeseriesforecastsAutoArima)

#########################################################
####ARIMA####################
#ARIMA
# Step 1: Plot timeseries (in terms of ARIMA, it is an ARIMA(0,0,0))
facebook_ARIMA <- ts(facebook, frequency = 365) 
facebook_ARIMA
par(mfrow = c(1, 1))
plot(facebook_ARIMA)

# Step 2: Plot ACF and PACF to get preliminary understanding of the process
par(mfrow = c(1, 2))
acf(facebook_ARIMA)
pacf(facebook_ARIMA)

# Differencing to make Stationary
par(mfrow = c(1, 1))
facebook_ARIMAdiff1 <- diff(facebook_ARIMA, differences = 1)
facebook_ARIMAdiff1
plot(facebook_ARIMAdiff1)

# Checking ACF and PACF to explore remaining dependencies
par(mfrow = c(1, 2))
acf(facebook_ARIMAdiff1)
pacf(facebook_ARIMAdiff1)

#Building ARIMA model
facebook_Arima1 <- Arima(facebook_ARIMA, order = c(0,1,0), seasonal = c(0,1,0), include.drift = FALSE)
facebook_Arima1

# Checking residuals to ensure they are white noise
par(mfrow = c(1, 2))
acf(facebook_Arima1$residuals, lag.max = 24)
pacf(facebook_Arima1$residuals, lag.max = 24)
Box.test(facebook_Arima1$residuals, lag=24, type="Ljung-Box")

# Forecasting using above ARIMA model
par(mfrow = c(1, 1))
facebook_ARIMAforecastsArima1 <- forecast.Arima(facebook_Arima1, 
                                                 h=7)
plot.forecast(facebook_ARIMAforecastsArima1)
facebook_ARIMAforecastsArima1


########################Accuracy of prediction#####################



setwd("C:/Users/rites/Downloads/stock_prices/optimization")


test_data<-read.csv("FB_latest.csv")
test_data$close <- as.vector(test_data$close)


##Calculation of MAPE for Holtswinter model
regr.eval(trues = test_data$close, preds = fb_forecastHW1$mean)

##Calculation of MAPE for Autoarima model
regr.eval(trues = test_data$close, preds= facebooktimeseriesforecastsAutoArima$mean)

##calculation of MAPE for ARIMA model
regr.eval(trues = test_data$close, preds= facebook_ARIMAforecastsArima1$mean)
################################################################################

##Optimization of portfolio###
library(lpSolve)

#Assumption : All stocks have equal risk factor
#Stock selection

#vector of yields or return for the stocks calculated annually

#setwd("C:/Users/rites/Downloads/stock_prices/optimization")
#ReturnOnInvestment <- read.csv("RiskandReturn.csv")

#ReturnOnInvestment$Projected.returns <- as.data.frame.vector(ReturnOnInvestment$Projected.returns)

#obj = c(ReturnOnInvestment[1,2],ReturnOnInvestment[2,2],ReturnOnInvestment[3,2], ReturnOnInvestment[4,2], ReturnOnInvestment[5,2])

obj=c(0.0406, 0.0674, 0.1234, 0.0173, 0.0197)


con=rbind(c(1,0,0,0,0), 
          c(0,1,0,0,0), 
          c(0,0,1,0,0), 
          c(0,0,0,1,0), 
          c(0,0,0,0,1), 
          c(1,1,1,1,1),
          c(1,0,0,0,0), 
          c(0,1,0,0,0), 
          c(0,0,1,0,0), 
          c(0,0,0,1,0), 
          c(0,0,0,0,1))
#____________________________________________________________________________________________________________#

dir=c("<=", "<=", "<=", 
      "<=", "<=", 
      "==", ">=", ">=", ">=", 
      ">=", ">=")
#7th directionality denotes equal to the money available

rhs=c(40000, 40000, 40000, 
      40000, 40000, 
      100000, 5000, 5000, 5000, 5000, 5000)



##Applying LP function#####

res1=lp("max", obj, con, 
        dir, rhs, 
        compute.sens=1)

res1$solution

#Analyzing the results

res1$sens.coef.from

res1$sens.coef.to

vectorofresults <- c(res1$solution)
vectorofresults


Total_returns <- (0.0406*10000)+(0.0674*40000)+(0.1234*40000)+(0.0173*5000)+(0.0197*5000)
Total_returns
##A return of 8.22% on investment is expected based on this optimization model Based on projected returns##





