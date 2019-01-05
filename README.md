# MME_Climate_Change_Research

This project contains the code for potential publication

# Publication Title: 'Thermal Extremes Drive Fish Die-offs in North Temperate Lakes'

  Authors: Aaron Till, Andrew L. Rypel, Andrew Bray, Samuel B. Fey
  
  Code: Aaron Till with assistance from Andrew Bray and Kristen Bot
  
This project aims to 
  
  a) explore the relationship between temperature and fish die-off events 
  
  b) model how die-offs will change in the future

Files:

# Importing and Tidying 
(package loading:rgdal, readr, dplyr, tidyr, stringer, lubridate)

  The steps for importing and tidying various datasets
    
    1) Wisconsin MME Dataset (available as Original_Fishkill_XXXX in data_output folder)
    
    2) US census data for wisconsin census blocks (https://www.census.gov/geo/maps-data/data/tiger-data.html)
    
    3) Coordinate data for Wisconsin and Wisconsin lakes (Winslow et al., 2017)
          model_lakes.shp at https://www.sciencebase.gov/catalog/item/57d97341e4b090824ffb0e6f)
    
    4) Data on modeled thermal temperatues (Winslow et al., 2017)  
          Concurrent = NLDAS, Future = ACCESS
          NLDAS_thermal_metrics.tsv + ACCESS_thermal_metrics.tsv at                                   
          https://www.sciencebase.gov/catalog/item/57d9e887e4b090824ffb1098 
    
    5) Lake names for building Lake_Assessment.CSV (Available as Wisonsin_Lakes_Maps.xslx.in output data)
    
    6) Joining file for site_id and WBIC numbers. (Available in output_data as NHD_WBIC.csv) 
    
    7) Supplementary - PRISM snow data for Wisconsin between 2004 and 2013. (http://prism.oregonstate.edu/historical/)
    
# Modeling 
(package loading: caret, glmnet)

  The creation and testing of the Lasso, Ridge, and basic Logistic models for Summerkill analysis. 
  
# Visualizations 
(package loading: ggplot2, ggthemes, ggmap, gridExtra, spdep)

  Code for all visualizations in the paper including:
    
    The visualizations and statistics for relating temperature to die-offs
    
    The visualizations of the primary model X taken from modeling
    
# SI Visualizations
  All visualizations included in papers supplementary information section
  

  
# Output Data

  Original Fishkill Data - This is the original excel file used in the initial importing and tidying steps
  
  Lake Risk Assessment - A data file of at risk lakes
  
  Wisonsin_Lakes_Maps - Lake names
  
 
    
