#! /usr/bin/gnuplot

### Retrieve from other data files
n_grid    = system("awk '/n_grid/   {print $3}' start.py | head -1")
sampling  = system("awk '/sampling/ {print $3}' start.py | sed -n 2p")

### Retrieve input arguments
set print "-"
start = int(ARG1)
step  = int(ARG2)
end   = int(ARG3)

### Animated gif
# Reset everything
reset

# Set styles
set style line 3 pointtype 7 pointsize 1.5 linecolor rgb "blue"
PTS = "3"

# Set term gif
set term gif animate delay 100 size 1600,800

# Misc
set print "-"
unset key
set dgrid3d n_grid,n_grid,1
set hidden3d
set contour
set isosamples 50
set cntrparam levels 10
set output "rbf.gif"

# Plot gif
do for [i=start:end:step] {

   # Handle grid sampling
   j = i
   if (sampling eq "'grid'") {
      j = i*i
   }

   grid_file = "grid_".j.".dat"
   dat_file  = "dataset_".j.".dat"
   set multiplot layout 1, 2

   set title "rbf, basis size=".j
   set zrange [0:25]
   splot grid_file u 1:2:3 w l, \
         grid_file u 1:2:4 w l

   set title "sampling, basis size=".j
   set cbrange [0:25]
   unset xtics
   unset ytics
   plot grid_file u 1:2:4 with image, \
        dat_file  u 1:2 w p ls @PTS
   set xtics
   set ytics

   unset multiplot
}