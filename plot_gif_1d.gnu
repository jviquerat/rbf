#! /usr/bin/gnuplot

### Retrieve from other data files
n_grid    = system("awk '/n_grid/  {print $3}' start.py | head -1")

### Retrieve input arguments
set print "-"
start = int(ARG1)
step  = int(ARG2)
end   = int(ARG3)

### Animated gif
# Reset everything
reset

# Set styles
set style line 1 lc rgb '#0060ad' lt 1 lw 2 pt 5 # blue
set style line 2 lc rgb '#dd181f' lt 1 lw 2 pt 7 # red
set style line 3 pointtype 7 pointsize 1.5 linecolor rgb "blue"
BLUE = "1"
RED  = "2"
PTS  = "3"

# Term gif
set term gif animate delay 100 size 1000,800 enhanced font 'Verdana,10'

# Misc
set print "-"
unset key
set grid
set output "rbf.gif"

# Plot gif
do for [i=start:end:step] {
   grid_file = "grid_".i.".dat"
   data_file = "dataset_".i.".dat"
   set yrange [-1.5:1.5]

   set title "rbf, basis size=".i
   plot grid_file u 1:2 w l ls @BLUE, \
        grid_file u 1:3 w l ls @RED, \
        data_file u 1:(-1) w p ls @PTS 
}