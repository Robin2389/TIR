#' clip a data frame by a xmin, xmax
# dsubd  <- function(data, sub){
#         out  <- list() # a list of dataframe
#         for (i in 1:nrow(sub)){
#                 xmin  <- sub[i,]$xmin
#                 xmax  <- sub[i,]$xmax
#                 ymin  <- sub[i,]$ymin
#                 ymax  <- sub[i,]$ymax
#                 out[[i]]  <-  data[x >= xmin & x <= xmax & y  >= ymin & y <= ymax,]
#         }
#         return(out)
#
# }
source("~/SparkleShare/TIR/demo/tirSettings.R")
#setwd(dir.toaTbKlccCenterMos)
setwd("~/toaTbKlccCenterMos/")
mos  <- raster("L8B10CenterMos.tif")
mos.spdf  <- rasterToPoints(mos, spatial=TRUE)
mos.df  <- as.data.frame(mos.spdf)
names(mos.df)  <- c("x", "y", "tCenter")
head(mos.df)

d  <- as.data.frame(rbind(c(41.92, 140.87),
                          c(42.23, 139.92),
                          c(42.78, 141.31),
                          c(43.47, 144.16)))
names(d)  <- c("lat", "lon")
dlcc  <- ge.crsTransform(d, lon, lat, xlcc, ylcc, wgs84GRS,lccWgs84)
rad  <- 4000
dlcc$xmin  <- round(dlcc$xlcc, -3) -rad
dlcc$xmax  <- round(dlcc$xlcc, -3) +rad
dlcc$ymin  <- round(dlcc$ylcc, -3) -rad
dlcc$ymax  <- round(dlcc$ylcc, -3) +rad
dlcc$id  <- 1:nrow(dlcc)


small  <- function(){
        data  <- mos.df
        sub  <- dlcc
        out  <- list() # a list of dataframe
        for (i in 1:nrow(sub)){
                xmin  <- sub[i,]$xmin
                xmax  <- sub[i,]$xmax
                ymin  <- sub[i,]$ymin
                ymax  <- sub[i,]$ymax
                x  <- data$x
                y  <- data$y
                out[[i]]  <-  data[x >= xmin & x <= xmax & y  >= ymin & y <= ymax,]
        }
        return(out)

}

clipper.l  <- small()

names(clipper.l)  <- c("a", "b", "c", "d")
str(clipper.l)
#dfs <- lapply(clipper.l, get)
clipper.df  <- do.call(rbind, clipper.l)
clipper.df$id  <- as.factor(substr(row.names(clipper.df),1,1))
# summary(clipper.df)
# ggplot(clipper.df,aes(x,y, fill = tCenter)) + geom_point() +
# facet_wrap(~ id)
cols = oceColorsJet(10)
col.brks  <- seq(-20, 20, 2)
col.labs  <- as.character(colbrks)
grobs  <- lapply(clipper.l, function(d) {
        ggplot(d) +
        geom_raster(aes(x,y, fill = tCenter)) +
        scale_x_continuous(labels = function(x) x/1000) +
        scale_y_continuous(labels = function(x) x/1000) +
        xlab("x (km)") +
        ylab("y (km)") +
        scale_fill_gradientn(colours = cols,
                             na.value="white",
                             breaks = col.brks,
                             labels = col.labs,
                             name = expression(~(degree*C))) +
                theme_bw(base_size = 12, base_family = "Times") +
                coord_equal() # +
                #theme(axis.title.y = element_blank())

        })

#library(gridExtra)
# tiff("clipper.tiff", h = 2000, w = 2000, res = 300)
# png("clipper.png")
# do.call(grid.arrange, c(grobs, nrow =2))

### Better
grid.newpage()
grid.draw(rbind(
        cbind(ggplotGrob(grobs[[1]]), ggplotGrob(grobs[[2]]), size="last"),
        cbind(ggplotGrob(grobs[[3]]), ggplotGrob(grobs[[4]]), size="last"),
        size = "last"))
# Extracxt the legend from p1 !!!but that is just for p1
# legend = gtable_filter(ggplot_gtable(ggplot_build(grobs[[1]])), "guide-box")
#
# grid.draw(legend)    # Make sure the legend has been extracted
# grid.newpage()
# # Arrange and draw the plot as before
# grid.arrange(arrangeGrob(grobs[[1]] + theme(legend.position="none"),
#                          grobs[[2]] + theme(legend.position="none"),
#                          grobs[[3]] + theme(legend.position="none"),
#                          grobs[[4]] + theme(legend.position="none"),
#                          nrow = 2,
#                          main = textGrob("Main Title", vjust = 1, gp = gpar(fontface = "bold", cex = 1.5)),
#                          left = textGrob("Global Y-axis Label", rot = 90, vjust = 1)),
#              legend,
#              widths=unit.c(unit(1, "npc") - legend$width, legend$width),
#              nrow=1)
#dev.off()
# set.seed(1011)
# x  <- rnorm(100,mean  =50, sd = 25)
# y  <- rnorm(100,mean  =50, sd = 25)
# data  <- as.data.frame(cbind(x,y))
# data
# ### get rectangle map
# sub  <- data.frame(rbind(c(20,60,30,70),
#                          c(80,90,80,90)))
# sub
# names(sub)  <- c("xmin","xmax","ymin","ymax")
# library(ggplot2)
# g1  <- ggplot(data) + geom_point(aes(x =x,y =y)) +
#         geom_rect(data = sub, aes(xmin= xmin, xmax =xmax, ymin = ymin, ymax =ymax),
#                   col ="red", fill = NA)
#
# # subset
# g1 + xlim(80,90) + ylim(80,90)
# g1 + scale_x_continuous(limits = c(80, 90)) + scale_y_continuous(limits = c(80, 90))
# ## zoom out
# g1 + coord_cartesian(xlim = c(80,90), ylim = c(80,90))
# # subdata
# out  <- dsubd(data,sub)
# lapply(out,class)
# library(gridExtra)
# gl  <- lapply(out, function(df){
#         ggplot(df) + geom_point(aes(x =x,y =y))
# })
# do.call(grid.arrange, c(gl, list(ncol = 2)))
#

