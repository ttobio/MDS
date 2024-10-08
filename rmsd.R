#This is a script that primary visualizes the RMSD results out of ./prepare_xvg.sh
#
#copyright (c) 2024 - Emadeldin M. Ibrahim
#
#last modified Sep, 2024
#First written Aug, 2024

setwd("C:/Users/Imad/Desktop/MDS/data/XVG_PR/rmsd")

# Function to read CSV files, rename columns, store them in a list, and assign individual variables
read_and_assign_rmsd_files <- function() {
  # Get all CSV files starting with 'rmsd' in the current directory
  rmsd_files <- list.files(pattern = "^rmsd.*\\.csv$")
  
  # Check if any files are found
  if (length(rmsd_files) == 0) {
    stop("No RMSD files found in the directory.")
  }
  
  # Initialize an empty list to store data frames
  data_list <- list()
  
  # Loop through the files, read them, rename columns, and store in the list
  for (file in rmsd_files) {
    # Print the filename to track progress
    message(paste("Reading file:", file))
    
    # Read the CSV file
    data <- read.csv(file)
    
    # Rename the columns to 'Time(ns)' and 'RMSD(nm)'
    colnames(data) <- c("Time(ns)", "RMSD(nm)")
    
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
read_and_assign_rmsd_files()

# Now you can access each dataframe as an individual variable in the environment
# For example, you can directly access 'rmsd1', 'rmsd2', etc. like this:
str(data_list)


print(head(rmsd_ca_ca_PRm71)) 
print(head(rmsd_ca_ca_PRm49)) 

print(head(rmsd_ca_ca_PRaso))

print(head(rmsd_ca_ca_PRprog))

print(head(rmsd_ca_caPR_alone))


library(ggplot2)
library(dplyr)

gyrate_combined <- bind_rows(
  mutate(rmsd_ca_ca_PRaso, State = "ASO"),
  mutate(rmsd_ca_ca_PRm49, State = "MA1449"),
  mutate(rmsd_ca_ca_PRm71, State = "MA1471"),
  mutate(rmsd_ca_ca_PRprog, State = "PROG"),
  mutate(rmsd_ca_caPR_alone, State = "PR")
)

# Combined Plot (same as before)
p_combined <- ggplot() +
  geom_line(data = gyrate_combined, aes(x = `Time(ns)`, y = `RMSD(nm)`, color = State), size = 1, alpha = 0.7) +
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
    title = "RMSD Plot",
    x = "Time (ns)",
    y = "RMSD (nm)"
  ) +
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0), breaks = seq(0, 0.8, by = 0.2), limits = c(0, 0.8)) +
  scale_color_manual(values = c(
    "ASO" = "steelblue",
    "MA1449" = "tomato",
    "MA1471" = "darkorange",
    "PROG" = "forestgreen",
    "PR" = "purple"
  )) +
  guides(color = guide_legend(nrow = 5, byrow = TRUE))

print(p_combined)
ggsave("rmsd_combined.png", plot = p_combined, width = 10, height = 10, dpi = 600)

# Split Plot with Separate Panels (using facet_wrap)
p_split <- ggplot(gyrate_combined, aes(x = `Time(ns)`, y = `RMSD(nm)`)) +
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
    title = "RMSD Plot",
    x = "Time (ns)",
    y = "RMSD (nm)"
  ) +
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0), breaks = seq(0, 0.8, by = 0.1), limits = c(0, 0.8)) +
  scale_color_manual(values = c(
    "ASO" = "steelblue",
    "MA1449" = "tomato",
    "MA1471" = "darkorange",
    "PROG" = "forestgreen",
    "PR" = "purple"
  )) +
  facet_wrap(~ State, ncol = 1)  # Create separate panels for each State

print(p_split)
ggsave("rmsd_split.png", plot = p_split, width = 10, height = 10, dpi = 600)