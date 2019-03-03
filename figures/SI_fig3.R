





library(ggplot2)
library(ggthemes)
library(ggmap)
library(gridExtra)
library(scales)
library(car)
library(DescTools)
library(spdep)
library(ggthemes)

historical_data = read_csv('../processed-data/historical_data.csv')


snow_data = read_csv('../processed-data/snow_data.csv')

snow_data$month = tolower(snow_data$Month)
snow_data$year = as.integer(snow_data$Year)
snow_data$lat = as.integer(snow_data$lat_round)
snow_data$lon = as.integer(snow_data$long_round)

fig_SI3_data <- historical_data %>% 
  mutate(lat_round = round(lat, 0), long_round = round(lon, 1)) %>%
  filter(month == 'jan' | month == 'feb' | month == 'dec') %>%
  inner_join(snow_data, by = c('year', 'month', 'lat_round', 'long_round')) 


fig_SI3_data <- fig_SI3_data %>% 
  mutate(winterkill_pre = ifelse(is.na(cause.category.4), 0, cause.category.4)) %>%
  mutate(winterkill = ifelse(winterkill_pre == 'WINTERKILL', 1, 0))

fig_SI3_data$sig_ice <- ifelse(fig_SI3_data$winterkill == 1, 'p>.05', 'p>.05')

fig_SI3_data$sig_ice <- factor(fig_SI3_data$sig_ice, levels = c('p>.05', 'p<.05'))

boxplot <- fig_SI3_data %>%
  ggplot(aes(y =Snow,x = factor(winterkill))) +
  theme_tufte() +
  ylab('Precipitation')+
  xlab('Winterkill')+
  geom_boxplot(outlier.alpha = 0.1, aes(fill = sig_ice)) + 
  theme(text = element_text(size=13),axis.text = element_text(size=13),
        axis.line = element_line(colour = "black", 
                                 size = 0.5, linetype = "solid"))+
  scale_fill_manual(values = c('grey', 'gold'), guide = guide_legend(title = NULL))

boxplot


#### TEST ####


anova_snow <- aov(Snow ~ winterkill, fig_SI3_data)
summary(anova_snow)
tuk <- TukeyHSD(anova_snow)
tuk


