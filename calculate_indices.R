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



# #ProNet
# from Zhicong's presentation
# For a PA network in a landscape that includes n PA patches,the area of PA patch i was noted as a[i] (i= 1,2…. , n)
# the total area of the PA network was A[N]= sum over i ... n of a[i]
# total area of the landscape was A[L] 
# the distance between PA patch i and j was noted as d[ij](Euclidean, least-cost or resistance distance)
# the probability of direct dispersal between PA patch i and j was noted as p[ij]
# the maximum product probability of all possible paths between PA patch i and j (including single-steppaths) was noted as p*[ij]


# first, we are only interested in a specific landscape or study area
# which I think means we will loop through the study area polygons and select the areas 

# select a specific study area

focalstudyarea <- studyarea_polys[1,]

focalhmi <- crop(hmi_sim, focalstudyarea, mask=T)

focalpas <- crop(pa_polys, focalstudyarea)

plot(focalhmi)
plot(focalstudyarea, add=T)
plot(focalpas, add=T)
plot(focalpas[1:4], add=T, col="red")

# this gives us some distances
# need an alternative; terra currently reports distances in degrees
pairwise_distance_matrix <- terra::distance(focalpas[1:10])
plot(focalpas[1:10], add=T, col="red")

pairwise_distance_matrix

?terra::distance

?hclust

pronet = sum across all clusters of the normalized square areas in each cluster

normalized summed square area in a cluster = 
  
sum of the 

cluster_area
cluster_area_squared
sum_cluster_areas_squared
total_pa_area

# use package grainscape to divide up the landscape into clusters, uses resistance distance too.




