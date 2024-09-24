#This is a script that primary visualizes the RoG results out of ./prepare_RoG.sh
#
#copyright (c) 2024 - Emadeldin M. Ibrahim
#
#last modified Sep, 2024
#First written Sep, 2024

setwd("C:/Users/Imad/Desktop/MDS/data/XVG_PR/RoG")
#==================================================
read_and_assign_rog_files <- function() {
  # Get all CSV files starting with 'rog' in the current directory
  rog_files <- list.files(pattern = "^gyrate.*\\.csv$")
  
  # Check if any files are found
  if (length(rog_files) == 0) {
    stop("No RoG files found in the directory.")
  }
  
  # Initialize an empty list to store data frames
  data_list <- list()
  
  # Loop through the files, read them, rename columns, and store in the list
  for (file in rog_files) {
    # Print the filename to track progress
    message(paste("Reading file:", file))
    
    # Read the CSV file
    data <- read.csv(file)
    
    # Convert Time from ps to ns (divide by 1000)
    data[, 1] <- data[, 1] / 1000
    
    # Rename the columns to 'Time(ns)' and 'ROG(nm)'
    colnames(data) <- c("Time(ns)", "ROG(nm)")
    
    # Store the dataframe in the list using the file name (without .csv) as the list element name
    data_list[[gsub(".csv", "", file)]] <- data
    
    # Display the first few rows of the dataframe
    print(head(data))
  }
  
  # Loop through the data_list and assign each dataframe to an individual variable
  for (name in names(data_list)) {
    assign(name, data_list[[name]], envir = .GlobalEnv)  # Assign to global environment
  }
}

# Call the function to read the files and create individual variables
read_and_assign_rog_files()
head(gyrate_PRalone)
head(gyrate_PRaso)
head(gyrate_PRprog)
head(gyrate_PRm71)
head(gyrate_PRm49)

# Load required libraries
library(ggplot2)
library(dplyr)

# Combine all datasets into one, adding a 'State' column to identify each dataset
gyrate_combined <- bind_rows(
  mutate(gyrate_PRaso, State = "ASO"),
  mutate(gyrate_PRm49, State = "MA1449"),
  mutate(gyrate_PRm71, State = "MA1471"),
  mutate(gyrate_PRprog, State = "PROG"),
  mutate(gyrate_PRalone, State = "PR")
)

# Combined Plot (same as before)
p_combined <- ggplot() +
  geom_line(data = gyrate_combined, aes(x = `Time(ns)`, y = `ROG(nm)`, color = State), size = 1, alpha = 0.7) +
  theme_classic() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
    axis.title.x = element_text(size = 12, face = "bold"),
    axis.title.y = element_text(size = 12, face = "bold"),
    axis.text.x = element_text(size = 10, face = "bold"),
    axis.text.y = element_text(size = 10, face = "bold"),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    legend.position = c(0.5, 0.85),
    legend.justification = c(0.5, 0.5),
    legend.title = element_blank(),
    legend.text = element_text(size = 10, face = "bold")
  ) +
  labs(
    title = "RoG Plot",
    x = "Time (ns)",
    y = "RoG (nm)"
  ) +
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0), breaks = seq(1.8, 2, by = 0.02), limits = c(1.8, 2)) +
  scale_color_manual(values = c(
    "ASO" = "steelblue",
    "MA1449" = "tomato",
    "MA1471" = "darkorange",
    "PROG" = "forestgreen",
    "PR" = "purple"
  )) +
  guides(color = guide_legend(nrow = 5, byrow = TRUE))

print(p_combined)

# Split Plot with Separate Panels (using facet_wrap)
p_split <- ggplot(gyrate_combined, aes(x = `Time(ns)`, y = `ROG(nm)`)) +
  geom_line(aes(color = State), size = 1, alpha = 0.7) +
  theme_classic() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
    axis.title.x = element_text(size = 12, face = "bold"),
    axis.title.y = element_text(size = 12, face = "bold"),
    axis.text.x = element_text(size = 10, face = "bold"),
    axis.text.y = element_text(size = 10, face = "bold"),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    legend.position = "none"  # Remove the legend for the split plot
  ) +
  labs(
    title = "RoG Plot",
    x = "Time (ns)",
    y = "RoG (nm)"
  ) +
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0), breaks = seq(1.8, 2, by = 0.02), limits = c(1.8, 2)) +
  scale_color_manual(values = c(
    "ASO" = "steelblue",
    "MA1449" = "tomato",
    "MA1471" = "darkorange",
    "PROG" = "forestgreen",
    "PR" = "purple"
  )) +
  facet_wrap(~ State, ncol = 1)  # Create separate panels for each State

print(p_split)
ggsave("rog_split.png", plot = p, width = 10, height = 10, dpi = 600)
