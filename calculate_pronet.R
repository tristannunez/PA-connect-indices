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

# read in datasets
hmi_sim <- rast("./sim_data/hmi_sim.tif")
pa_polys <- vect("./sim_data/pa_sim.shp")
studyarea_polys <- vect("./sim_data/studyareas_sim.shp")

focalstudyarea <- studyarea_polys[1,]
focalhmi <- crop(hmi_sim, focalstudyarea, mask=T)
focalpas <- crop(pa_polys, focalstudyarea)

plot(focalhmi)
plot(focalstudyarea, add=T)
plot(focalpas, add=T)
# temp subset
focalpas <- focalpas[1:10]
plot(focalpas[1:10], add=T, col="red")

#so, you could just buffer each pa by the distance threshold, then dissolve

buffered_pas <- buffer(focalpas[1:10], width=100000)
plot(focalpas[1:10], col="green")
plot(buffered_pas[1:10],border="red",add=T)

clusterboundaries <-  terra::aggregate(buffered_pas, dissolve=T) |>
                      disagg()
clusterboundaries$clustname <- paste0("cl",1:nrow(clusterboundaries))
clusterboundaries

focalpas$clustname <- terra::extract(clusterboundaries, focalpas)$clustname

text(focalpas, labels="clustname")

# ok ... clustered!
# now just need to add up areas by cluster


