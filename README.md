# sampling_based_planners
---
This is a library for some of the sampling-based motion planning algorithms implemented in MATLAB. Currently the following methods are available: rapidly-exploring random tree (RRT), rapidly-exploring random graph (RRG), asymptotically optimal RRT (RRT*). The [incrementally-exploring information gathering (IIG)][1] which is built on the [rapidly-exploring information gathering (RIG)][2] technique.

- Initialize the library

```matlab
>> init
```

- IIG (RIG with an information-based convergence metric): The information functions estimate the mutual information, the available methods are mutual information `'mi'`, mutual information upper bound `'miub'`, Gaussian process variance reduction `'gpvr'`, and Gaussian process variance reduction with uncertain input `'ugpvr'`. For more details please see the IIG paper: 
  
```Ghaffari Jadidi, M., Valls Miro, J. and Dissanayake, G. (2019) ‘Sampling-based incremental information gathering with applications to robotic exploration and environmental monitoring’, The International Journal of Robotics Research, 38(6), pp. 658–685. doi: 10.1177/0278364919844575.``` https://arxiv.org/abs/1607.01883

For example, we can run IIG using `'ugpvr'` information function as follows:

```matlab
>> out = iig_planner('gpvr')
```

The `'ugpvr'` uses `covUI` function which is a wrapper for integration over covariance functions with uncertain input and it can be used as a meta-covariance function in conjunction with any covariance function available in [GPML][3].
Generally, `'mi'` is suitable when taking expectation over future measurements is possible. It requires direct integrations over a probabilistic measurement model. The `'gpvr'` and `'ugpvr'` are preferred for environmental monitoring tasks.

- RRT

```matlab
>> out = rrt_planner()
```

![Image of RRT](https://raw.githubusercontent.com/MaaniGhaffari/sampling_based_planners/master/figures/RRT_Cave.gif)


- RRG

```matlab
>> out = rrg_planner()
```


- RRT*

```matlab
>> out = rrtstar_planner()
```

> *The implementations depend on the MATLAB built-in kd-tree objects.*

> *It is possible to make the planners kinodynamic by modifying the* **steer.m** *function.* 

## Citations
```
@article{mghaffari2019sampling,
  title={Sampling-based incremental information gathering with applications to robotic exploration and environmental monitoring},
  author={Ghaffari Jadidi, Maani and Valls Miro, Jaime and Dissanayake, Gamini},
  journal={The International Journal of Robotics Research},
  volume={38},
  number={6},
  pages={658-685},
  year={2019},
  doi = {10.1177/0278364919844575}
}
```

[1]:https://doi.org/10.1177/0278364919844575
[2]:http://ijr.sagepub.com/content/33/9/1271
[3]:http://www.gaussianprocess.org/gpml/code/matlab/doc/
