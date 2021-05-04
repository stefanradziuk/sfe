#!/usr/bin/bash

DATA=$(ghci sfe.hs -e '[(earnings, totalPaid earnings) | earnings <- [15000,15250..120000]]')

python -c "data = $DATA ; import matplotlib.pyplot as plt ; plt.scatter(*zip(*data), s=2) ; plt.ylim(ymin=0) ; plt.show()"
