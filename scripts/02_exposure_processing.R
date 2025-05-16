library(terra)

# 1. Load wind raster to use as reference
wind <- rast("data/exposure/population_2021.tif")

# 2. Load the Eurostat population raster
pop_raw <- rast("data/exposure/ESTAT_OBS-VALUE-POPULATED_2021_V2.tiff")

# 3. Reproject if CRS doesn’t match
pop_proj <- project(pop_raw, crs(wind))

# 4. Resample to match resolution & extent
pop <- resample(pop_proj, wind, method = "bilinear")

# 5. Save final population exposure raster
writeRaster(pop, "data/exposure/population_2020-2024.tif", overwrite = TRUE)

# 6. Plot to check
plot(pop, main = "Population Exposure (2021)", col = heat.colors(25))
