library(ggplot2)
library(ggthemes)
library(ggmap)
library(gridExtra)
library(scales)
library(car)
library(DescTools)
library(spdep)

library(purrr)

compute_quantile <- function(x, q, reps = 1000) {
  x %>%
    map_dfc( ~ rbinom(reps, 1, prob = .x)) %>%
    rowSums() %>%
    quantile(q)
}



fig2_data = future_data


fig2_data$prob <- predictions_1$`1`



fig2_data <- fig2_data %>%
  group_by(year) %>%
  summarize(temp = mean(mean_surf),
            pred_kills = sum(prob),
            lb_kill    = compute_quantile(prob, q = .025, reps = 5000),
            ub_kill    = compute_quantile(prob, q = .975, reps = 5000))


fig2_data = fig2_data%>% 
  mutate(early_kills = ifelse(Year < 2060, fig2_data$pred_kills, NA)) %>% 
  mutate(late_kills = ifelse(Year > 2060, fig2_data$pred_kills, NA))



full_data <- bind(fig2_data%>%
                    filter(Year > 2002) #%>%
                  # group_by(Year) %>%
                  #summarise(Summerkills = sum(Prob), 
                  #     Temp = mean(Mean_Surf_Temp))
                  ,  
                  main_data%>% 
                    group_by(Year) %>%
                    filter(Year<2014) %>%
                    summarise(actual_kills = sum(Summerkill), 
                              temp = mean(Mean_Surf_Temp))
) 

full_data = full_data%>%bind_rows(tibble(Year = c(2015:2040, 2060:2080))) %>% 
  mutate(y = 25) %>%   
  mutate(early_lb = ifelse(Year < 2060, lb_kill, NA))%>% 
  mutate(late_lb = ifelse(Year > 2060, lb_kill, NA)) %>%
  mutate(early_ub = ifelse(Year < 2060, ub_kill, NA))%>% 
  mutate(late_ub = ifelse(Year > 2060, ub_kill, NA))


plot<- full_data%>%
  ggplot(aes(x=Year,y = pred_kills)) +
  geom_rect(xmin = 2013, xmax = 2041, ymin = 0, ymax = 110, alpha = 0.004)+
  geom_rect(xmin = 2059, xmax = 2081, ymin = 0, ymax = 110, alpha = 0.004)+
  #geom_line(color = 'black') +
  #geom_ribbon(aes(ymax = ub_kill, ymin = lb_kill), alpha = 0.5)+
  geom_smooth(aes(y = actual_kills), span = 0.5, color = 'black', se = FALSE)+
  geom_smooth(aes(y = early_kills), span = 0.5, color = 'black', se = FALSE)+
  geom_smooth(aes(y = late_kills), span = 0.5, color = 'black', se = FALSE)+
  geom_smooth(aes(y = early_lb), span = 0.5, color = 'black', linetype = 'dashed', se = FALSE) +
  geom_smooth(aes(y = late_lb), span = 0.5, color = 'black', linetype = 'dashed', se = FALSE) +
  geom_smooth(aes(y=early_ub),span = 0.5, color = 'black', linetype = 'dashed', se = FALSE)+
  geom_smooth(aes(y=late_ub),span = 0.5, color = 'black', linetype = 'dashed', se = FALSE)+
  #geom_ribbon(ymin = lb, ymax = ub, alpha = 0.5) +
  geom_bar(stat = 'identity', aes(x = Year, y = y, fill = temp), alpha = 0.5)+
  
  ylab("Total Predicted Summerkills")+
  xlab(NULL) +
  #theme_tufte()+
  theme_calc()+
  scale_fill_gradient(low = 'blue', high = 'red', limits = c(9, 16)) +
  #scale_fill_manual( palette = 'Blue-Red', limits = c(9, 16), breaks = waiver())+
  ylim(0,130) 
plot

