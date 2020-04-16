# rbf_network

An implementation of a simple radial basis function network. Given the final purpose of this implementation, the center selection is made directly from the samples (no k-means clustering).

### Example : approximation of a 1D modulated exponential

We approximate the function ```f(x) = -exp(|x|)*sin(4*pi*x)``` in ```[-1,1]``` with (i) a grid sampling of increasing resolution (from 2 to 20, left panel) and (ii) a latin hypercube sampling, with the same resolution (right panel). In both cases, normalized inverse multiquadric RBFs are used. The blue dots at the bottom indicate the positions of the centroids.

<p align="center">
  <img width="430" alt="" src="https://user-images.githubusercontent.com/44053700/71672808-50e89780-2d77-11ea-8181-d8edbb025a6a.gif">
  <img width="430" alt="" src="https://user-images.githubusercontent.com/44053700/71672891-75dd0a80-2d77-11ea-93ed-d8cae4a20e71.gif">
</p>

## Description

The scope of this project is strictly limited to the interpolation of a limited amount of data. Hence, the centers of the RBF network are directly the provided data samples (no k-means clustering).

For testing purpose, the ```start.py``` file defines an analytical (1D or 2D) function that can be sampled in different ways (using a **random sampling**, a **grid** or a **latin hypercube sampling**) and then interpolated with the RBF. Please note that when using **grid** sampling in 2D, the actual number of samples used is **the square** of the provided number. 

Several RBF are available, such as **gaussian**, **inverse multiquadric** or **bump**. It is also possible to use normalized versions of rbf (recommended).

After the interpolation is computed, the exact and approximate functions are sampled on a grid with resolution ```n_grid``` for visualization (this is also tunable in ```start.py```). 

## Usage

Set everything in the ```start.py``` header, and then just launch ```python3 start.py```. This will output two files:

- A ```dataset_x.dat``` file that contains the rbf centers and weights
- A ```grid_x.dat``` file that contains the sampling of the exact and approximate functions

You can obtain plots of the solution using ```gnuplot``` files : ```gnuplot plot.gnu``` will write a ```.png``` file of the exact and approximate solutions.

A batch file is also available to generate approximations with increasing level of sampling: ```bash batch_rbf.sh 2 1 10``` will execute ```start.py``` using 2 to 10 rbf with a step of 1. You can generate a gif of the results obtained with ```gnuplot -c plot_gif_2d.gnu 2 1 10``` (you must provide the parameters again to the gnuplot script). Different scripts are used for 1D and 2D, make sure to call the correct one.

### Known issues

- The real parameter ```beta```, used in most rbf definitions, can have a major impact on the accuracy of the interpolation. In this implementation, it is computed as the inverse of the squared average distance from current center to all other centers.
- The computation of the pseudo-inverse of the interpolation matrix uses ```np.pinv```. The cutoff value ```rcond``` that is used to neglect the small singular values can also have an impact on the maximal accuracy level

## Examples

### Approximation of a 1D sinusoidal curve

We approximate the function ```f(x) = sin(6x)``` in ```[-pi,pi]``` with (i) a grid sampling of increasing resolution (from 6 to 30, left panel) and (ii) a latin hypercube sampling, with the same resolution (right panel). In both cases, normalized inverse multiquadric RBFs are used. The blue dots at the bottom indicate the positions of the centroids. Results are obtained using the batch script ```bash batch_rbf.sh 2 2 30```. The gif is obtained using ```gnuplot -c plot_gif_1d.gnu 2 2 30```.

<p align="center">
  <img width="430" alt="" src="https://user-images.githubusercontent.com/44053700/71668418-1ed03900-2d69-11ea-881c-37fd9477db99.gif">
  <img width="430" alt="" src="https://user-images.githubusercontent.com/44053700/71668431-30b1dc00-2d69-11ea-8fb5-b7da29cf157d.gif">
</p>

### Approximation of a 2D sinusoidal surface

We approximate the function ```f(x,y) = sin(5x)*cos(3y)``` in ```[-1,1]x[-1,1]``` with a grid sampling. The plot is obtained using ```gnuplot plot_2d.gnu```.

<p align="center">
  <img alt="" src="https://user-images.githubusercontent.com/44053700/71662901-66e46100-2d53-11ea-81b9-a2ced6c3e717.png">
</p>

### Approximation of a modulated 2D parabola

We approximate the function ```f(x,y) = x^2 + sin(3x)*y^2``` in ```[-1,1]x[-1,1]``` with a grid sampling. Results are obtained using the batch script ```bash batch_rbf.sh 2 1 9```. The gif is obtained using ```gnuplot -c plot_gif_2d.gnu 2 1 9```.

<p align="center">
  <img alt="" src="https://user-images.githubusercontent.com/44053700/71672058-2bf32500-2d75-11ea-928c-e0c277b306be.gif">
</p>

