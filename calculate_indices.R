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

# generate simulated human modification index raster
hmi_sim <- rast(nrows=500, ncols = 500, vals = (1:(500*500))/(500*500), crs = "EPSG:4326")

# generate simulated protected area centroids
pa_polys <- spatSample(hmi_sim, size=200, xy=T) |>
            vect(geom=c("x", "y")) |>
            buffer(width=5)

# generate simulated protected area centroids
studyarea_polys <- spatSample(hmi_sim, size=5, xy=T) |>
            vect(geom=c("x", "y")) |>
            buffer(width=50)

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



