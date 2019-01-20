
dsn2 <- "../data/wisconsin_outline"
ogrListLayers(dsn2)
spatial_w <- readOGR(dsn2, layer = 'wisco_only')


map_data_w <-fortify(spatial_w) 

bbox =c(-92.9, 42.4, -87, 46.9) 
Wisconsin_map <- get_map(bbox, zoom = 7, maptype = 'toner-lines')



historical_data = read_csv('../processed-data/historical_data.csv')

future_data = read_csv('../processed-data/future_data.csv')


# Historical




fig3a_data <-historical_data %>%
  mutate(summerkill_binary = ifelse(is.na(summerkill) | summerkill == 0, 0 , 1)) %>%
  group_by(wbic) %>%
  summarise(MME = max(summerkill_binary), V1 = mean(lon), V2 = mean(lat))

map1 <- ggmap(Wisconsin_map) +
  geom_point(data = arrange(fig3a_data, MME), aes(x = V1, y = V2, color = MME, alpha = MME), size = 0.5)+
  scale_color_gradient(low = 'Blue', high = 'Red', limits = c(0, 1)) +
  ylab('Latitude')+
  xlab('Longitude')+
  theme(axis.title.x=element_text(),
        axis.title.y=element_text(),
        panel.border = element_rect(colour = "black", fill=NA, size=3),
        plot.margin=unit(c(1,0.3,1,1), "cm")
  ) +
  guides(color=FALSE, alpha = FALSE) +
  scale_alpha(limits = c(0,1))+
  geom_path(data = map_data_w, aes(x = long, y = lat, group = group))+
  theme(text = element_text(size=13), plot.title = element_text(margin = margin(b = 0), hjust = -0)) +
  ggtitle('a')

map1



# Modeled 



fig3b_data <- future_data %>%
  dplyr::select(wbic, lat, lon, year) %>%
  bind_cols(predictions_1)%>%
  mutate(event = `1`) %>%
  mutate(no_event_prob = 1 - event) %>%
  filter(year > 2030 & year < 2070) %>%
  group_by(wbic) %>%
  summarise(prob = (1 - prod(no_event_prob)), V1 = mean(lon), V2 = mean(lat)) 


fig3c_data <- future_data %>%
  dplyr::select(wbic, lat, lon, year) %>%
  bind_cols(predictions_1)%>%
  mutate(event = `1`) %>%
  mutate(no_event_prob = 1 - event) %>%
  filter(year > 2070) %>%
  group_by(wbic) %>%
  summarise(prob = (1 - prod(no_event_prob)), V1 = mean(lon), V2 = mean(lat)) 




map2 <- ggmap(Wisconsin_map) + 
  geom_point(data = arrange(fig3b_data, prob), aes(x = V1, V2, color = prob, alpha = prob), size = 0.5)+
  scale_color_gradient(low = 'Blue', high = 'Red',na.value = 'red', limits = c(0, 1)) +
  theme(axis.title.x=element_text(),
        axis.title.y=element_text(),
        axis.text.y=element_blank(),
        panel.border = element_rect(colour = "black", fill=NA, size=3),
        axis.ticks.y=element_blank(),
        plot.margin=unit(c(1,0.3,1,1), "cm"))+
  ylab('Latitude')+
  xlab('Longitude')+
  guides(color=FALSE, alpha = FALSE) +
  scale_alpha(limits = c(0,1))+
  geom_path(data = map_data_w, aes(x = long, y = lat, group = group)) +
  theme(text = element_text(size=13), plot.title = element_text(margin = margin(b = 0), hjust = 0.0)) +
  ggtitle('b')



map3 <- ggmap(Wisconsin_map) + 
  geom_point(data = arrange(fig3c_data, prob), aes(x = V1, V2, color = prob, alpha = prob),size = 0.5)+
  scale_color_gradient(low = 'Blue', high = 'Red', na.value = 'Red', limits = c(0, 1)) +
  theme(axis.title.x=element_text('Longitude'),
        axis.title.y=element_text('Latitude'),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank(),
        legend.key.size = unit(0.3, 'cm'), 
        legend.text= element_text(size = 5),
        panel.border = element_rect(colour = "black", fill=NA, size=3),
        legend.title = element_text(size = 10),
        plot.margin=unit(c(1,0.3,1,1), "cm"))+
  ylab('Latitude')+
  xlab('Longitude')+
  guides(alpha = FALSE) +
  scale_alpha(limits = c(0,1))+
  geom_path(data = map_data_w, aes(x = long, y = lat, group = group))+
  theme(text = element_text(size=13), plot.title = element_text(margin = margin(b = 0), hjust = 0.0)) +
  ggtitle('c')






# Together


grid.arrange(map1,map2, map3, ncol = 3,  widths = c(1.08,1,1.27))



