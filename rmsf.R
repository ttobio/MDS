#This is a script that primary visualizes the RMSF results out of ./prepare_xvg.sh
#
#copyright (c) 2024 - Emadeldin M. Ibrahim
#
#last modified Sep, 2024
#First written Aug, 2024

setwd("C:/Users/Imad/Desktop/MDS/data/XVG_PR/rmsf")

# Function to read CSV files, rename columns, store them in a list, and assign individual variables
read_and_assign_rmsf_files <- function() {
  # Get all CSV files starting with 'rmsf' in the current directory
  rmsf_files <- list.files(pattern = "^rmsf.*\\.csv$")
  
  # Check if any files are found
  if (length(rmsf_files) == 0) {
    stop("No RMSF files found in the directory.")
  }
  
  # Initialize an empty list to store data frames
  data_list <- list()
  
  # Loop through the files, read them, rename columns, and store in the list
  for (file in rmsf_files) {
    # Print the filename to track progress
    message(paste("Reading file:", file))
    
    # Read the CSV file
    data <- read.csv(file)
    
    # Rename the columns to 'Residue' and 'RMSF(nm)'
    colnames(data) <- c("Residue", "RMSF(nm)")
    
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
read_and_assign_rmsf_files()

# Now you can access each dataframe as an individual variable in the environment
# For example, you can directly access 'rmsd1', 'rmsd2', etc. like this:
str(data_list)


print(head(rmsf_PRm71))  
print(head(rmsf_PRm49)) 

print(head(rmsf_PRaso))

print(head(rmsf_PRprog))

print(head(rmsf_PRalone))

library(ggplot2)




 p <- ggplot() +
  # Plot the first dataset with label "State 1"
  geom_line(data = rmsf_PRaso, aes(x = `Residue`, y = `RMSF(nm)`, color = "ASO"), size = 1, alpha = 0.7) +   
  # Plot the second dataset with label "State 2"
  geom_line(data = rmsf_PRm49, aes(x = `Residue`, y = `RMSF(nm)`, color = "MA1449"), size = 1, alpha = 0.7) +
  # Plot the third dataset with label "State 3"
  geom_line(data = rmsf_PRm71, aes(x = `Residue`, y = `RMSF(nm)`, color = "MA1471"), size = 1, alpha = 0.7) +
  # Plot the fourth dataset with label "State 4"
  geom_line(data = rmsf_PRprog, aes(x = `Residue`, y = `RMSF(nm)`, color = "PROG"), size = 1, alpha = 0.7) +
  # Plot the fifth dataset with label "State 5"
  geom_line(data = rmsf_PRalone, aes(x = `Residue`, y = `RMSF(nm)`, color = "PR"), size = 1, alpha = 0.7) +
  
  # Adjust theme
  theme_classic() +                              
  theme(
    plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),  # Title customization, bold and centered
    axis.title.x = element_text(size = 12, face = "bold"),  # X-axis title bold
    axis.title.y = element_text(size = 12, face = "bold"),  # Y-axis title bold
    axis.text.x = element_text(size = 10, face = "bold"),    # X-axis labels bold
    axis.text.y = element_text(size = 10, face = "bold"),    # Y-axis labels bold
    panel.grid.major = element_blank(), # Major grid lines
    panel.grid.minor = element_blank(),  # No minor grid lines
    legend.position = c(0.5, 0.85),  # Position legend inside the plot area
    legend.justification = c(0.5, 0.5),  # Center the legend
    legend.title = element_blank(),  # Remove the legend title
    legend.text = element_text(size= 10, face = "bold") # Make legend labels bold
  ) +
  
  # Labels for title and axes
  labs(
    title = "RMSF Flactuation",
    x = "Residue Number",
    y = "RMSF (nm)"
  ) +
  
  # Set X-axis and Y-axis scales
  scale_x_continuous(expand = c(0, 0)) + # Remove extra space at the ends
  
  # Force the Y-axis to range from 0 to 1 with breaks every 0.2
  scale_y_continuous(expand = c(0, 0), breaks = seq(0, 0.8, by = 0.2), limits = c(0, 0.8)) + 
  
  # Manual color assignment with transparency for better readability
  scale_color_manual(values = c(
    "ASO" = "steelblue",  # Blue shade
    "MA1449" = "tomato",     # Red shade
    "MA1471" = "darkorange", # Orange shade
    "PROG" = "forestgreen",# Green shade
    "PR" = "purple"      # Purple shade
  )) +  
  
  # Adjust the number of rows in the legend to stack them vertically
  guides(color = guide_legend(nrow = 5, byrow = TRUE))  # Stacks legend vertically, one item per row

print(p)


#outputs>>("/output_plots")
ggsave("rmsf_PR.png", plot = p, width = 10, height = 10, dpi = 600)