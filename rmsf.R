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
  colnames(data) <- c("Residue", "(nm)")
  
  return(data)
}
#Use the Function to Read an .xvg File and Preview the Data
rmsf <- "rmsf1.xvg"

# Read and clean the .xvg file
cleaned_rmsf <- na.omit(read_and_clean_xvg(rmsf))

# Preview the cleaned data
head(cleaned_rmsf)
# Convert nm to Å (1 nm = 10 Å)
cleaned_rmsf$`(Å)` <- cleaned_rmsf$`(nm)` * 10
head(cleaned_rmsf)
library(ggplot2)

p <- ggplot(data = cleaned_rmsf, aes(x = Residue, y = `(Å)`)) +
  geom_line(colour = "red", size = 0.7) +   
  theme_classic() +                              
  theme(
    plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),  # Title customization
    axis.title.x = element_text(size = 12),  # X-axis title customization
    axis.title.y = element_text(size = 12),  # Y-axis title customization
    axis.text.x = element_text(size = 10, face = "bold"),    # X-axis labels customization (Bold)
    axis.text.y = element_text(size = 10, face = "bold"),    # Y-axis labels customization (Bold)
    panel.grid.major = element_blank(), # Major grid lines
    panel.grid.minor = element_blank(),  # No minor grid lines
    legend.position = "top",  # Position legend at the top
    legend.title = element_blank()  # Remove the legend title
  ) +
  labs(
    title = "RMSF Fluctuation",
    x = "Residue",
    y = "(Å)"
  ) +
  scale_x_continuous(expand = c(0, 0)) + # Remove extra space at the ends
  scale_y_continuous(expand = c(0, 0), breaks = seq(0, 15, by = 1)) # Y-axis breaks


print(p)
ggsave("rmsf.png", plot = p, width = 13, height = 10, dpi = 600)
