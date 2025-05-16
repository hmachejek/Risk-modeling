# Load libraries
library(terra)
library(sf)
library(ggplot2)
library(rnaturalearth)
library(rnaturalearthdata)

# 0. Create output folder if missing
if (!dir.exists("data/risk")) dir.create("data/risk", recursive = TRUE)

# 1. Load input rasters
wind <- rast("data/hazard/wind_avg_europe_2020_2024.tif")
pop  <- rast("data/exposure/population_2021.tif")

# 2. Calculate raw risk
risk <- wind * pop
writeRaster(risk, "data/risk/risk_map_2020_2024.tif", overwrite = TRUE)

# 3. Normalize risk (0–1 scale)
risk_norm <- risk / global(risk, fun = "max", na.rm = TRUE)[1, 1]
writeRaster(risk_norm, "data/risk/risk_map_2020_2024_norm.tif", overwrite = TRUE)

# 4. Classify risk into 3 levels
risk_classes <- classify(risk_norm,
                         rcl = matrix(c(0, 0.33, 1,
                                        0.33, 0.66, 2,
                                        0.66, 1, 3),
                                      ncol = 3, byrow = TRUE),
                         include.lowest = TRUE)

# 5. Save classified raster
writeRaster(risk_classes, "data/risk/risk_map_2020_2024_classes.tif", overwrite = TRUE)

# 🔍 Confirm the file was saved
if (!file.exists("data/risk/risk_map_2020_2024_classes.tif")) {
  stop("🛑 File not saved! Check your folder path or write permissions.")
}

# 6. Convert raster to dataframe for plotting
risk_df <- as.data.frame(risk_classes, xy = TRUE)
colnames(risk_df) <- c("lon", "lat", "risk_class")
risk_df$risk_class <- factor(risk_df$risk_class, levels = c(1, 2, 3), labels = c("Low", "Medium", "High"))

# 7. Load country borders
countries <- ne_countries(scale = "medium", returnclass = "sf")

# 8. Define muted color palette
muted_risk_colors <- c(
  "Low" = "#A3B18A",     # Muted green
  "Medium" = "#D4A74E",  # Mustard yellow
  "High" = "#B85C5C"     # Muted brick red
)

# 9. Build the ggplot map
risk_map <- ggplot() +
  geom_raster(data = risk_df, aes(x = lon, y = lat, fill = risk_class)) +
  scale_fill_manual(values = muted_risk_colors, name = "Risk Level") +
  geom_sf(data = countries, fill = NA, color = "gray40", size = 0.3) +
  coord_sf(xlim = c(-10, 30), ylim = c(35, 65), expand = FALSE) +
  scale_x_continuous(
    breaks = seq(-10, 30, 5),
    labels = function(x) ifelse(x < 0, paste0(abs(x), "°W"), paste0(x, "°E"))
  ) +
  scale_y_continuous(
    breaks = seq(35, 65, 5),
    labels = function(x) paste0(x, "°N")
  ) +
  labs(
    title = "Storm Risk Map (2020–2024)",
    subtitle = "Classified by normalized risk = hazard × exposure"
  ) +
  theme_minimal(base_size = 13) +
  theme(
    panel.grid.major = element_line(color = "gray90"),
    axis.text = element_text(color = "gray20"),
    axis.title = element_blank(),
    plot.title = element_text(face = "bold"),
    legend.position = "right"
  )

# 10. Display the map
print(risk_map)

# 11. Save as PNG (for your Shiny app or portfolio)
ggsave("data/risk/risk_map_2020_2024_classified.png", plot = risk_map, width = 10, height = 7, dpi = 300)
