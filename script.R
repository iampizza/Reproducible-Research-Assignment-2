library(ggplot2)
library(reshape2)

datafile <- bzfile("~/repos/Reproducible-Research-Assignment-2/repdata-data-StormData.csv.bz2", "r")
csv <- read.csv(datafile)
close(datafile)



csv$EVTYPE <- tolower(csv$EVTYPE)


small <- csv[1:5000,]


typeScores <- aggregate(cbind(csv$INJURIES, csv$FATALITIES) ~ csv$EVTYPE, small, sum) # 10s
fullZero <- typeScores[,2] == 0 & typeScores[,3] == 0
cleanTypeScores <- typeScores[!fullZero,]
names(cleanTypeScores) <- cbind("type", "injuries", "fatalities")
rankInjuries <- order(cleanTypeScores[,2], decreasing=T)
rankFatalities <- order(cleanTypeScores[,3], decreasing=T)

toPlot <- cleanTypeScores[rankFatalities,]
toPlot <- toPlot[1:20,]

toPlot <- melt(toPlot, "type")


ggplot(toPlot, aes(x=type, y=value, fill=variable)) + 
        geom_histogram(position="dodge") +
        theme(axis.text.x = element_text(angle = 60, hjust = 1)) +
        labs(title="10 most destructive storms by type in the US - 1950 to 2011")





length(csv$PROPDMGEXP[csv$PROPDMGEXP == "B"])


events <- sort(unique(csv$EVTYPE[csv$PROPDMGEXP == "B"]))
# We take the unique list of event types concerned by billion dollar damages

# [1] "flash flood"               
# [2] "flood"                     
# [3] "hail"                      
# [4] "heavy rain/severe weather" 
# [5] "high wind"                 
# [6] "hurricane"                 
# [7] "hurricane opal"            
# [8] "hurricane opal/high winds" 
# [9] "hurricane/typhoon"         
# [10] "river flood"               
# [11] "severe thunderstorm"       
# [12] "storm surge"               
# [13] "storm surge/tide"          
# [14] "tornado"                   
# [15] "tornadoes, tstm wind, hail"
# [16] "tropical storm"            
# [17] "wild/forest fire"          
# [18] "wildfire"                  
# [19] "winter storm" 

     1      6 424665      7  11330
toMultiplier <- function(units){
        neo <- rep(0, length(units))
        neo <- replace(neo, units=="1", 1)
        neo <- replace(neo, units=="2", 1)
        neo <- replace(neo, units=="3", 3)
        neo <- replace(neo, units=="4", 4)
        neo <- replace(neo, units=="5", 5)
        neo <- replace(neo, units=="6", 6)
        neo <- replace(neo, units=="7", 7)
        neo <- replace(neo, units=="8", 8)
        
        neo <- replace(neo, units=="h", 10^2)
        neo <- replace(neo, units=="H", 10^2)
        neo <- replace(neo, units=="K", 10^3)
        neo <- replace(neo, units=="M", 10^6)
        neo <- replace(neo, units=="m", 10^9)
        neo <- replace(neo, units=="B", 10^12)
        
        return(neo)
}

values <- small$PROPDMG
units <- small$PROPDMGEXP
unique(units)
mul <- toMultiplier(csv$PROPDMGEXP)