Most harmful or destructive storms in the United States from 1950 to 2011
========================================================

## Synopsis
In this document we present analysis of the last 60 years storms that occured in the United States. We highlight storm types that have the highest human and economic impact or los.


```r
datafile <- bzfile("~/repos/Reproducible-Research-Assignment-2/repdata-data-StormData.csv.bz2", "r")
```

```
## Warning: cannot open bzip2-ed file
## '/Users/jmarhee/repos/Reproducible-Research-Assignment-2/repdata-data-StormData.csv.bz2',
## probable reason 'No such file or directory'
```

```
## Error: cannot open the connection
```

```r
csv <- read.csv(datafile)
```

```
## Error: object 'datafile' not found
```

```r
close(datafile)
```

```
## Error: object 'datafile' not found
```


## Data Processing

Cleaning data:
* using lower case event name to group them
* compute ranking of events according to number of injured and killed people


```r
csv$EVTYPE <- tolower(csv$EVTYPE)
```

```
## Error: object 'csv' not found
```

```r
typeScores <- aggregate(cbind(csv$INJURIES, csv$FATALITIES) ~ csv$EVTYPE, csv, sum) # 10s
```

```
## Error: object 'csv' not found
```

```r
fullZero <- typeScores[,2] == 0 & typeScores[,3] == 0
```

```
## Error: object 'typeScores' not found
```

```r
cleanTypeScores <- typeScores[!fullZero,]
```

```
## Error: object 'typeScores' not found
```

```r
names(cleanTypeScores) <- cbind("type", "injuries", "fatalities")
```

```
## Error: object 'cleanTypeScores' not found
```

```r
rankInjuries <- order(cleanTypeScores[,2], decreasing=T)
```

```
## Error: object 'cleanTypeScores' not found
```

```r
rankFatalities <- order(cleanTypeScores[,3], decreasing=T)
```

```
## Error: object 'cleanTypeScores' not found
```


## Results

### Across the United States, which types of events are most destructive/harmful?


```r
toPlot <- cleanTypeScores[rankFatalities,]
```

```
## Error: object 'cleanTypeScores' not found
```

```r
toPlot <- toPlot[1:20,]
```

```
## Error: object 'toPlot' not found
```

```r
toPlot <- melt(toPlot, "type")
```

```
## Error: could not find function "melt"
```

```r
ggplot(toPlot, aes(x=type, y=value, fill=variable)) + 
  geom_bar(position="dodge")+
  #geom_histogram(position="dodge") +
  theme(axis.text.x = element_text(angle = 60, hjust = 1)) +
  labs(title="10 most destructive storms by type in the US - 1950 to 2011")
```

```
## Error: could not find function "ggplot"
```

### Across the United States, which types of events have the greatest economic consequences?

We focus on event types implying **B**illion dollars of property and crop destructions.

The list of event type is given bellow:


```r
eventsProp <- sort(unique(csv$EVTYPE[csv$PROPDMGEXP == "B"]))
```

```
## Error: object 'csv' not found
```

```r
eventsCrop <- sort(unique(csv$EVTYPE[csv$PROPDMGEXP == "B"]))
```

```
## Error: object 'csv' not found
```

```r
events     <- sort(unique(rbind(eventsProp, eventsCrop)))
```

```
## Error: object 'eventsProp' not found
```

```r
print(events)
```

```
## Error: object 'events' not found
```


## Reproducing the analysis

R source: https://github.com/iampizza/Reproducible-Research-Assignment-2/
Data: https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2


