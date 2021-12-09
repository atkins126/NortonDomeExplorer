<a id='Top'></a>[Back to main page](../README.md)
1. [Installation](#Install)<br />
    1.1. [Binaries](#)<br />
	1.2. [Source](#)<br />
2. [Users manual](#Manual)<br />
	2.1. [The Interface](#)
	2.2. [Quick Tutorial: Running NortonDomeExplorer step by step.](#)
	2.3. [Settings and Options]()
	

<div ALIGN="right"  > 
    
[Top](#Top)  </div>

# <a id='Install'></a> 1. Installation
* The program can be downloaded as [64bit Windows binary](../bin/). Alternatively, it can be compiled 
from the [source](../source/DomeExplorer) using a [Delphi-compiler](https://www.embarcadero.com/products/delphi). 
* The support program for generating the vector-field of the phase space can be
compiled from the Fortran [source](../source/PhaseSpace). The [gnuplot](http://www.gnuplot.info/) script
for generating the animation can be found in the same folder.

<div ALIGN="right"  > 
    
[Top](#Top)  </div>

# <a id='Manual'></a> 2. Running the program
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


