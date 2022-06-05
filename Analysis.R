library(readr)
library(dplyr)
library(ggplot2)
library(tidyverse)
library(hrbrthemes)

data <- read.csv("/Users/maoyiliao/Desktop/a3-data-visualization-Maoi123/incarceration_trends.csv")

data_df <- select(data, year, total_jail_pop, aapi_jail_pop, black_jail_pop, latinx_jail_pop,
                  native_jail_pop, white_jail_pop, other_race_jail_pop)
data_df[data_df==""]<-NA
data_df <- data_df[complete.cases(data_df),]

#What's the mean of each value in most recent year(2018)?
data_2018 <- filter(data_df, year == "2018")
total_pop_mean <- mean(data_2018$total_jail_pop)
aapi_pop_mean <- mean(data_2018$aapi_jail_pop)
black_pop_mean <- mean(data_2018$black_jail_pop)
latinx_pop_mean <- mean(data_2018$latinx_jail_pop)
native_mean <- mean(data_2018$native_jail_pop)
white_mean <- mean(data_2018$white_jail_pop)
other_mean <- mean(data_2018$other_race_jail_pop)
mean_2018_value <- c(total_pop_mean, aapi_pop_mean, black_pop_mean, latinx_pop_mean, native_mean, white_mean, other_mean)

#What's the max mean number in different races? And how about the minimal number?
max_mean <- max(c(total_pop_mean, aapi_pop_mean, black_pop_mean, latinx_pop_mean, native_mean, white_mean, other_mean))
min_mean <- min(c(total_pop_mean, aapi_pop_mean, black_pop_mean, latinx_pop_mean, native_mean, white_mean, other_mean))
dif_mean <- max_mean - min_mean

#What's the highest number in each race?
total_pop_max <- max(data_2018$total_jail_pop)
aapi_pop_max <- max(data_2018$aapi_jail_pop)
black_pop_max <- max(data_2018$black_jail_pop)
latinx_pop_max <- max(data_2018$latinx_jail_pop)
native_max <- max(data_2018$native_jail_pop)
white_max <- max(data_2018$white_jail_pop)
other_max <- max(data_2018$other_race_jail_pop)
highest_value <- c(total_pop_max, aapi_pop_max, black_pop_max, latinx_pop_max, native_max, white_max, other_max)

#What's the lowest number in each variable (different race)?
total_pop_min <- min(data_2018$total_jail_pop)
aapi_pop_min <- min(data_2018$aapi_jail_pop)
black_pop_min <- min(data_2018$black_jail_pop)
latinx_pop_min <- min(data_2018$latinx_jail_pop)
native_min <- min(data_2018$native_jail_pop)
white_min <- min(data_2018$white_jail_pop)
other_min <- min(data_2018$other_race_jail_pop)
lowest_value <- c(total_pop_min, aapi_pop_min, black_pop_min, latinx_pop_min, native_min, white_min, other_min)

#How many people are incarcerated in different racial groups in different years?
data_group <- data_df %>% group_by(data_df$year) %>% summarise(across(everything(), sum))
data_group <- subset(data_group, select=-year)
names(data_group)[1] <- "year"
head(data_group)

#Trends over time chart
df <- data_group %>%
  select(year, total = total_jail_pop, Asian = aapi_jail_pop, black = black_jail_pop, 
         latinx = latinx_jail_pop, native = native_jail_pop, white = white_jail_pop, other = other_race_jail_pop) %>%
  gather(key = "race_jail_population", value = "population", -year)
head(df)
trend_chart <- ggplot(df, aes(x = year, y = population)) + 
  geom_line(aes(color = race_jail_population, linetype = race_jail_population)) + 
  scale_color_manual(values = c("darkred", "steelblue", "orange", "green", "purple", "black", "yellow")) +
  ggtitle("Increasing jail population in different races with years")

#Variable comparison chart
data_scatterPlot <- data.frame(total = data_group$total_jail_pop, black = 
                                 data_group$black_jail_pop)

sp_case_death <- ggplot(data_scatterPlot, aes(total, black)) +
                    geom_point(size=1) +
                    geom_smooth(method=lm , color="red", se=TRUE) +
                    theme_ipsum()+
                    ggtitle("Jail population between total & black")
sp_case_death

#Map
library(viridis)
library(mapproj)

data_BW <- select(data, year, state, black_jail_pop, white_jail_pop)
data_BW_2018 <- filter(data_BW, year == "2018")
data_BW_2018[data_BW_2018==""]<-NA
data_BW_2018 <- data_BW_2018[complete.cases(data_BW_2018),]
data_BW_2018
data_BW_2018_sumState <- data_BW_2018 %>% 
  group_by(state) %>% 
  summarise(across(everything(), sum))

library(maps)
MainStates <- map_data("state")
names(data_BW_2018_sumState)[1] <- "region"
state_abb <- state.name[match(data_BW_2018_sumState$region, state.abb)]
data_BW_2018_sumState[1] <- state_abb
data_BW_2018_sumState$region <- tolower(data_BW_2018_sumState$region)
data_BW_2018_sumState
MainStates
ggplot() + 
  geom_polygon( data=MainStates, aes(x=long, y=lat, group=group),
                color="black", fill="lightblue" )
MergedStates <- inner_join(data_BW_2018_sumState, MainStates, by = "region")

#Draw the black jail population in 2018
p_black <- ggplot()
p_black <- p_black + geom_polygon( data=MergedStates, 
                       aes(x=long, y=lat, group=group, fill = black_jail_pop/1000000),
                       color="white", size = 0.2) + 
  labs(title="Black Jail Population in the Mainland United States")
p_black

#Draw the white jail population in 2018
p_white <- ggplot()
p_white <- p_white + geom_polygon( data=MergedStates, 
                       aes(x=long, y=lat, group=group, fill = white_jail_pop/1000000), 
                       color="white", size = 0.2) +
  labs(title="Black Jail Population in the Mainland United States")
p_white



