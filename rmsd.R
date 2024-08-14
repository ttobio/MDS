read_and_clean_xvg <- function(file) {
  # Read the file and skip lines that start with # or @ (these are headers/comments)
  data <- read.table(file, comment.char = "@", fill = TRUE, header = FALSE)
  
  # Remove rows where the first column is not numeric (typically headers/comments)
  data <- data[!grepl("^[@#]", data$V1), ]
  
  # Convert columns to numeric to ensure data is clean
  data <- data.frame(lapply(data, as.numeric))
  
  # Keep only the first two columns (time and RMSD)
  data <- data[, 1:2]
  
  # Assign column names
  colnames(data) <- c("Time(ns)", "RMSD")
  
  return(data)
}
#Use the Function to Read an .xvg File and Preview the Data
ER_rmsd <- "rmsd1.xvg"
BIP_rmsd <- "rmsd2.xvg"

# Read and clean the .xvg file
cleaned_ER <- na.omit(read_and_clean_xvg(ER_rmsd))
cleaned_BIP <- na.omit(read_and_clean_xvg(BIP_rmsd))

# Preview the cleaned data
head(cleaned_ER)
# Convert RMSD from nm to Å (1 nm = 10 Å)
cleaned_ER$`RMSD (Å)` <- cleaned_ER$RMSD * 10
cleaned_BIP$`RMSD (Å)` <- cleaned_BIP$RMSD * 10
cleaned_BIP$`Time(ns)` <- cleaned_BIP$`Time(ns)` / 1000 #in case the time in pico seconds
library(dplyr)

cleaned_BIP <- cleaned_BIP %>%
  filter(`Time(ns)` <= 50)
# Preview the updated data frame
head(cleaned_BIP)



#===============================================================================
library(ggplot2)

p <- ggplot() +
  # Plot the first dataset with label "State 1"
  geom_line(data = cleaned_ER, aes(x = `Time(ns)`, y = `RMSD (Å)`, color = "State 1"), size = 1) +   
  # Plot the second dataset with label "State 2"
  geom_line(data = cleaned_BIP, aes(x = `Time(ns)`, y = `RMSD (Å)`, color = "State 2"), size = 1) +   
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
ggsave("rmsd.png", plot = p, width = 13, height = 10, dpi = 600)

