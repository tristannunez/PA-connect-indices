# #ProNet
# based on https://conbio.onlinelibrary.wiley.com/doi/10.1111/csp2.12823
# as currently written, CalculateProNetByStudyArea uses Euclidean Distance, not Ecological or Cost Distance
# requires
library(terra)
library(tidyverse)

# CalcProNetScore takes a vector of cluster names and a vector of polygon area and calculates the ProNet score
CalcProNetScore <- function(clustervector, areavector){

  df          <-  data.frame(clusters = clustervector,
                  areas = areavector)

  clustersums <-  df |>
                  group_by(clusters)|>
                  summarise(clusterareasum = sum(areas))
    
  ProNetScore <- sum(clustersums$clusterareasum^2)/sum(areavector)^2
}

########## calculate ProNet for each test study area

CalculateProNetByStudyArea <- function(study_areas,
                                       protected_areas,
                                       cost_raster,
                                       threshold_distance_m){
  for(sa in 1:length(study_areas)){
  focalstudyarea <- study_areas[sa,]
  plot(focalstudyarea)
  
  focalhmi <- crop(cost_raster, focalstudyarea, mask=T)
  focalpas <- crop(protected_areas, focalstudyarea)
  
  plot(focalhmi)
  plot(focalstudyarea, add=T)
  plot(focalpas, add=T)
  
  #buffer each pa by the distance threshold, then dissolve
  buffered_pas <- buffer(focalpas, width=threshold_distance_m)
  plot(focalpas, col="green")
  plot(buffered_pas,border="red",add=T)
  
  clusterboundaries <-  terra::aggregate(buffered_pas, dissolve=T) |>
    disagg()
  clusterboundaries$clustname <- paste0("cl",1:nrow(clusterboundaries))
  focalpas$clustname <- terra::extract(clusterboundaries, focalpas)$clustname
  text(focalpas, labels="clustname")
  pronetscore <- CalcProNetScore(clustervector=focalpas$clustname, areavector=focalpas$area_ha)
print(pronetscore)
  if(sa==1){
    pronetscores <- pronetscore
  }  else {
    pronetscores <- c(pronetscores, pronetscore)
  }

  }
  return(pronetscores)
}


