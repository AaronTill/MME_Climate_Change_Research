library(ggplot2)
library(ggthemes)
library(ggmap)
library(gridExtra)
library(scales)
library(car)
library(DescTools)
library(spdep)

historical_data = read_csv('../processed-data/historical_data.csv')


snow_data = read_csv('../processed-data/snow_data.csv')

snow_data$month = tolower(snow_data$Month)
snow_data$year = snow_data$Year

fig_SI4_data <- historical_data %>% 
  filter(month == 'jan' | month == 'feb' | month == 'dec') %>%
  inner_join(snow_data, by = c('year', 'month')) %>%
  mutate(mme_binary = ifelse(is.na(mme), 0, mme), 
         winterkill_binary = ifelse(is.na(winterkill), 0 , winterkill))




fig_SI4_data$sig_ice <- ifelse(fig_SI4_data$winterkill == 1, 'p>.05', 'p>.05')

fig_SI4_data$sig_ice <- factor(fig_SI4_data$sig_ice, levels = c('p>.05', 'p<.05'))

boxplot <- fig_SI4_data %>%
  filter(winterkill == 1 | mme == 0 ) %>%
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

