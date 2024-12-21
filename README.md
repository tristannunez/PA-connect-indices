# PA-connect-indices
A collection of R scripts to calculate connectivity indices for protected areas. 

Status as of 12/20/2024:

script1_generate_sandbox.R sets up a set of data layers that we can use to develop these functions until we figure out the details of which PA database and modification index will be used.These layers are:
1) a gradient raster that ranges from 0 to 1 that can be used as a fake human modification index, using a WGS 84 CRS (ie, global, lat/long)
2) randomly located smaller circles scattered globally to be protected areas
3) randomly located larger circles to be study areas

script2_sandbox_test_indices_calcs.R then uses these data to test functions for calculating the protected area connectivity indices

script2_sandbox_test_indices_calcs.R sources separate R scripts with functions to test. Currently, these are the function scripts that are available to test in script2_sandbox_test_indices_calcs.R:

1) calculate_pronet.R
2) 
(add others here as they are developed)


