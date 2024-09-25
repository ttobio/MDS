# GROMACS Results Analysis and Visualization

## Overview

This repository provides a scripts to handle and visualize Root Mean Square Deviation (RMSD) data from GROMACS `.xvg` files and other files like RMSF and RoG. The scripts is designed to process multiple files and plot them in a single, highly customizable graph using R and `ggplot2`. The graph is suitable for publication, offering detailed customization options for colors, legends, axis labels, and more.

## Features

- **XVG files handling**: There are three shell scripts that prepare the xvg files from GROMACS to be easily inputed into R (ex. prepare_rmsd_xvg.sh).
- **Visualization**: Using ggplot2 and dplyer packages, this will yeild a nice figures for RMSD, RMSF, RoG.

## Dependencies

- **R**: The script is written in R and requires the following packages:
  - `ggplot2`
  - `dplyr`


## Contributing

Contributions are welcome! If you have ideas for additional features or improvements, please feel free to submit a pull request.




