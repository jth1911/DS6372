* Read in the data.  This data needed to be converted to .xlsx due to bad formatting;
proc import datafile= "/home/lavos840/Bombing_Weather_Data.csv"
dbms = csv replace
out = weather(drop= StationIDs VAR1);
getnames= yes;
run;
proc print data= weather; run;

proc glm data= weather plots= all;
class success;
model MeanCloudCover = MinTemp MaxTemp MeanTemp MinAirTemp SunDuration
 MeanCloudVapor MeanRelHumid PrecipHeight PrecipForm MeanPressure SnowDepth / solution clparm;
run;