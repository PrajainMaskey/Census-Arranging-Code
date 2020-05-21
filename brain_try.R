rm(list = ls())
library(readr)
library(dplyr)
library(stringr)
library(readxl)
library(tidyr)
library(ggplot2)
library(scales)
library(stargazer)
library(purrr)
library(cluster)
library(dendextend)

#importing data
census_can <- read_csv("C:/Users/praja/Downloads/New folder (5)/98-401-X2016042_English_CSV_data.csv")

#selecting required variables
census_can <- census_can %>%
    select(census_year = CENSUS_YEAR, cma=GEO_NAME, charec=`DIM: Profile of Census Subdivisions (2247)`, pop = `Dim: Sex (3): Member ID: [1]: Total - Sex`, type=`Member ID: Profile of Census Subdivisions (2247)`, geo_code=GEO_LEVEL) %>%
    filter(geo_code==2)

#=========================================================================================================================================================================
final<-""
#max loop
max(census_can$type)
#2247

for(j in 1:max(census_can$type) )
{

#filtering required data dimension
age_data <- census_can%>%
  filter(type==j)

#filtering to keep the name
age_name <- census_can %>%
  filter(type==j & geo_code==2) 

age_name <- age_name[1,3]
#adding row name
age_data$id<- rownames(age_data)

#selecting required cloumns
age_data <- age_data %>%
  select(id, cma, pop)
names(age_data)[3]<- c(age_name)

#counting colum numbers to check
nrow(age_data) 
#152 

#loop to rbind the data
age_final<-""
for(i in 1:nrow(age_data))
{
  age_datai <- age_data
  age_datai$id <- i 
  age_final <- rbind(age_final, age_datai)
}
#removing blank first line
age_final <- age_final[-1,]
  
#merginf the data
merged_age<- merge(age_data, age_final, by="id", all = TRUE)

#converting id to number
merged_age <- merged_age %>%
  mutate(id=as.double(id)) %>%
  arrange(id)

#=================
#naming the columns
cma_names<- merged_age %>%
  mutate(id1=row_number(id)) %>%
  select(id,id1, cma.x,cma.y)

#removing the columns
merged_age <- merged_age %>%
  select(-cma.x, -cma.y, -id)

final<- cbind(final, merged_age)
}


#=============================================================================================================================================================================
#adding cma and removing the empty final
final<- cbind(cma_names, final)

final<- final[,-5]

nrow(final)
ncol(final)
#==============================================================================================================================================================================
#exporting the output
write.csv(final, file = "C:/Users/praja/Downloads/New folder (5)/final.csv")
