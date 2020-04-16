# Generic imports
import os, sys
from math        import exp, sin, cos, sqrt, pi, floor

# Custom imports
from sampling    import *
from rbf_network import *

###############################################
### Set parameters
###############################################

# Basic parameters
n_basis     = 6          # nb of rbf functions to use
basis       = 'inv_mult' # 'gaussian' or 'inv_mult'
normalize   = True       # normalized rbf if true
sampling    = 'rand'     # 'rand', 'grid' or 'lhs'
x_max       = 5.0        # bounds for function to fit
dim         = 2          # input dimension (1 or 2)
n_grid      = 100        # nb of grid evals per dimension for plotting

# Check command-line input for n_basis
if (len(sys.argv) == 2):
    n_basis = int(sys.argv[1])

# Function to fit
def fnc(x):
    if (dim == 1):
        u = x[:,0]

        # Sinusoid
        #return np.sin(6*u)

        # Decaying sinusoid
        return -np.exp(-abs(u))*np.sin(4.0*pi*u)

    if (dim == 2):
        u = x[:,0]
        v = x[:,1]

        # Parabola
        return np.square(u) + np.square(v)

        # Sinusoidal surface
        #return np.sin(5*u)*np.cos(3*v)

###############################################
### Fit function
###############################################

# Sample function
if (sampling == 'rand'): # Random sampling
    x       = sample_random(x_max, dim, n_basis)
if (sampling == 'grid'): # Regular grid sampling
    x       = sample_grid  (x_max, dim, n_basis)
    n_basis = n_basis**dim
if (sampling == 'lhs'):  # Uniform latin hypercube sampling
    x       = sample_lhs   (x_max, dim, n_basis)

# Reshape in any case
x = np.reshape(x, (n_basis, dim))

# Compute sampled values
y = fnc(x)

# Initialize network
network = rbf_network()
network.set_rbf(n_basis   = n_basis,
                basis     = basis,
                normalize = normalize,
                x_max     = x_max,
                dim       = dim)

# Fill dataset
for i in range(n_basis):
    network.add_data(x[i,:], y[i])

# Train network
network.train()

# Generate grid
grid = sample_grid(x_max, dim, n_grid)

# Compute exact and approx values
y_net = np.reshape(network.predict(grid),(n_grid**dim,))
y     = fnc(grid)

# Output rbf data
filename  = 'dataset_'+str(n_basis)+'.dat'
with open(filename, 'w') as f:
    for i in range(n_basis):
        for k in range(dim):
            f.write('{} '.format(float(network.centers_x[i,k])))
        f.write('{} '.format(float(network.weights[i])))
        f.write('\n')

# Output exact and approximate solutions on grid
filename  = 'grid_'+str(n_basis)+'.dat'
with open(filename, 'w') as f:
    for i in range(n_grid**dim):
        for k in range(dim):
            f.write('{} '.format(grid[i,k]))

        f.write('{} '.format(y[i]))
        f.write('{} '.format(float(y_net[i])))
        f.write('\n')

# Compute max relative error
error   = 0.0
max_val = max(np.absolute(y))
diff    = np.absolute(y-y_net)
max_err = max(diff)
avg_err = np.average(np.absolute(y-y_net))
print('Max absolute error = '+str(max_err))
print('Avg absolute error = '+str(avg_err))
print('')
