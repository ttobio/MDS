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
print(head(rmsd1))  # Example for rmsd1
print(head(rmsd2))  # Example for rmsd2








p <- ggplot() +
  # Plot the first dataset with label "State 1"
  geom_line(data = rmsd1, aes(x = `Time(ns)`, y = `RMSD(ns)`, color = "State 1"), size = 1) +   
  # Plot the second dataset with label "State 2"
  geom_line(data = rmsd2, aes(x = `Time(ns)`, y = `RMSD(ns)`, color = "State 2"), size = 1) +   
  geom_line(data = rmsd3, aes(x = `Time(ns)`, y = `RMSD(ns)`, color = "State 2"), size = 1) +
  geom_line(data = rmsd4, aes(x = `Time(ns)`, y = `RMSD(ns)`, color = "State 2"), size = 1) +
  geom_line(data = rmsd5, aes(x = `Time(ns)`, y = `RMSD(ns)`, color = "State 2"), size = 1)
  theme_classic() +                              
  theme(
    plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),  # Title customization
    axis.title.x = element_text(size = 12),  # X-axis title customization
    axis.title.y = element_text(size = 12),  # Y-axis title customization
    axis.text.x = element_text(size = 10),    # X-axis labels customization
    axis.text.y = element_text(size = 10),    # Y-axis labels customization
    panel.grid.major = element_blank(), # Major grid lines
    panel.grid.minor = element_blank(),  # No minor grid lines
    legend.position = "top",  # Position legend at the top
    legend.title = element_blank()  # Remove the legend title
  ) +
  labs(
    title = "RMSD Plot",
    x = "Time (ns)",
    y = "RMSD (Å)"
  ) +
  scale_x_continuous(expand = c(0, 0)) + # Remove extra space at the ends
  scale_y_continuous(expand = c(0, 0), breaks = seq(0, 18, by = 2)) +  # Y-axis breaks
  scale_color_manual(values = c("State 1" = "red", "State 2" = "black")) +  
  guides(color = guide_legend(nrow = 3, position ="inside")) 

print(p)
ggsave("rmsd_new.png", plot = p, width = 13, height = 10, dpi = 600)