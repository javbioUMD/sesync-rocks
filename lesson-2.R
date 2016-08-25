## Tidy data concept

counts_df <- data.frame(
  day = c("Monday", "Tuesday", "Wednesday"),
  wolf = c(2, 1, 3),
  hare = c(20, 25, 35),
  fox  = c(4, 4, 4)
)

## Reshaping multiple columns in category/value pairs

library(tidyr)
counts_gather <- gather(counts_df, key = 'species', value = 'count', wolf:fox)

counts_spread <- spread(counts_gather, key = species, value = count)

#Remove a row of counst_gather
counts_gather <- counts_gather[-8, ]
counts_spread <- spread(counts_gather, key = species, value = count)

#Convert that NA value to a 0
sol1 <- spread(counts_gather, key = species, value=count, fill=0)

## Exercise 1

...

## Read comma-separated-value (CSV) files
#str is a very useful function!
surveys <- read.csv("data/surveys.csv", na.strings = "")
str(surveys)



## Subsetting and sorting

library(dplyr)
surveys_1990_winter <- filter(surveys, year == 1990, month %in% 1:3)
str(surveys_1990_winter)

surveys_1990_winter <- select(surveys_1990_winter, record_id, month, day, plot_id, species_id, sex, hindfoot_length, weight)
#anotherway
surveys_1990_winter <- select(surveys_1990_winter, -day)
str(surveys_1990_winter)

sorted <- arrange(surveys_1990_winter, desc(species_id), weight)

## Exercise 2
surveys_ex2 <- select(surveys, record_id, sex, weight, species_id == "RO")
surveys_ex_2 <- filter(surveys_ex2, species_id == "RO")
?filter

## Grouping and aggregation

surveys_1990_winter_gb <- group_by(surveys_1990_winter, species_id)

counts_1990_winter <- summarize(surveys_1990_winter_gb, count = n())

## Exercise 3
ex3_1 <- filter(surveys, species_id == "DM")
ex3_2 <- group_by(ex3_1, month)
ex3_3 <- summarise(ex3_2, mean(weight, na.rm=T), mean(hindfoot_length, na.rm=T))

## Transformation of variables

prop_1990_winter <- mutate(counts_1990_winter, prop = count / sum(count))

## Exercise 4

ex4_1 <- group_by(surveys_1990_winter, species_id)
ex4_2 <- filter(ex4_1, weight == min(weight, na.rm=T))

mutate(surv_grp, rank = row_number(hindfoot_length))

## Chainning with pipes

%>% represents a pipe

prop_1990_winter_piped <- surveys %>%
  filter(year == 1990, month %in% 1:3) %>%
  select(-year) %>% # select all columns but year
  group_by(species_id) %>%  # group by species_id
  summarize(counts = n()) %>% # summarize with counts
  mutate(prop = count/sum(count)) # mutate into proportionss
