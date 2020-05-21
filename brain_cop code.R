#==============================================================================================================================================================================

#filtering required data dimension
age_data_a <- census_can%>%
  filter(type==2)

#filtering to keep the name
age_name_a <- census_can %>%
  filter(type==2 & geo_code==2) 

age_name_a <- age_name_a[1,3]

#adding row name
age_data_a$id<- rownames(age_data_a)

#selecting required cloumns
age_data_a <- age_data_a %>%
  select(id, cma, pop)
names(age_data_a)[3]<- c(age_name_a)


#counting colum numbers to check
nrow(age_data_a) 
#152 

#loop to rbind the data
age_final_a<-""
for(i in 1:nrow(age_data_a))
{
  age_datai_a <- age_data_a
  age_datai$id <- i 
  age_final_a <- rbind(age_final_a, age_datai_a)
}
#removing blank first line
age_final_a <- age_final_a[-1,]

#merginf the data
merged_age_a<- merge(age_data_a, age_final_a, by="id", all = TRUE)

#converting id to number
merged_age_a <- merged_age_a %>%
  mutate(id=as.double(id)) %>%
  arrange(id)

#removing the columns
merged_age_a <- merged_age_a %>%
  select(-cma.x, -cma.y)


