import numpy as np
from matplotlib import pyplot as plt

data = np.loadtxt("data.txt")
print(data.shape)

center = np.mean(data, axis=0)
print(center)

centered_data = data - center

U, S, Vh = np.linalg.svd(centered_data)

rescale = np.diag(S) @ Vh
print(rescale.T)
print(center)

sphereified = centered_data @ np.linalg.inv(rescale)

plot_data = sphereified

fig = plt.figure()
ax = plt.axes(projection="3d")
ax.scatter3D(plot_data[:, 0], plot_data[:, 1], plot_data[:, 2])

plt.show()

fig, axs = plt.subplots(2, 2)
axs[0, 0].scatter(plot_data[:, 0], plot_data[:, 1])
axs[0, 1].scatter(plot_data[:, 1], plot_data[:, 2])
axs[1, 0].scatter(plot_data[:, 0], plot_data[:, 2])

axs[0, 0].axis('equal')
axs[0, 1].axis('equal')
axs[1, 0].axis('equal')
axs[1, 1].axis('equal')

print(np.max(plot_data, axis=0))
print(np.min(plot_data, axis=0))
print(np.mean(plot_data, axis=0))

plt.show()