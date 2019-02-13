* Read in the data.  This data needed to be converted to .xlsx due to bad formatting;
proc import datafile= "/home/lavos840/Bombing_Weather_Data.csv"
dbms = csv replace
out = weather(drop= StationIDs VAR1);
getnames= yes;
run;

* glm using all parameters;
proc glm data= weather plots= all;
model MeanCloudCover = MinTemp MaxTemp MeanTemp MinAirTemp SunDuration
 MeanCloudVapor Success MeanRelHumid PrecipHeight PrecipForm MeanPressure SnowDepth / solution clparm;
run;
* Stepwise feature selection;
proc glmselect data= weather plots= all;
class success;
model MeanCloudCover = MinTemp MaxTemp MeanTemp MinAirTemp SunDuration MeanCloudVapor 
	MeanRelHumid PrecipHeight PrecipForm MeanPressure 
	SnowDepth / selection=stepwise(choose= CV stop= CV) CVdetails;
run;

* Probit regression;
proc format;
value successful 1 = 'accept' 0 = 'reject';
run;
proc probit data= weather;
class success;
model success= MinTemp MaxTemp MeanTemp MinAirTemp SunDuration MeanCloudCover MeanCloudVapor 
	MeanRelHumid PrecipHeight PrecipForm MeanPressure / d=logistic itprint;
format success successful.;
run;

* Probit regression with parameters that are all significant;
proc probit data= weather;
class success;
model success= SunDuration MeanCloudCover MeanCloudVapor 
	MeanRelHumid PrecipForm / d=logistic itprint ;
format success successful.;
run;