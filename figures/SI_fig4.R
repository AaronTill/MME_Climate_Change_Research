library(ggplot2)
library(ggthemes)
library(ggmap)
library(gridExtra)
library(scales)
library(car)
library(DescTools)
library(spdep)

historical_data = read_csv('../processed-data/historical_data.csv')


fig_SI4_data <- left_join(historical_data, snow_data, by = c('year' = 'Year', 'month' = 'Month')) %>%
  mutate(mme = ifelse(mme == 1, 1, 0)) %>%
  mutate(winterkill = ifelse(winterkill == 1, 1, 0)) 




fig_SI4_data$sig_ice <- ifelse(fig_SI4_data$winterkill == 1, 'p>.05', 'p>.05')

fig_SI4_data$sig_ice <- factor(fig_SI4_data$sig_ice, levels = c('p>.05', 'p<.05'))

boxplot <- fig_SI4_data %>%
  filter(month == 'jan' | month == 'feb' | month == 'dec') %>%
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

