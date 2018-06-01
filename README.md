# Stock-Price-Prediction

 
Autoregressive integrated moving average (ARIMA)

As the name suggest, it is an integration of AR and MA models to perform time series forecasting. The target variable, or the value to be predicted is regressed over its own lag. The MA indicates that regression error is a linear combination of the values in the past and the same time in present. ARIMA models which are non-seasonal, are represented as ARIMA(p,d,q). p, d and q are the parameters and are always nonnegative. Where p is the order of the autoregressive model, d is the degree of differencing and q is the order of moving average model. For seasonal, ARIMA, we represent it as ARIMA (p,d,q) (P,D,Q). Where capital P, Q, D represent the seasonal autoregressive, differencing and moving average terms. So, if put two values as 0, we are dropping the auto regression, or difference or the moving average part of ARIMA. This section provides the understanding about the proposed working model for accurate stock market price forecasting. Therefore the detailed system implementation is described in this chapter with the implementable algorithm steps.    

Holt-Winters method
The Holt-Winters method (HW), named after its inventors, is a continuation of Holt’s model for a time series with a linear trend that also takes into account seasonal patterns, and was proposed by Holt’s student, Peter Winters in 1960 [source: Wikipedia]. In this method, at every time step estimates for the level, trend and seasonality components are revised, which also justiﬁes the name of triple exponential smoothing. There are two diﬀerent versions of the Holt-Winters method, for the two diﬀerent forms of seasonality patterns that deﬁne the model: the additive and the multiplicative form. In its additive form, which we present ﬁrst, the change of the seasonal ﬂuctuation between two successive seasonal factors diﬀer by a constant number, while in its multiplicative form this change is a percentage and thus for greater values the change of the successive cycle will be greater.


The process of Time Series Modelling

 
The Time Series modelling is generally used when historical data plays an important role in predictive future prices. The process is shown in this diagram.
  
 
 
Determine Trend

 Trend is increase or decrease over a period of time. This can be caused due to systematic persistent, upward or downward pattern. Example which cause this are population increase, technology adaption etc.
Visually shown here is a time series without trend and time series with trend

 

Determine Seasonality

 Seasonality means that a fluctuation occurs over certain months or periods each year. Visually shown here is a time series without Seasonality and time series with Seasonality. As you can see that in time series with Seasonality, there is increase in value observed in months 7 and 8
 
Box plots are very useful to visualize seasonality
 
 
 

Determine Auto-correlation

Auto-correlation means how a point in time-series impacts future values in time-series.
This can be determined using a PACF (Partial Auto-correlation) plot
 


Time-Series Modelling

Time-series modelling tries to fit a model to existing data, so that it can be used to forecast future values. One of the most commonly used algorithms for time series modelling is ARIMA (autoregressive integrated moving average)
 
This algorithm first converts the data into, what we call it a stationary time-series, by removing the trend and seasonality. Then it tries to fit a model on the stationary data
 
The analysis done about trend, seasonality and auto-correlation earlier in the process serve as input parameters for ARIMA
 
 
 
Forecasting
Once the model is fitted, it can be used to predict the future values













DATA
For this project data downloaded were historical quotes for 20 different companies across industries. Industries varies from entertainment Walt Disney to arms and ammunition manufacturer Raytheon, from aircraft manufacturer Boeing to health care United Health Corporation to social media platform Facebook. Data has historical quotes from May 2013 to May 2017, 4 years’ worth of data. Historical quotes downloaded had Trading date, Daily closing price, opening price, highest and lowest prices in a day and volume of stocks. All the datasets were in csv format.

Challenges in the Dataset
Stock markets are closed on weekends and public holidays and hence, data entries for those will missing in the original dataset which leaves the data unusable for any kind of time-series modelling. It is of utmost importance for data to be consistent for time-series analysis. Any missing values in the time-series data would give very bad results due to discontinuity in the series. To overcome this issue we had to identify those dates for which data was not present and had to come out with a way to fill the values of all the attributes of previous trading day to those missing days. The original dataset was also in descending order which cannot be used for time series analysis. Hence, we fix the data and make it suitable for time series analysis, we need to perform the below pre-processing steps

Pre-processing of data

As time series requires data to be in ascending order of dates, we sorted the original data in ascending order. To fix the missing values issue, we created an empty data frame with a sequence of dates from 19th May 2013 to 19th May 2017 and used “merge and transform function” to merge it with the original dataset. Doing so, all missing dates have been included in the new merged data set with NA values in the attributes. 
Usually the closing price of the previous day is very close the opening price of the next day. Hence, we can use the previous day’s attributes for the newly included dates which has NA values. To achieve this we used “ZOO” package and imputed all the N/A values with the previous days.






Calculation of top performing companies based on CAGR

CAGR- Cumulative Annual Growth Rate

Compound annual growth rate (CAGR) is frequently used in business presentations and reports to show how a particular part of the business has grown over time. CAGR takes growth rates from multiple periods and translates them into a consistent growth rate which represents the same growth.
CAGR can be useful to compare the performance of two different businesses or investments where volatility of their returns makes it difficult to grasp which one performed better.
BREAKING DOWN 'Compound Annual Growth Rate - CAGR'
The compound annual growth rate isn't a true return rate, but rather a representational figure. It is essentially an imaginary number that describes the rate at which an investment would have grown if it had grown at a steady rate, which virtually never happens in reality. You can think of CAGR as a way to smooth out an investment’s returns so that they may be more easily understood.
Formula to calculate CAGR

To calculate  compound annual growth rate, divide the value of an investment at the end of the period in question by its value at the beginning of that period, raise the result to the power of one divided by the period length, and subtract one from the subsequent result.
This can be written as follows:
 
Where ending value is latest closing price in our case, beginning value is the oldest closing price and the # of years is the period over which we are calculating CAGR.



Based on the CAGR calculated we got our top five performing companies which are as follows.
Company	CAGR
Facebook	54.83
Netflix	46.35
Amazon	37.61
Tesla	36.34
United Health Corporation	28.87


The top performing company based on CAGR values is Facebook with  a CAGR score of 54.83.
Facebook was trading at around 25$ a stock in 2013 and in 2017 May it was at 150$ a stocks, which means it has done really good in last four years which why the CAGR score is substantially high.
Time series analysis of Facebook data

Creating a time series object and plotting a time series graph with the original data.

 


ACF and PACF of Original data


 

ACF plot of the original data shows there is a definitive trend in the data and with each lag we have a pattern of decay.


 
PACF of original shows significant spike at 1st Lag. Differencing the data once would remove the gross seasonality from the data.

Decomposition of Time series data

 


Trend give us the direction in which the stock prices are growing.

Seasonality gives us a repeating pattern of stock prices over a certain period of time.

Randomness is the error / random behaviour of the stock prices over that period of time
Holt-Winters

The Holt-Winters model is quite similar to ARIMA, in that both attempt to forecast future values of a time series based on past data and both seek to identify seasonality in forecasting such trends. However, the models themselves can produce different specifications and forecasts, and it is ultimately beneficial to run both tests to validate the forecasts.
 
We conduct the Holt-Winters exponential smoothing with a trend and additive seasonal component and do a forecast as follows-



 
Output of Holt Winters forecasting
 

Holt Winters Fitted graph

 

We note in the above output that we have high values for both alpha and gamma, suggesting that higher weights are being assigned to the most recent observations in the forecast. 

ARIMA (Autoregressive Integrated Moving Average)


ACF and PACF after 1st Differencing

 
 

As the PACF plot of the original data had significant spike at 1st Lag, we are differencing the original data by 1 and plotting ACF and PACF graph.

We can see that there is a significant spike at the zeroth lag in ACF plot after 1st differencing.

No significant spike on PACF plot after 1st differencing. This means the time series is now stationary.

Code for ARIMA:
 
Ljung-Box Test
While we could potentially use this model to forecast future values for price, an important test used to validate the findings of the ARIMA model is the Ljung-Box test. Essentially, the test is being used to determine if the residuals of our time series follow a random pattern, or if there is a significant degree of non-randomness.
H0: Residuals follow a random pattern
HA: Residuals do not follow a random pattern

 
From the above, we see that we have an insignificant p-value. This means that there is likely a high degree of randomness exhibited by our residuals (consistent with a random walk with drift model) and therefore our ARIMA model is free of autocorrelation.

 

Forecasting using Auto ARIMA
Code for Auto Arima

 
 

Results
Accuracy of Forecast

 

Forecast using Holt-Winters model for next 7 days with respect to the actual closing price gives a MAPE value of 0.0062.

Forecast using ARIMA model for next 7 days with respect to the actual closing price gives a MAPE values of 0.0065 with P,D,Q values of (1,1,0)

Forecast using AUTO- ARIMA model for next 7 days with respect to the actual closing price gives a MAPE values of 0.0088 with P,D,Q values of (0,1,0) with drift. 










Optimization of Portfolio Using Linear Programming

Introduction of Linear Programming
Linear programming (LP) (also called linear optimization) is a method to achieve the best outcome (such as maximum profit or lowest cost) in a mathematical model whose requirements are represented by linear relationships. Linear programming is a special case of mathematical programming (mathematical optimization).
More formally, linear programming is a technique for the optimization of a linear objective function, subject to linear equality and linear inequality constraints. Its feasible region is a convex polytope, which is a set defined as the intersection of finitely many half spaces, each of which is defined by a linear inequality. Its objective function is a real-valued affine (linear) function defined on this polyhedron. A linear programming algorithm finds a point in the polyhedron where this function has the smallest (or largest) value if such a point exists.
Linear programs are problems that can be expressed in canonical form as
   
where x represents the vector of variables (to be determined), c and b are vectors of (known) coefficients, A is a (known) matrix of coefficients, and  is the matrix transpose. The expression to be maximized or minimized is called the objective function (cTx in this case). The inequalities Ax ≤ b and x ≥ 0 are the constraints which specify a convex polytope over which the objective function is to be optimized. In this context, two vectors are comparable when they have the same dimensions. If every entry in the first is less-than or equal-to the corresponding entry in the second then we can say the first vector is less-than or equal-to the second vector.
Linear programming can be applied to various fields of study. It is widely used in business and economics, and is also utilized for some engineering problems. Industries that use linear programming models include transportation, energy, telecommunications, and manufacturing. It has proved useful in modelling diverse types of problems in planning, routing, scheduling, assignment, and design.

Methods Used in this project

Calculated average rate of return for a month for the top 5 performing stocks.
The objective function is based on the average rate of return to calculate the optimized amount to be invested in each of the top 5 performing stocks

Company 	Projected Return rate %
Facebook	4.06
Amazon	6.74
Netflix	12.34
Tesla	1.73
United Health	1.97

R Code for Optimization
 

Constraints
We have considered below constraints to optimize the portfolio to give maximum returns-

1)	Not more than 40% of the total amount can be allocated to each of the stocks.

2)	At least 5% of the total amount should be invested on each of the stocks.


3)	We have 100,000$ to invest on these 5 stocks.


Results


 

Based on the objective function, if we invest 100,000$ as above we get a return of about 8.2% over a period of month.


 


Results in R
 









Conclusion

Forecasting of stock prices are not only inaccurate but also full of risk as it does not capture the human emotion which makes it difficult to predict the stock prices. The ups-and down of a stock markets are dependent on so many different factors which has not been considered here while forecasting and optimizing the portfolio. Also the Risk factor has been considered uniform while optimizing portfolio.
The forecast from Holt-Winters technique has given the best results with MAPE values 0.0062 and after optimization of portfolio the projected returns after months is around 8.2% from the model we have built.

 Challenges of algorithmic Trading

Efficient Market Hypothesis 
Developed by Professor Eugene Fama, which states that “Its impossible to beat the market”
Emotions are not captured
Leads to loss important volatility factor which cannot be determined by a machine.
Over-optimization
 Excessive curve fitting which leads to an unrealistic trading plan in a live market.

Development Prospects

Interactive data and Reuters are two of the biggest news vendors of the world provides daily news data which can be used to capture market sentiments. Sentiment analysis using text mining can be done to distribute weights to the stocks for better contextual forecast and considering risk factor and performing quadratic programming for more realistic optimization.









References

 [1] Yule, G. Udny. “Why Do We Sometimes Get Nonsense-Correlations between TimeSeries?--A Study in Sampling and the Nature of Time-Series.” Journal of the Royal Statistical Society, vol. 89, no. 1, 1926, pp. 1–63. www.jstor.org/stable/2341482. 
[2] Introduction to Time Series Analysis for Organizational Research: Methods for Longitudinal Analyses. Andrew T. Jebb1 and Louis Tay1
[3] Analysis of an adaptive time-series autoregressive moving-average(ARMA) model for short-term load forecasting. Jiann-Fuh Chen, Wei-Ming Wang, Chao-Ming Huang  
[4] Optimal Choice of AR and MA Parts in Autoregressive Moving Average Models RANGASAMI L. KASHYAP 
[5] Electricity demand loads modeling using AutoRegressive Moving Average. S.Sp. Pappas, L. Ekonomou , D.Ch. Karamousantas , G.E. Chatzarakis , S.K. Katsikas , P. Liatsis (ARMA) models 
[6] G. E. P. Box & David A. Pierce (1970). Distribution of Residual Autocorrelations in Autoregressive-Integrated Moving Average Time Series Models. Journal of the American Statistical Association, 65, 1509-1526. 
[7] J. Hawkins and D. George, Pooling in a hierarchical temporal memory based system, August 16 2007, US Patent App. 11/622,457. 
[8] David Rozado, Francisco B. Rodriguez, and Pablo Varona, Optimizing hierarchical temporal memory for multivariable time series, pp. 506–518, Springer Berlin Heidelberg, Berlin, Heidelberg, 2010.
[9] Herman Wold, A synthesis of pure demand analysis, Scandinavian Actuarial Journal 1944 (1944), no. 1-2, 69–120. 
[10] George E. P. Box, Mervin E. Muller, George C. Tiao, Forecasting and time series analysis using the SCA statistical system.
