#import libraries and packages
library(tidyverse)
#install.packages("R.matlab")

library(R.matlab)
library(reshape2)
library(latex2exp)
library(cowplot)


#overall theme
lockdown_theme2 <- function() {theme_minimal() %+replace%
    theme(panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(),
          panel.background = element_blank(), 
          axis.line = element_line(colour = "grey"),
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


##Figure S2
connect <- function(..., sep='') {
  paste(..., sep=sep, collapse=sep)
}


g_legend<-function(a.gplot){
  tmp <- ggplot_gtable(ggplot_build(a.gplot))
  leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box")
  legend <- tmp$grobs[[leg]]
  legend
}

make4b <- function(in_path){
  
    if (in_path == "base"){
      title_base = TeX("$\\theta = 5$, $\\tau = 3$, $\\alpha = 0.1$, $R_0 = 3.5$")
    }else if(in_path == "low"){
      title_base = TeX("$\\theta = 5$, $\\tau = 3$, $\\alpha = 0.05$, $R_0 = 3.5$")
    } else if(in_path == "long"){
      title_base = TeX("$\\theta = 8$, $\\tau = 5$, $\\alpha = 0.1$, $R_0 = 3.5$")
    } else if(in_path == "high"){
      title_base = TeX("$\\theta = 5$, $\\tau = 3$, $\\alpha = 0.2$, $R_0 = 3.5$")
    } else if(in_path == "flu"){
      title_base = TeX("$\\theta = 5$, $\\tau = 3$, $\\alpha = 0.1$, $R_0 = 2.0$")
    } else if(in_path == "measles"){
      title_base = TeX("$\\theta = 5$, $\\tau = 3$, $\\alpha = 0.1$, $R_0 = 15.0$")
    } else{
      title_base = TeX("$\\theta = 5$, $\\tau = 3$, $\\alpha = 0.1$, $R_0 = 5.0$")
    }
    
    
    fig4B_1 <- readMat(connect("../Figure2_Output/", in_path, "/figure2D_output.mat"))
    fig4B_2 <- readMat(connect("../Figure3_Output/", in_path, "/figure3A_output.mat"))
    fig4B_3 <- readMat(connect("../Figure3_Output/", in_path, "/figure3B_output.mat"))
    fig4B_4 <- readMat(connect("../Figure3_Output/", in_path, "/figure3C_output.mat"))
    fig4B_5 <- readMat(connect("../Figure3_Output/", in_path, "/figure3D_output.mat"))
    fig4B_6 <- readMat(connect("../Global_Output/", in_path,"/global_output.mat"))
    fig4B_7 <- readMat(connect("../Figure2_Unknown_Output/", in_path,"/figure2D_output.mat"))
    
    fig4B_1 <- c(mean(fig4B_1[["qpp.4"]]), mean(fig4B_1[["ipp.4"]]))
    fig4B_2 <- c(mean(fig4B_2[["qpp.1"]]), mean(fig4B_2[["ipp.1"]]))
    fig4B_3 <- c(mean(fig4B_3[["qpp.2"]]), mean(fig4B_3[["ipp.2"]]))
    fig4B_4 <- c(mean(fig4B_4[["qpp.3"]]), mean(fig4B_4[["ipp.3"]]))
    fig4B_5 <- c(mean(fig4B_5[["qpp.4"]]), mean(fig4B_5[["ipp.4"]]))
    fig4B_6 <- c(mean(fig4B_6[["qpp.5"]]), mean(fig4B_6[["ipp.5"]]))
    fig4B_7 <- c(mean(fig4B_7[["qpp.4"]]), mean(fig4B_7[["ipp.4"]]))
    
    
    fig4B <- rbind(fig4B_1,fig4B_2,fig4B_3,fig4B_4,fig4B_5,fig4B_6, fig4B_7)*1000000/140000
  
    val <- 1:7
    plot_4B <- data.frame(cbind(fig4B, val))
  
    plot_4B$val = factor(plot_4B$val, levels = c(6,1,7,2,3,4,5),
                       labels = c("Single jurisdiction, global quarantine",
                                  "Single jurisdiction, (3,1) regional quarantine, known seed",
                                  "Single jurisdiction, (3,1) regional quarantine, unknown seed",
                                  "Multiple jurisdictions, reactive", 
                                  "Multiple jurisdictions, proactive", 
                                  "Multiple jurisdictions, reactive w/ lax neighbors",
                                  "Multiple jurisdictions, proactive w/ lax neighbors" ))
  
  
    temp_fig <- ggplot(plot_4B, aes(x=V1, y=V2, group=factor(val))) + 
      geom_point(aes(color=factor(val), shape=factor(val)), size=6)+
       labs(color="",
        x="Person-Days of Quarantine",
        title=title_base,
        y="Person-Days of Infection"
      ) + 
      scale_x_continuous(labels = scales::comma, 
                         breaks = c(1.0e7, 1.0e8, 2.0e8),
                         limits  = c(-1,2.2e8))+
      scale_y_continuous(labels = scales::comma, 
                         breaks = c(0,1.0e6, 2.0e6, 3.0e6, 4.0e6, 5.0e6),
                         limits = c(-1,4.5e6)) +
      lockdown_theme2() +
      theme(legend.text=element_text(size=22),
            legend.position = c(0.5,0.5),
            legend.box.background = element_rect(colour = "black"),
            legend.title = element_blank(),
            legend.spacing.y = unit(0, "mm"))+
      labs(color="",shape="") + 
      scale_shape_manual(values = c(19, 17, 4, 15, 3, 7, 8))
    ggsave(connect("figureS2_", in_path, ".pdf" ), plot = temp_fig + theme(legend.position = "none"), width = 13.57, height=7.28)
    
    if(in_path == "base"){
      legend <- g_legend(temp_fig)
      save_plot("figureS2_legend.pdf" , plot = legend, base_width = 10)
    }
}

file_paths <- c("base", "measles","long", "low", "flu", "smallpox", "flu", "high")

lapply(file_paths, make4b)

lapply("base", make4b)

#Figure S3 overall parameters
scaler <- 1000000/140000
t_lim <-800
y_left <- 5000
y_right <- 300000
comp <- y_right/y_left
infection_color="#002bff"
detection_color="#ff0000"
recovered_color="#000000"

#2A
fig2A <- readMat('../Figure2_output/smallrad/figure2A_output.mat')
infected <- scaler*colMeans(fig2A[["infection.mat.1"]])
detected <- scaler*colMeans(fig2A[["detection.mat.1"]])
recovered <- scaler*colMeans(fig2A[["recovered.mat.1"]])/comp
time <- 1:1500
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

ggsave("figure2A_smallrad.pdf", width = 13.57, height=7.28)

fig2B <- readMat('../Figure2_output/smallrad/figure2B_output.mat')
infected <- scaler*colMeans(fig2B[["infection.mat.2"]])
detected <- scaler*colMeans(fig2B[["detection.mat.2"]])
recovered <- scaler*colMeans(fig2B[["recovered.mat.2"]])/comp
time <- 1:1500
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
  lockdown_theme2() +
  theme(
    legend.position = c(0.85,0.65))
ggsave("figure2B_smallrad.pdf", width = 13.57, height=7.28)


fig2D <- readMat('../Figure2_output/smallrad/figure2D_output.mat')
infected <- scaler*colMeans(fig2D[["infection.mat.4"]])
detected <- scaler*colMeans(fig2D[["detection.mat.4"]])
recovered <- scaler*colMeans(fig2D[["recovered.mat.4"]])/comp
time <- 1:1500
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

ggsave("figure2D_smallrad.pdf", width = 13.57, height=7.28)


## Figure S4
in_path <- "base"
fig4B_1 <- readMat(connect("../Figure2_Output/", in_path, "/figure2D_output.mat"))
fig4B_2 <- readMat(connect("../Figure3_Output/", in_path, "/figure3A_output.mat"))
fig4B_3 <- readMat(connect("../Figure3_Output/", in_path, "/figure3B_output.mat"))
fig4B_4 <- readMat(connect("../Figure3_Output/", in_path, "/figure3C_output.mat"))
fig4B_5 <- readMat(connect("../Figure3_Output/", in_path, "/figure3D_output.mat"))
fig4B_6 <- readMat(connect("../Global_Output/", in_path,"/global_output.mat"))
fig4B_7 <- readMat(connect("../Figure2_Unknown_Output/", in_path,"/figure2D_output.mat"))
fig4B_8 <- readMat("../Figure2_Output/smallrad/figure2D_output.mat")
fig4B_9 <- readMat("../Figure2_Unknown_Output/smallrad/figure2D_output.mat")


fig4B_1 <- c(mean(fig4B_1[["qpp.4"]]), mean(fig4B_1[["ipp.4"]]))
fig4B_2 <- c(mean(fig4B_2[["qpp.1"]]), mean(fig4B_2[["ipp.1"]]))
fig4B_3 <- c(mean(fig4B_3[["qpp.2"]]), mean(fig4B_3[["ipp.2"]]))
fig4B_4 <- c(mean(fig4B_4[["qpp.3"]]), mean(fig4B_4[["ipp.3"]]))
fig4B_5 <- c(mean(fig4B_5[["qpp.4"]]), mean(fig4B_5[["ipp.4"]]))
fig4B_6 <- c(mean(fig4B_6[["qpp.5"]]), mean(fig4B_6[["ipp.5"]]))
fig4B_7 <- c(mean(fig4B_7[["qpp.4"]]), mean(fig4B_7[["ipp.4"]]))
fig4B_8 <- c(mean(fig4B_8[["qpp.4"]]), mean(fig4B_8[["ipp.4"]]))
fig4B_9 <- c(mean(fig4B_9[["qpp.4"]]), mean(fig4B_9[["ipp.4"]]))



fig4B <- rbind(fig4B_1,fig4B_2,fig4B_3,fig4B_4,fig4B_5,fig4B_6, fig4B_7, fig4B_8, fig4B_9)*1000000/140000

val <- 1:9
plot_4B <- data.frame(cbind(fig4B, val))

plot_4B$val = factor(plot_4B$val, levels = c(6,1,7,8,9,2,3,4,5),
                     labels = c("Single jurisdiction, global quarantine",
                                "Single jurisdiction, (3,1) regional quarantine, known seed",
                                "Single jurisdiction, (3,1) regional quarantine, unknown seed",
                                "Single jurisdiction, (2,1) regional quarantine, known seed",
                                "Single jurisdiction, (2,1) regional quarantine, unknown seed",
                                "Multiple jurisdictions, reactive", 
                                "Multiple jurisdictions, proactive", 
                                "Multiple jurisdictions, reactive w/ lax neighbors",
                                "Multiple jurisdictions, proactive w/ lax neighbors" ))


ggplot(plot_4B, aes(x=V1, y=V2, group=factor(val))) + 
  geom_point(aes(color=factor(val), shape=factor(val)), size=6)+
  labs(color="",
       x="Person-Days of Quarantine",
       y="Person-Days of Infection"
  ) + 
  scale_x_continuous(labels = scales::comma, 
                     breaks = c(1.0e7, 1.0e8, 1.5e8),
                     limits  = c(-1,1.6e8))+
  scale_y_continuous(labels = scales::comma, 
                     breaks = c(0,5.0e5, 1.0e6, 1.5e6, 2.0e6),
                     limits = c(-1,2e6)) +
  lockdown_theme2() +
  theme(legend.text=element_text(size=22),
        legend.position = "bottom",
        legend.direction = "vertical",
        legend.box.background = element_rect(colour = "black"),
        legend.title = element_blank(),
        legend.spacing.y = unit(0, "mm"))+
  labs(color="",shape="") + 
  scale_shape_manual(values = c(19, 17, 4, 13, 10,15, 3, 7, 8)) + 
ggsave("figureS4.pdf", width = 13.57, height=9.28)

