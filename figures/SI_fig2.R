library(ggplot2)
library(ggthemes)
library(ggmap)
library(gridExtra)
library(scales)
library(car)
library(DescTools)
library(spdep)

historical_data = read_csv('../processed-data/historical_data.csv')


fig_SI1_data <- historical_data %>%
  mutate(cause.category.4 = replace(as.character(cause.category.4), which(cause.category.4 == 'ANTHROPOGENIC CONDITION'), 'Human Perturbation')) %>%
  mutate(cause.category.4 =  replace(as.character(cause.category.4), which(cause.category.4 == 'WINTERKILL'), 'Winterkill'))%>%
  mutate(cause.category.4 =  replace(as.character(cause.category.4), which(cause.category.4 == 'INFECTIOUS AGENT'), 'Infectious Agent'))

fig_SI1_data$sig_all <- ifelse(fig_SI1_data$cause.category.4 == 'Winterkill', 'p<.05', 'p>.05')
fig_SI1_data$sig_all <- factor(fig_SI1_data$sig_all, levels = c('p>.05', 'p<.05'))

boxplot <- fig_SI1_data %>%
  filter(cause.category.4 == 'Infectious Agent' | cause.category.4 == 'Winterkill' | cause.category.4 == 'Human Perturbation' ) %>%
  ggplot(aes(y = mean_surf_z,x = cause.category.4)) +
  theme_tufte() +
  ylab('Z-score All Seasons')+
  xlab('Category of Killtype')+
  xlab(NULL) +
  geom_hline(yintercept = 0, alpha = 0.5) +
  theme(text = element_text(size=13),axis.text = element_text(size=13),
        axis.line = element_line(colour = "black", 
                                 size = 0.5, linetype = "solid"))+
  geom_boxplot(outlier.alpha = 0.1,aes(fill = sig_all)) + 
  scale_fill_manual(values = c('grey', 'gold'), guide = guide_legend(title = NULL))

boxplot




#### TEST ####



DunnettTest(mean_surf_z ~ factor(cause.category.4), data = fig_SI1_data, control = 'Human Perturbation')
