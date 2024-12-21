# 2024.12.19
# This script generates
# 1) a gradient raster that ranges from 0 to 1 that can be used as a fake human modification index, using a WGS 84 CRS (ie, global, lat/long)
# 2) randomly located smaller circles scattered globally to be protected areas
# 3) randomly located larger circles to be study areas
# script2_sandbox_test_indices_calcs.R then uses these data to test functions for calculating the protected area connectivity indices

#' list of dependencies: 
library(terra)
library(sf)

# specify variables
number_pas <- 400 # number of protected areas
size_pas <- c(1,2,3,4,5) # size in degrees (?); this vector generates various sizes
number_studyareas <- 10 # number of study areas

# generate simulated human modification index raster
hmi_sim <- rast(nrows=500, ncols = 500, vals = (1:(500*500))/(500*500), crs = "EPSG:4326")

# generate simulated protected areas
pa_polys <- spatSample(hmi_sim, size=number_pas, xy=T) |>
            vect(geom=c("x", "y")) |>
            buffer(width=size_pas) |>
            terra::aggregate(dissolve=T) |>
            terra::disagg()
crs(pa_polys) <- "EPSG:4326"
# name the pas
pa_polys$paname <- paste("pa", 1:number_pas, sep="")
# clip to within lat long extent
pa_polys <- terra::crop(pa_polys, ext(hmi_sim))

plot(pa_polys)

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
terra::writeRaster(hmi_sim, "./sim_data/hmi_sim.tif", overwrite = T)
terra::writeVector(pa_polys, "./sim_data/pa_sim.shp", overwrite = T)
terra::writeVector(studyarea_polys, "./sim_data/studyareas_sim.shp", overwrite = T)

