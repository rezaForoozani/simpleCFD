import numpy as np
import matplotlib.pyplot as plt

# Step 1: Read data from the file
filename = 'data.txt'

# Initialize lists to store the data
x = []
u = []

# Read the data from the file
with open(filename, 'r') as file:
    for line in file:
        values = line.split()
        if len(values) == 2:  # Ensure there are two values in the line
            x.append(float(values[0]))  # First column (X values)
            u.append(float(values[1]))  # Second column (U values)

# Convert lists to numpy arrays for easier manipulation
x = np.array(x)
u = np.array(u)

# Step 2: Create the plot
plt.figure(figsize=(10, 6))
plt.plot(x, u, marker='o', linestyle='-', color='b', label='U vs X')
plt.title('Plot of U vs X')
plt.xlabel('X')
plt.ylabel('U')
plt.grid()
plt.legend()
plt.xlim(min(x), max(x))
plt.ylim(min(u), max(u) + 1)  # Adjust Y limits for better visibility

# Save the figure to a file
plt.savefig('plot.png', format='png', dpi=300)  # Save as PNG with 300 dpi

# Optionally, you can close the plot if you don't want to display it
plt.close()
