# this script tests the functions on the sandbox test data
#
library(terra)
library(tidyverse)

# read in datasets
hmi_sim <- rast("./sim_data/hmi_sim.tif")
pa_polys <- vect("./sim_data/pa_sim.shp")
studyarea_polys <- vect("./sim_data/studyareas_sim.shp")
# plot datasets
plot(hmi_sim)
plot(studyarea_polys, add=T)
plot(pa_polys, add=T)


####################################################################3
# test ProNet code
source("./calculate_pronet.R")
# as currently written, CalculateProNetByStudyArea uses Euclidean Distance, not Ecological or Cost Distance
pronetscores <- CalculateProNetByStudyArea(study_areas=studyarea_polys,
                                           protected_areas = pa_polys,
                                           cost_raster=  hmi_sim,
                                           threshold_distance_m= 50000)

studyarea_polys$pronet <- signif(pronetscores, 2)
plot(hmi_sim)
plot(studyarea_polys, add=T)
plot(pa_polys, add=T)
text(studyarea_polys, labels="pronet")

#######################################################################
# test ProtConn code


#######################################################################
# test PCland code



