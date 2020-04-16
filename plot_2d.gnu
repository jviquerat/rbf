#! /usr/bin/gnuplot

### Retrieve from other data files
n_grid    = system("awk '/n_grid/  {print $3}' start.py | head -1")
n_basis   = system("awk '/n_basis/ {print $3}' start.py | head -1")
grid_file = "grid_".n_basis.".dat"
dat_file  = "dataset_".n_basis.".dat"

### Plot png
# Initial stuff
reset
set print "-"
set terminal png size 2400,800
unset key
set output "rbf.png"
set multiplot layout 1, 3

# Plot approx heatmap with samples
set title "sampling, basis size=".n_basis
set cbrange [0:25]
unset xtics
unset ytics
plot grid_file u 1:2:4 with image, \
     dat_file  u 1:2 w p pointtype 7 pointsize 1.5 linecolor rgb "blue"
set xtics
set ytics

# Set stuff for following plots
set dgrid3d n_grid,n_grid,1
set hidden3d
set contour
set isosamples 50
set cntrparam levels 10

# Plot exact and approx surfaces
set title "RBF, basis size=".n_basis
splot grid_file u 1:2:3 w l, grid_file u 1:2:4 w l

### Error png
set title "RBF error, basis size=".n_basis
splot grid_file u 1:2:($3-$4) w l