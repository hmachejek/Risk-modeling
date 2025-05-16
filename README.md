# Storm Risk Modeling in Europe (2020–2024)

This project simulates storm hazard exposure and resulting risk across Europe using open-access climate and population data. It was built as a portfolio project to demonstrate catastrophe modeling and spatial data visualization skills in R.

# Project Overview

- Hazard: Average wind speed (2020–2024) from [TerraClimate](http://www.climatologylab.org/terraclimate.html)
- Exposure: Population density from [Eurostat GEOSTAT 2021 1km grid](https://ec.europa.eu/eurostat/web/gisco/geodata/population-distribution/geostat)
- Risk = Hazard × Exposure
- Risk values normalized, classified into 3 levels: **Low**, **Medium**, **High**

## File Structure
```

├── risk/
│ ├── risk_map_2020_2024.tif # Raw risk raster
│ ├── risk_map_2020_2024_norm.tif # Normalized (0–1)
│ ├── risk_map_2020_2024_classes.tif # Classified risk raster
│ └── risk_map_2020_2024_classified.png # Final map
├── data/
│ ├── hazard/ # Wind input rasters
│ └── exposure/ # Population raster
├── scripts/
│ ├── 01_hazard_processing.R # Wind speed rasters processing script
│ ├── 02_exposure_processing.R # Population raster processing script
│ └── 03_risk_model.R # Full risk processing script
└── README.md
```
Not all input rasters are available in the repository due to the file size. If needed feel free to contact.
# Packages

- `terra` for raster math and export
- `ggplot2` for map design
- `rnaturalearth` for basemaps
- `sf` for vector borders


# Author

Created by Hanna Machejek – Master's Student in Geohazards & Climate Change  
GitHub: hmachejek

# License

MIT License — free to adapt and share


