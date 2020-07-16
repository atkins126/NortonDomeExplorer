# NortonDomeExplorer
Classical Newtonian mechanics is generally considered a prime example of 
determinism. It is however possible to construct systems within the 
confines of Newtonian mechanics which appear indeterministic.
The NortonDomeExplorer was developed for the exploration of such an 
example:[\[1\]](#ref_DS1) the dynamics of a point-mass on Malament-mounds[\[2\]](#ref_mal),
more specifically the case of the Norton Dome[\[3\]](#ref_nort).

![screenshot](equations/Dome_ScreenShot.png)


## Background: Norton Domes and Malament-mounds
In 2003, the philosopher of science John D. Norton presented a thought experiment which
exhibits non-deterministic behaviour within the context of Newtonian mechanics. The setup 
is quite simple. Imagine a hill (or mound) with a shape such that a point mass located 
on the apex (where it has a zero velocity) may roll downward following the hill's curvature 
exactly due to the downward gravitational pull. The shape of the hill is given by the 
equation:
<img src="equations/DomeEquation.png" width=30% height=30% />

This appears as an innocent example of an unstable equilibrium situation, however,
this shape is chosen such that the initial value problem is not 
[Lipschitz-continuous](https://en.wikipedia.org/wiki/Lipschitz_continuity). The mass will 
stay on the apex forever, or it will start rolling of after any possible delay
time. Although the latter solutions could be considered as the result of small perturbations,
this is not the case in this thought experiment. Here, the movement is initiated without
perturbation giving rise to non-deterministic behaviour in a system which could come straight 
from a textbook on Newtonian physics.<br />
<br />
This non-deterministic behaviour appears to go against the physical intuition of 
most phycists. To find source of this apparent contradiction, we set out to assign 
a probability to the different solutions of this dynamic problem.[\[1\]](#ref_DS1)
<br />
<br />
The Norton Dome problem can be generalized to entire family of surfaces of the shape:
<img src="equations/MalamentEquation.png" width=30% height=30% />


## Usage:
### Installation
The program can be either downloaded as [64bit windows binary](bin/) or compiled 
from [source](source/) using a [Delphi-compiler](https://www.embarcadero.com/products/delphi). 

### Running the program
1. Start the program
2. In the *Screen* section select:
  * the initial conditions: (R0,R1) or (R0,V0)
  * and set the ranges as Point 1 (R0) and Point 2 (R1 or V0)
  * the alpha-power of the general Malament-mound formalism 
	(Norton Dome: alpha=0.5)
  * the time-step DeltaT
  * the number of iterations
3. In the *Run Options* section:
	* press *Run Simulation* (a progressbar shows the progress of the simulation)
    * press *Draw T* to visualise the delay times for all initial conditions 	





## References
**<a name="ref_DS1">\[1\]</a>** *"Assigning probabilities to non-Lipschitz mechanical systems"*, D. E. P. Vanpoucke and S. Wenmackers, *European Physical Journal* **X**, YY-YY (2020) [ArXiv](https://arxiv.org/abs/2001.10375)</br>
**<a name="ref_mal">\[2\]</a>** *"Norton's slippery slope"*, D. B. Malament, *Philosophy of Science* **75**, 799-816 (2008)</br>
**<a name="ref_nort">\[3\]</a>** *"Causation as folk science"*, J. D. Norton, *Philosophers' Imprint* **3** (2003) and
*"The dome: An unexpectedly simple failure of determinism"*, J. D. Norton, *Philosophy of Science* **75**, 786-798 (2008)</br>

