source("~/SparkleShare/TIR/demo/tirSettings.R")
### Import df to spdf
hkdAG100df  <- readRDS("~/Share500sda/AG100B/hkdAG100B.Rds")
head(hkdAG100df)
hkdAG100spdf  <- hkdAG100df

coordinates(hkdAG100spdf)  <- ~Lon+Lat
proj4string(hkdAG100spdf)  <- wgs84GRS
setwd(dir.AG100B)
getwd()
### Subset spdf
hkdBoudary  <- readRDS
sub  <- hkdAG100spdf[hkdBoudary]
#phd.saveshp.geo(hkdAG100spdf)  ## This will take a lot of time
####sgdf Crop spdf using Vector
###
hkdAG100sgdfLSTm  <- vect2rast(hkdAG100spdf, fname = "LSTm", cell.size = 100)
summary(hkdAG100sgdfLSTm)
##mask
hkdAG100sgdfLSTmR  <- raster(hkdAG100sgdfLSTm)
hkdmaskb  <- readRDS("~/SparkleShare/TIR/hkdmskb_grdi2d1h.Rds")
proj4string(hkdmaskb)
LSTcrop  <- crop(hkdAG100sgdfLSTmR, hkdmaskb, filename = "hkdAG100sgdfLSTm.tif", overwrite=TRUE)

# plot(LSTcrop)
# proj4string(hkdAG100sgdfLSTmR)
# proj4string(hkdmaskb)
# extent(LSTcrop)
# extent(hkdmaskb)
LSTrsp  <- resample(LSTcrop, hkdmaskb)
LSTrsp2  <- resample(hkdAG100sgdfLSTmR, hkdmaskb)
compareRaster(LSTrsp, LSTrsp2)
extent(LSTrsp2)
extent(hkdmaskb)
plot(LSTrsp)
summary(LSTrsp)
LSTmask  <- mask(LSTrsp2, hkdmaskb, filename = "hkdAG100LSTmask.tif", overwrite=TRUE)
plot(LSTmask, zlim =c(252, 320))

levelplot(LSTmask, par.settings = BuRdTheme)

levelplot(LSTmask, par.settings = BuRdTheme, at  = seq(252,320, 2))
plotKML(LSTmask)
LSTCenter  <- scale(LSTmask, center = TRUE, scale = FALSE)
summary(LSTCenter)


#### rasterlize
plot(hkdmaskb)
proj4string(hkdmaskb)
extent(hkdmaskb)
hkdAG100rb  <- rasterize(hkdAG100spdf, hkdmaskb)

levelplot(hkdAG100rb)
plot(hkdAG100rb)
class(hkdAG100r)
saveRDS(hkdAG100r, file = "hkdAG100Br.Rds")
hkdAG100rb[[1]]
