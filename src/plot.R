#################################################################
############itation with discharge plot###########################
######################################################################

###method 1
ggplot() +
  geom_line(mapping = aes(x = q_obs$date, y = q_obs$discharge), size = 0.5, color = "blue") +
  geom_bar(mapping = aes(x = pcp_obs$date, y = pcp_obs$precipitation*10),
           stat = "identity", fill = "black") +
  scale_x_date(name = "date", ) +
  scale_y_continuous(name = "discharge",
                     sec.axis = sec_axis(~./10, name = "precipitation")) +
  theme(
    axis.title.y = element_text(color = "blue"),
    axis.title.y.right = element_text(color = "black"))

###method 2

obs<-cbind(q_obs,pcp_obs[2])

p <- ggplot(obs, aes(x=date))+
  geom_line(aes(y= discharge, colour = "discharge"))+
  geom_col(aes(y=precipitation*10, colour = "precipitation")) +
  scale_y_continuous(sec.axis =sec_axis(~./10, name="precipitation(mm)")) +
  scale_colour_manual(values = c("blue","black"))+
  labs(y = "discharge (cms)",
       x= "Date",
       colour="Parameter") +
  theme(legend.position = c(0.8,0.9))

p

########################################################
#########bacteria with discharge plot##################
#######################################################
###method1
ggplot() +
  geom_line(mapping = aes(x = q_obs$date, y = q_obs$discharge), size = 0.7, color = "blue") +
  geom_point(mapping = aes(x = bac_obs$date, y = bac_obs$bacteria*0.02), color = "tomato3") +
  scale_x_date(name = "date", ) +
  scale_y_continuous(name = "discharge (cms)",
                     sec.axis = sec_axis(~./0.02, name = "bacteria(MPN/100ml)")) +
  theme(
    axis.title.y = element_text(color = "blue"),
    axis.title.y.right = element_text(color = "tomato3"))

##method2

ggplot() +
  geom_line(mapping = aes(x = q_obs$date, y = q_obs$discharge, colour="discharge"), size = 0.7) +
  geom_point(mapping = aes(x = bac_obs$date, y = bac_obs$bacteria*0.02, colour= "bacteria")) +
  scale_y_continuous(sec.axis = sec_axis(~./0.02, name = "bacteria(MPN/100ml)")) +
  scale_color_manual(values = c("tomato3","blue"))+
  labs(y = "discharge (cms)",
       x= "Date",
       colour="Parameter") +
  theme(legend.position = c(0.8,0.9))


######################################################################
############### bacteria simulation and observation plot##############
#####################################################################
sort(nse_bac, decreasing = T) %>% enframe()

bac_plot <-right_join(bac_cal1$simulation$bac_out,bac_obs,by="date")%>%
  dplyr::select(date, run_10654)%>%
left_join(., bac_obs, by ="date")%>%
  rename (bac_obs=bacteria)%>%
  gather(., key= "variable", value="bacteria",-date)


ggplot(data = bac_plot)+
  geom_line(aes(x = date, y = bacteria, col = variable, lty = variable)) +
  geom_point(aes(x = date, y = bacteria, col = variable, lty = variable)) +
  scale_color_manual(values = c("black", "tomato3")) +
  theme_bw()



######################################################################
############### discharge simulation and observation plot##############
####################################################################

sort(nse_q, decreasing = T) %>% enframe()

q_plot <-bac_cal1$simulation$q_out%>%dplyr::select(date, run_08892)%>%
  left_join(., q_obs, by ="date")%>% 
  rename (q_obs=discharge)%>%gather(., key= "variable", value="discharge",-date)

ggplot(data = q_plot) +
  geom_line(aes(x = date, y = discharge, col = variable, lty = variable)) +
  scale_color_manual(values = c("black", "tomato3")) +
  theme_bw()


######################################################################
############### flux simulation and observation plot##############
####################################################################
flux_sim <- sim_bac[c(97:167),c(-1)]*
  sim_q[c(97:167), c(-1)]*10^4

flux_plot <-cbind(flux_sim[,11805], flux_obs[,1])

ggplot() +
  geom_line(mapping = aes(x = bac_obs$date, y = flux_plot[,1]), size = 0.7, colour = "black") +
  geom_point(mapping = aes(x = bac_obs$date, y = flux_plot[,2]), colour = "green") +
  #scale_y_continuous(sec.axis = sec_axis(~., name = "flux")) +
  #scale_color_manual(values = c("tomato3","blue"))+
  labs(y = "flux",
       x= "Date",
       colour="Parameter") +
  theme(legend.position = c(0.8,0.9))
#########################################################
#########plot bacteria with discharge (simulation data)####################
###########################################################
###Method1
bac <- bac_cal1$simulation$bac_out%>%dplyr::select(date, run_10654)
names(bac)[2]<- paste("bacteria")

q  <- bac_cal1$simulation$q_out%>%dplyr::select(date, run_10654)
names(q)[2] <- paste("discharge")


bac_q_plot <- bac %>% left_join(., q, by ="date" )

ggplot(bac_q_plot,aes(date,discharge)) +
  geom_line(aes(y = discharge), size =0.5, color = "blue") +
  geom_point(aes(y = bacteria/100), size = 0.8, color = "tomato3") +
  scale_y_continuous(name = "discharge", limits=c(0,30),
                     sec.axis = sec_axis(~(.*100), name = "bacteria")) +
  theme(
    axis.title.y = element_text(color = "blue"),
    axis.title.y.right = element_text(color = "tomato3"))


#

  
  
  

