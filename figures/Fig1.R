library(ggplot2)
library(ggthemes)
library(ggmap)
library(gridExtra)
library(scales)
library(car)
library(DescTools)
library(spdep)

historical_data = read_csv('../processed-data/historical_data.csv')

fig1_data <- historical_data %>%
  mutate(cause.category.4 = replace(as.character(cause.category.4), which(is.na(cause.category.4)), 'Summer Non-event')) %>%
  mutate(cause.category.4 =  replace(as.character(cause.category.4), which(cause.category.4 == 'SUMMERKILL'), 'Summerkill'))%>%
  mutate(cause.category.4 =  replace(as.character(cause.category.4), which(cause.category.4 == 'INFECTIOUS AGENT'), 'Infectious Agent'))


fig1_data$sig <- ifelse(fig1_data$cause.category.4 == 'Summerkill', 'p<.05', 'p>.05')
fig1_data$sig <- factor(fig1_data$sig, levels = c('p>.05', 'p<.05'))

boxplot1 <- fig1_data %>%
  filter(month == 'jul' | month == 'jun' | month == 'aug' | month == 'sep') %>%
  filter(cause.category.4 == 'Summerkill' | cause.category.4 == 'Summer Non-event' | cause.category.4 == 'Infectious Agent') %>%   
  ggplot(aes(y = mean_surf,x = cause.category.4)) +
  theme_tufte() +  
  ylab('Mean Surf. Temp. (°C)')+
  theme(text = element_text(size=13),
        axis.text = element_text(size=13),
        legend.justification = c(1, -0.4), 
        legend.position = c(0.25, 0.15),
        legend.box.margin=margin(c(50,50,50,50)),
        axis.line = element_line(colour = "black", 
                                 size = 0.5, linetype = "solid"),
        axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank())+
  xlab(NULL)+
  geom_boxplot(outlier.alpha = 0.1, aes(fill = sig)) + 
  ggtitle('a') +
  scale_fill_manual(values = c('grey', 'gold'), guide = guide_legend(title = NULL))

boxplot2 <- fig1_data %>%
  filter(month == 'jul' | month == 'jun' | month == 'aug' | month == 'sep') %>%
  filter(cause.category.4 == 'Summerkill' | cause.category.4 == 'Infectious Agent' | cause.category.4 == 'Summer Non-event') %>%   
  ggplot(aes(y = mean_surf_z,x = cause.category.4)) +
  theme_tufte() +
  ylab('Z-score Mean Surf. Temp') +
  guides(fill = FALSE) +
  theme(text = element_text(size=13), 
        axis.line = element_line(colour = "black", 
                                 size = 0.5, linetype = "solid"))+
  geom_boxplot(outlier.alpha = 0.1, aes(fill = sig)) +
  theme(axis.text = element_text(size=13))+
  
  xlab(NULL) +
  geom_hline(yintercept = 0, alpha = 0.5)+ 
  ggtitle('b') +
  scale_fill_manual(values = c('grey', 'gold'), guide = guide_legend(title = 'T-test'))

grid.arrange(boxplot1, boxplot2)

rm(fig1_data)
rm(boxplot1)
rm(boxplot2)
