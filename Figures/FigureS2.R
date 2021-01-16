#import libraries and packages
library(tidyverse)
#install.packages("R.matlab")

library(R.matlab)
library(reshape2)
library(latex2exp)


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
    
    
    fig4B_1 <- readMat(connect("figure2/", in_path, "/figure2D_output.mat"))
    fig4B_2 <- readMat(connect("figure3/", in_path, "/figure3A_output.mat"))
    fig4B_3 <- readMat(connect("figure3/", in_path, "/figure3B_output.mat"))
    fig4B_4 <- readMat(connect("figure3/", in_path, "/figure3C_output.mat"))
    fig4B_5 <- readMat(connect("figure3/", in_path, "/figure3D_output.mat"))
    fig4B_6 <- readMat(connect("global_output/", in_path,"/global_output.mat"))
    fig4B_7 <- readMat(connect("kxv3/", in_path,"/figure2D_output.mat"))
    
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
                                  "Single jurisdiction, regional quarantine, known seed",
                                  "Single jurisdiction, regional quarantine, unknown seed",
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
      scale_shape_manual(values=1:nlevels(plot_4B$val)) +
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
      labs(color="",shape="") 
    ggsave(connect("figure4B_", in_path, ".pdf" ), plot = temp_fig + theme(legend.position = "none"), width = 13.57, height=7.28)
    
    if(in_path == "base"){
      legend <- g_legend(temp_fig)
      ggsave("figure4B_legend.pdf" , plot = legend, height = 3.25)
    }
}

file_paths <- c("base", "measles","long", "low", "flu", "smallpox", "flu", "high")

lapply(file_paths, make4b)






