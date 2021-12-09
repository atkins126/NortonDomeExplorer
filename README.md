# NortonDomeExplorer
Classical Newtonian mechanics is generally considered a prime example of a deterministic theory.
It is however possible to construct systems within the confines of Newtonian mechanics which appear to be indeterministic.
The NortonDomeExplorer was developed for the exploration of the discretized version of such an example[\[1\]](#ref_DS1): the dynamics of a point mass on Malament's mounds[\[2\]](#ref_mal), including the special case of Norton's dome[\[3\]](#ref_nort).

![screenshot](images/Dome_ScreenShot.png)
<p align="center" style="font-size:smaller">
The Norton Dome Explorer.</p>
<br />

## Background: Norton's dome and Malament's mounds
In 2003, the philosopher of science John D. Norton presented a thought experiment which exhibits non-deterministic behaviour within the context of Newtonian mechanics.
The setup is quite simple. Imagine a hill (or mound) with a shape such that a point mass located on the apex (where it has a zero velocity) may roll downward following the hill's curvature exactly due to the downward gravitational pull.
The shape of the hill is given by the equation:
<p align="center"><img src="images/DomeEquation.png" width=40% height=40% /></p>

The dynamical problem can also be expressed in terms of the arc length **r(t)**
<img src="images/rProblem.png" width=40% height=40% alignment="center"/>

This appears to be an innocent example of an unstable equilibrium situation, however, the dome's shape is chosen such that the initial value problem is not 
[Lipschitz-continuous](https://en.wikipedia.org/wiki/Lipschitz_continuity).
As a result, there is a continuum of solutions: the mass may stay at the apex forever, or it may start rolling of after any possible delay time T.<br /> 
<img src="equations/Solutions.png" width=50% height=50% />

Although the latter solutions could be considered as the result of small perturbations, just as in the case of deterministic systems with an unstable equilibrium, no perturbation is required in this thought experiment.
Here, the movement is initiated spontaneously, without any perturbation, giving rise to non-deterministic behaviour in a system that looks like it could come straight 
from a textbook on Newtonian physics.<br />
Norton's dome problem can be generalized to an entire family of surfaces of the shape:
<img src="equations/MalamentEquation.png" width=50% height=50% /><br/>
and which look like
![MalamentMounds](equations/Mounds.png)
.

## Assigning probabilities to the Norton's dome and Malament's mounds solutions
Initial value problems in Newtonian physics that are indeterministic due to non-Lipschitz continuity do not even come with a probability distribution.
We set out to find a natural procedure for assigning probabilities to their solutions[\[1\]](#ref_DS1).
Since Norton's dome received much attention by philosophers of science, as a simple example of indeterminism in Newtonian mechanics, we have used this toy example and Malament's generalization to develop a method for assigning probabilities to the different solutions.<br />

Our approach starts from a discretization of time, which results in difference equations instead of differential equations.
This approach is familiar to most physicists, but we have formalized the idea of infinitesimal time steps and perturbations with a recent mathematical formalism: Alpha-theory[\[4\]](#ref_NonSA).
Before considering the Alpha-limit, we had to study the difference equations with non-infinitesimal time steps and perturbations.
Since there is no known solution for the discrete version of Norton's dome and Malament's mounds, an important component of our study consisted of numerical results.
This prompted us to develop this program. Some results can be seen in [\[1\]](#ref_DS1).

Our assignment of probabilities to solutions of the differential equation works is based on a measure of the phase space of solutions to the difference equations in the Alpha-limit. (This is possible because the map from the latter to the former is many-to-one.)
![PhaseSpace](equations/PhaseSpace.png)
<p align="center">
Dynamics of the discretized version of Norton's dome system on the phase space of initial conditions.</p>
<br />

We found that the relation of the delay time T as function of the (infinitesimal) initial conditions is highly non-linear, with the positive (red) delay times being very localised.
![DelayDist](equations/NonLinearDelay.png)

As a result of this, we found that regular solutions with any observable delay time have zero probability.
The regular solution with T=0, which describes that the mass slides off without any observable delay, has unit probability.
(The trivial solution of the mass remaining at the apex forever has zero probability as well.)
<br />
<br />

### Phase space vector field for all Malament's mounds

![PhaseAni](equations/PhaseSpaceMalAni.gif) 
 




## Usage:

### Installation
* The program can be downloaded as [64bit Windows binary](bin/). Alternatively, it can be compiled 
from the [source](source/DomeExplorer) using a [Delphi-compiler](https://www.embarcadero.com/products/delphi). 
* The support program for generating the vector-field of the phase space can be
compiled from the Fortran [source](source/PhaseSpace). The [gnuplot](http://www.gnuplot.info/) script
for generating the animation can be found in the same folder.


### Running the program
1. Start the program
2. In the *Screen* section select:
    * the initial conditions: (R0,R1) or (R0,V0)
    * and set the ranges as Point 1 (R0) and Point 2 (R1 or V0)
    * the a-power of the general Malament-mound formalism 
	   (Norton Dome: a=0.5)
    * the time-step Delta(T)
    * the number of iterations
3. In the *Run Options* section:
	1. press *Run Simulation* (a progress bar shows the progress of the simulation)
    2. press *Draw T* to visualise the delay times for all initial conditions 	





## References
**<a name="ref_DS1">\[1\]</a>** *"Assigning probabilities to non-Lipschitz mechanical systems"*, D. E. P. Vanpoucke and S. Wenmackers, *Chaos* **X**, YY-YY (2021) [ArXiv](https://arxiv.org/abs/2001.10375)</br>
**<a name="ref_mal">\[2\]</a>** *"Norton's slippery slope"*, D. B. Malament, *Philosophy of Science* **75**, 799-816 (2008)</br>
**<a name="ref_nort">\[3\]</a>** *"Causation as folk science"*, J. D. Norton, *Philosophers' Imprint* **3** (2003) and
*"The dome: An unexpectedly simple failure of determinism"*, J. D. Norton, *Philosophy of Science* **75**, 786-798 (2008)</br>
**<a name="ref_nonSA">\[4\]</a>** *"How To Measure The Infinite: Mathematics With Infinite And Infinitesimal Numbers"*, Vieri Benci, Mauro Di Nasso, *World Scientific*, ISBN:978-9812836373 (2019) </br>

