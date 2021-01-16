#working directory
#setwd("~/Dropbox (Harvard University)/Networks-Lockdown/Simulations/Sam Local/FinalOutput")

#import libraries and packages
library(tidyverse)
#install.packages("R.matlab")

library(extrafont) 
# execute once to add fonts:
#font_import(pattern = "lmroman*") 
#https://www.fontsquirrel.com/fonts/latin-modern-roman
loadfonts()
library(R.matlab)
library(reshape2)


#overall theme
lockdown_theme2 <- function() {theme_minimal() %+replace%
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank(), axis.line = element_line(colour = "grey"),
          legend.key = element_rect(fill="transparent", colour=NA),
          plot.title = element_text(size=32,  family="Times",  hjust = 0, vjust = 0),
          plot.subtitle = element_text(size=32,  family="Times",  hjust = 1, vjust=1),
          plot.caption = element_text(size=8,  family="Times", hjust = 1),
          axis.text =element_text(size=32, family="Times", ),
          axis.title =element_text(size=32, family="Times"),
          legend.title=element_text(size=32, family="Times", ), 
          legend.text=element_text(size=32, family="Times", ),
          legend.position = c(0.85,0.85),
          plot.title.position="plot",
          plot.caption.position = "plot")
}
lockdown_theme_blank <- function() {theme_blank() %+replace%
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank(), axis.line = element_line(colour = "grey"),
          legend.key = element_rect(fill="transparent", colour=NA),
          plot.title = element_text(size=20,  family="Times",  hjust = 0, vjust = 0),
          plot.subtitle = element_text(size=20,  family="Times",  hjust = 1, vjust=1),
          plot.caption = element_text(size=8,  family="Times", hjust = 1),
          axis.text =element_text(size=20, family="Times", ),
          axis.title =element_text(size=20, family="Times"),
          legend.title=element_text(size=20, family="Times", ), 
          legend.text=element_text(size=20, family="Times", ),
          legend.position = c(0.85,0.85),
          plot.title.position="plot",
          plot.caption.position = "plot")
}

## Figure 1
#install.packages("ggnetwork")
library(network)
library(sna)
library(ggnetwork)

edges <- read.csv("figure1_graph.csv")
info <- read.csv("figure1_nodes.csv")
info[,1] <- as.character(info[,1])
info[info[,2] == 0,1] <- "i0"
coords <- read.csv("figure1_coords.csv")
fig1.net <- network(edges, directed=FALSE)
fig1.net %v% "place" <- as.character(info[,1])
fig1.net %v% "dist" <- info[,2]
fig1.net %v% "x1" <- coords$x1
fig1.net %v% "y1" <- coords$y1
fig1.net %v% "x2" <- coords$x2
fig1.net %v% "y2" <- coords$y2

ggplot(data=ggnetwork(fig1.net, layout=scale(coords[,1:2])), 
       aes(x, y, xend = xend, yend = yend)) + 
    geom_edges(color="grey", alpha = 0.35) +
    geom_nodes(aes(color=factor(place), fill=factor(place), 
                   shape=factor(dist)), size=6) + 
    theme_blank() + 
    theme(legend.position = "bottom") + 
  scale_shape_manual(values = c(21,24,22,23,25)) +
  scale_fill_manual(values = c("#00BFC4", "#7CAE00","#ff0000"),
                    breaks = c("a","b")) +
  scale_color_manual(values = c("#00BFC4", "#7CAE00","#ff0000"),
                     breaks = c("a","b")) +
  labs(fill = "Jurisdiction",
       color = "Jurisdiction",
       shape = "Distance") +
  theme(
    legend.title=element_text(size=32, family="Times", ), 
    legend.text=element_text(size=32, family="Times", ),
    legend.box="vertical")
ggsave("figure1A.pdf", width = 13.57, height=7.28)


ggplot(data=ggnetwork(fig1.net, layout=scale(coords[,3:4])), aes(x, y, xend = xend, yend = yend)) + 
  geom_edges(color="grey", alpha = 0.35) +
  geom_nodes(aes(color=factor(place), fill=factor(place), 
                 shape=factor(dist)), size=6) + 
  theme_blank() + 
  theme(legend.position = "bottom") + 
  scale_shape_manual(values = c(21,24,22,23,25)) +
  scale_fill_manual(values = c("#00BFC4", "#7CAE00","#ff0000"),
                    breaks = c("a","b")) +
  scale_color_manual(values = c("#00BFC4", "#7CAE00","#ff0000"),
                     breaks = c("a","b")) +
  labs(fill = "Jurisdiction",
       color = "Jurisdiction",
       shape = "Distance") +
  theme(
    legend.title=element_text(size=34, family="Times", ), 
    legend.text=element_text(size=34, family="Times", ),
    legend.box="vertical"
    ) 
ggsave("figure1B.pdf", width = 13.57, height=7.28)



#Figure 2 overall parameters
scaler <- 1000000/140000
t_lim <-200
y_left <- 600
y_right <- 6000
comp <- y_right/y_left
infection_color="#002bff"
detection_color="#ff0000"
recovered_color="#000000"

#2A
fig2A <- readMat('figure2A_output.mat')
infected <- scaler*colMeans(fig2A[["infection.mat.1"]])
detected <- scaler*colMeans(fig2A[["detection.mat.1"]])
recovered <- scaler*colMeans(fig2A[["recovered.mat.1"]])/comp
time <- 1:500
ts_2A <- data.frame(cbind(infected, recovered, time)) %>% 
  gather( ts_type, value, -time)

ggplot(ts_2A, aes(x=time, y =value)) + 
  geom_line(aes(color = ts_type,
    linetype = ts_type), size = 1.5 )+
  scale_y_continuous(sec.axis=sec_axis(~.*comp, name="", 
                                       labels = scales::comma),
                     limits=c(0, y_left),
                     labels = scales::comma)+
  scale_x_continuous( limits=c(0, t_lim))  +
  labs(color = "",
       title = "Infected (per mill.)",
       subtitle = "Recovered (per mill.)",
       y     = "",
       x     = "Time",
       color = "",
       linetype = ""
       ) +
  lockdown_theme2()
  # annotate("text", x = 150, y = 300, label = "Failure Rate = 0.09",
  #          family="LM Roman 10",
  #          size = 6,
  #          hjust=0
  #          )
ggsave("../Paper/figure2A.pdf", width = 13.57, height=7.28)

fig2B <- readMat('figure2B_output.mat')
infected <- scaler*colMeans(fig2B[["infection.mat.2"]])
detected <- scaler*colMeans(fig2B[["detection.mat.2"]])
recovered <- scaler*colMeans(fig2B[["recovered.mat.2"]])/comp
time <- 1:500
ts_2B <- data.frame(cbind(infected, recovered, time)) %>% 
  gather( ts_type, value, -time)

ggplot(ts_2B, aes(x=time, y =value,
                  color = factor(ts_type),
                  linetype = factor(ts_type))) + 
  geom_line(size = 1.5 ) +
  scale_y_continuous(sec.axis=sec_axis(~.*comp, name="",
                                       labels = scales::comma),#"Recovered individuals (per mill.)"), 
                     limits=c(0, y_left),
                     labels = scales::comma)+
  scale_x_continuous( limits=c(0, t_lim))  +
  labs(color = "",
       title = "Infected (per mill.)",
       subtitle = "Recovered (per mill.)",
       y     = "",
       x     = "Time",
       color = "",
       linetype = ""
  ) +
  lockdown_theme2() 
  # annotate("text", x = 150, y = 300, label = "Failure Rate = 0.39",
  #          family="LM Roman 10",
  #          size = 6,
  #          hjust=0
  #)
ggsave("../Paper/figure2B.pdf", width = 13.57, height=7.28)

# 
# fig2C <- readMat('figure2C_output.mat')
# infected <- scaler*colMeans(fig2C[["infection.mat.3"]])
# detected <- scaler*colMeans(fig2C[["detection.mat.3"]])
# recovered <- scaler*colMeans(fig2C[["recovered.mat.3"]])/comp
# time <- 1:500
# ts_2C <- data.frame(cbind(infected, recovered, time)) %>% 
#   gather( ts_type, value, -time)
# 
# ggplot(ts_2C, aes(x=time, y =value, 
#                   color = factor(ts_type),
#                   linetype = factor(ts_type))) + 
#   geom_line(size = 1.5 ) +
#   scale_y_continuous(sec.axis=sec_axis(~.*comp, name="",
#                                        labels = scales::comma),#"Recovered individuals (per mill.)"), 
#                      limits=c(0, y_left),
#                      labels = scales::comma)+
#   scale_x_continuous( limits=c(0, t_lim))  +
#   labs(color = "",
#        title = "Infected (per mill.)",
#        subtitle = "Recovered (per mill.)",
#        y     = "",
#        x     = "Time",
#        color = "",
#        linetype = ""
#   ) +
#   lockdown_theme2()
#   # annotate("text", x = 150, y = 300, label = "Failure Rate = 0.00",
#   #          family="LM Roman 10",
#   #          size = 6,
#   #          hjust=0
#   # )
# ggsave("../Paper/figure2C.pdf")
# 

fig2D <- readMat('figure2D_output.mat')
infected <- scaler*colMeans(fig2D[["infection.mat.4"]])
detected <- scaler*colMeans(fig2D[["detection.mat.4"]])
recovered <- scaler*colMeans(fig2D[["recovered.mat.4"]])/comp
time <- 1:500
ts_2D <- data.frame(cbind(infected, recovered, time)) %>% 
  gather( ts_type, value, -time)

ggplot(ts_2D, aes(x=time, y =value, 
                  color = factor(ts_type),
                  linetype = factor(ts_type))) + 
  geom_line(size = 1.5 ) +
  scale_y_continuous(sec.axis=sec_axis(~.*comp, name="",
                                       labels = scales::comma),#"Recovered individuals (per mill.)"), 
                     limits=c(0, y_left),
                     labels = scales::comma)+
  scale_x_continuous( limits=c(0, t_lim))  +
  labs(color = "",
       title = "Infected (per mill.)",
       subtitle = "Recovered (per mill.)",
       y     = "",
       x     = "Time",
       color = "",
       linetype = ""
  ) +
  lockdown_theme2() +
  theme(
    legend.position = c(0.85,0.65))
  # annotate("text", x = 150, y = 300, label = "Failure Rate = 0.48",
  #          family="LM Roman 10",
  #          size = 6,
  #          hjust=0
  # )
ggsave("../Paper/figure2D.pdf", width = 13.57, height=7.28)


### FIgure 3
y_left <- 8000
y_right <- 350000
t_lim <-1000
comp <- y_right/y_left
scaler <- 1000000/140000
time <- 1:2500

#3A
fig3A <- readMat('figure3A_output.mat')
infected <- scaler*colMeans(fig3A[["infection.mat.1"]])
detected <- scaler*colMeans(fig3A[["detection.mat.1"]])
recovered <- scaler*colMeans(fig3A[["recovered.mat.1"]])/comp
ts_3A <- data.frame(cbind(infected, recovered, time)) %>% 
  gather( ts_type, value, -time)

ggplot(ts_3A, aes(x=time, y =value)) + 
  geom_line(aes(color = ts_type,
                linetype = ts_type), size = 1.5 )+
  scale_y_continuous(sec.axis=sec_axis(~.*comp, name="",
                                       labels = scales::comma),
                     limits=c(0, y_left),
                     labels = scales::comma)+
  scale_x_continuous( limits=c(0, t_lim))  +
  labs(color = "",
       title = "Infected (per mill.)",
       subtitle = "Recovered (per mill.)",
       y     = "",
       x     = "Time",
       color = "",
       linetype = ""
  ) +
  lockdown_theme2() +
  theme(
    legend.position = c(0.85,0.65),
    plot.subtitle=element_text( margin=margin(0,0,5,0)))
ggsave("figure3A.pdf", width = 13.57, height=7.28)

#3B
fig3B <- readMat('figure3B_output.mat')
infected <- scaler*colMeans(fig3B[["infection.mat.2"]])
detected <- scaler*colMeans(fig3B[["detection.mat.2"]])
recovered <- scaler*colMeans(fig3B[["recovered.mat.2"]])/comp
ts_3B <- data.frame(cbind(infected, recovered, time)) %>% 
  gather( ts_type, value, -time)

ggplot(ts_3B, aes(x=time, y =value)) + 
  geom_line(aes(color = ts_type,
                linetype = ts_type), size = 1.5 )+
  scale_y_continuous(sec.axis=sec_axis(~.*comp, name="",
                                       labels = scales::comma),
                     limits=c(0, y_left),
                     labels = scales::comma)+
  scale_x_continuous( limits=c(0, t_lim))  +
  labs(color = "",
       title = "Infected (per mill.)",
       subtitle = "Recovered (per mill.)",
       y     = "",
       x     = "Time",
       color = "",
       linetype = ""
  ) +
  lockdown_theme2() +
  theme(
    plot.subtitle=element_text( margin=margin(0,0,5,0)))
ggsave("figure3B.pdf", width = 13.57, height=7.28)


#3C
fig3C <- readMat('figure3C_output.mat')
infected <- scaler*colMeans(fig3C[["infection.mat.3"]])
detected <- scaler*colMeans(fig3C[["detection.mat.3"]])
recovered <- scaler*colMeans(fig3C[["recovered.mat.3"]])/comp
ts_3C <- data.frame(cbind(infected, recovered, time)) %>% 
  gather( ts_type, value, -time)

ggplot(ts_3C, aes(x=time, y =value)) + 
  geom_line(aes(color = ts_type,
                linetype = ts_type), size = 1.5 )+
  scale_y_continuous(sec.axis=sec_axis(~.*comp, name="",
                                       labels = scales::comma),
                     limits=c(0, y_left),
                     labels = scales::comma)+
  scale_x_continuous( limits=c(0, t_lim))  +
  labs(color = "",
       title = "Infected (per mill.)",
       subtitle = "Recovered (per mill.)",
       y     = "",
       x     = "Time",
       color = "",
       linetype = ""
  ) +
  lockdown_theme2()  +
  theme(
     legend.position = c(0.85,0.65),
     plot.subtitle=element_text( margin=margin(0,0,5,0)))
ggsave("figure3C.pdf", width = 13.57, height=7.28)


#3D
fig3D <- readMat('figure3D_output.mat')
infected <- scaler*colMeans(fig3D[["infection.mat.4"]])
detected <- scaler*colMeans(fig3D[["detection.mat.4"]])
recovered <- scaler*colMeans(fig3D[["recovered.mat.4"]])/comp
ts_3D <- data.frame(cbind(infected, recovered, time)) %>% 
  gather( ts_type, value, -time)

ggplot(ts_3D, aes(x=time, y =value)) + 
  geom_line(aes(color = ts_type,
                linetype = ts_type), size = 1.5 )+
  scale_y_continuous(sec.axis=sec_axis(~.*comp, name="",
                                       labels = scales::comma),
                     limits=c(0, y_left),
                     labels = scales::comma)+
  scale_x_continuous( limits=c(0, t_lim))  +
  labs(color = "",
       title = "Infected (per mill.)",
       subtitle = "Recovered (per mill.)",
       y     = "",
       x     = "Time",
       color = "",
       linetype = ""
  ) +
  lockdown_theme2() +
  theme(
    plot.subtitle=element_text( margin=margin(0,0,5,0)))
ggsave("figure3D.pdf", width = 13.57, height=7.28)
                                      


## Figure 4
#4A
fig4A_1 <-readMat('figure3A_output.mat')
fig4A_2 <-readMat('figure3B_output.mat')
fig4A_3 <-readMat('figure3C_output.mat')
fig4A_4 <-readMat('figure3D_output.mat')

q1 <- colMeans(fig4A_1[["q.idx.1"]])/40
q2 <- colMeans(fig4A_2[["q.idx.2"]])/40
q3 <- colMeans(fig4A_3[["q.idx.3"]])/40
q4 <- colMeans(fig4A_4[["q.idx.4"]])/40

time <- 1:2500
ts_q <- data.frame(cbind(q1, q2, q3, q4, time)) %>% 
  gather( ts_type, value, -time) 

ts_q$ts_type = factor(ts_q$ts_type, 
                      levels = c("q1", "q2", "q3", "q4"),
                      labels = c("All Reactive", "All Proactive",
                                 "Reactive w/ lax neighbors",
                                 "Proactive w/ lax neighbors")
                      )

ggplot(ts_q, aes(x=time, y =value)) + 
  geom_line(aes(color = ts_type,
                linetype = ts_type), size = 1.5 )+
  scale_y_continuous(limits=c(0, 0.45))+
  xlim(0,1000) +
  labs(color = "",
       title = "Fraction of regions under quarantine",
       y     = "",
       x     = "Time",
       color = "",
       linetype = ""
  ) +
  lockdown_theme2() +
  theme(plot.subtitle=element_text( margin=margin(0,0,5,0))) +
  theme(legend.text=element_text(size=26, family="Times", ),
        legend.position = c(0.7,0.8))
ggsave("figure4A.pdf", width = 13.57, height=7.28)

#4B
fig4B_1 <- readMat("figure2D_output.mat")
fig4B_2 <- readMat("figure3A_output.mat")
fig4B_3 <- readMat("figure3B_output.mat")
fig4B_4 <- readMat("figure3C_output.mat")
fig4B_5 <- readMat("figure3D_output.mat")
fig4B_6 <- readMat("global_output.mat")

fig4B_1 <- c(mean(fig4B_1[["qpp.4"]]), mean(fig4B_1[["ipp.4"]]))
fig4B_2 <- c(mean(fig4B_2[["qpp.1"]]), mean(fig4B_2[["ipp.1"]]))
fig4B_3 <- c(mean(fig4B_3[["qpp.2"]]), mean(fig4B_3[["ipp.2"]]))
fig4B_4 <- c(mean(fig4B_4[["qpp.3"]]), mean(fig4B_4[["ipp.3"]]))
fig4B_5 <- c(mean(fig4B_5[["qpp.4"]]), mean(fig4B_5[["ipp.4"]]))
fig4B_6 <- c(mean(fig4B_6[["qpp.5"]]), mean(fig4B_6[["ipp.5"]]))

fig4B <- rbind(fig4B_1,fig4B_2,fig4B_3,fig4B_4,fig4B_5,fig4B_6)*1000000/140000

val <- 1:6
plot_4B <- data.frame(cbind(fig4B, val))

plot_4B$val = factor(plot_4B$val, levels = c(6,1,2,3,4,5),
                     labels = c("Single jurisdiction, global quarantine",
                                "Single jurisdiction, regional quarantine",
                                "Multiple jurisdictions, reactive", 
                                "Multiple jurisdictions, proactive", 
                                "Multiple jurisdictions, reactive \n w/ lax neighbors",
                                "Multiple jurisdictions, proactive \n w/ lax neighbors" ))


ggplot(plot_4B, aes(x=V1, y=V2, group=factor(val))) + 
  geom_point(aes(color=factor(val), shape=factor(val)), size=6)+
   labs(color="",
    x="Person-Days of Quarantine",
    title="Person-Days of Infection",
    y=""
  ) + 
  scale_x_log10(labels = scales::comma, breaks = c(2.5e6,
                                                   1.0e7,
                                                       5.0e7, 
                                                       1.5e8,
                                                   1.0e9),
                limits = c(-1,2e8)) +
  scale_y_continuous(labels = scales::comma, breaks = c(0,
                                                        5e5,
                                                        1e6,
                                                        1.5e6,
                                                        2e6,
                                                        2.5e6), 
                     limits = c(0,2e6)) +
  lockdown_theme2() +
  theme(legend.text=element_text(size=27, family="Times", ),
        legend.position = c(0.4,0.7),
        legend.box.background = element_rect(colour = "black"),
        legend.title = element_blank(),
        legend.spacing.y = unit(0, "mm"))+
  labs(color="",shape="") 
ggsave("figure4B.pdf", width = 13.57, height=7.28)


                                                