library(terra)


years <- 2020:2024
files <- paste0("data/hazard/TerraClimate_ws_", years, ".nc")
europe_bbox <- ext(-10, 30, 35, 65)


cropped_files <- c()

for (i in seq_along(files)) {
  r <- rast(files[i])
  rc <- crop(r, europe_bbox)
  path <- paste0("data/hazard/cropped_ws_", years[i], ".tif")
  writeRaster(rc, path, overwrite = TRUE)
  cropped_files <- c(cropped_files, path)
}


wind_stack <- rast(cropped_files)
wind_avg_5yr <- mean(wind_stack)


writeRaster(wind_avg_5yr, "data/hazard/wind_avg_europe_2020_2024.tif", overwrite = TRUE)


plot(wind_avg_5yr, main = "Avg Wind Speed (2020–2024)", col = terrain.colors(25))
