# 2024.12.19
# This will be an R script.

#' list of dependencies: 
#' terra
#' sf 
#' gdistance ??

install.packages("terra")
library(terra)
install.packages("sf")
library(sf)

# set up sandbox
library(terra)

# specify variables
number_pas <- 200
number_studyareas <- 5

# generate simulated human modification index raster
hmi_sim <- rast(nrows=500, ncols = 500, vals = (1:(500*500))/(500*500), crs = "EPSG:4326")

# generate simulated protected areas
pa_polys <- spatSample(hmi_sim, size=number_pas, xy=T, crs=) |>
            vect(geom=c("x", "y")) |>
            buffer(width=5)
crs(pa_polys) <- "EPSG:4326"
# name the pas
pa_polys$paname <- paste("pa", 1:number_pas, sep="")
# clip to within lat long extent
pa_polys <- terra::crop(pa_polys, ext(hmi_sim))


# calculate area
pa_polys$area_ha <- terra::expanse(pa_polys, unit="ha")

# generate simulated protected area centroids
studyarea_polys <- spatSample(hmi_sim, size=number_studyareas, xy=T) |>
            vect(geom=c("x", "y")) |>
            buffer(width=50)
crs(studyarea_polys) <- "EPSG:4326"
# clip to within lat long extent
studyarea_polys <- terra::crop(studyarea_polys, ext(hmi_sim))

# calculate area
studyarea_polys$area_ha <- terra::expanse(studyarea_polys, unit="ha")

# plot to check
plot(hmi_sim)
plot(pa_polys, add=T)
plot(studyarea_polys, add=T, border="red")

# write out datasets
terra::writeRaster(hmi_sim, "./sim_data/hmi_sim.tif")
terra::writeVector(pa_polys, "./sim_data/pa_sim.shp")
terra::writeVector(studyarea_polys, "./sim_data/studyareas_sim.shp")

