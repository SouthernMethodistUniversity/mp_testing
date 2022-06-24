import numpy as np
import matplotlib.pyplot as plt
import sys
from pathlib import Path


if len(sys.argv) <= 1:
    print('graph_scaling.py input_file')
    exit(1)

input_file = sys.argv[1]

filepath = Path(input_file)
output = filepath.with_suffix('').with_suffix('.png')

vals = np.loadtxt(filepath, delimiter=',')

print(vals)

n_vals = (vals[:,0]).size

tests = np.linspace(1, n_vals, num=n_vals)
n_gpus =vals[:,0].astype(int)
images_per_sec = vals[:,1]
ideal = vals[0,1]*n_gpus / n_gpus[0]
var = vals[:,2]

width = 0.45

fig, ax = plt.subplots()
ax.bar(tests, images_per_sec, width = width, yerr=var, align='center', alpha=0.5, ecolor='black', capsize=10, label="Experimental")
ax.bar(tests + width, ideal, width = width, align='center', alpha=0.5, ecolor='black', capsize=10, label="Ideal Scaling")
ax.set_ylabel('Images per second')
ax.set_xlabel('Number of GPUs')
ax.set_xticks(tests)
ax.set_xticklabels(n_gpus)
ax.set_title('Horovod Tensorflow Synthetic Test')
ax.yaxis.grid(True)
plt.legend()
# Save the figure
plt.tight_layout()
plt.savefig(output,dpi=300)

