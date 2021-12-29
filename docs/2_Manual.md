<a id='Top'></a>[Back to main page](../README.md)
1. [Installation](#Install)<br />
    1.1. [Binaries](#InstallBin)<br />
	1.2. [Source](#InstallSrc)<br />
2. [Users manual](#ManualND)<br />
	2.1. [The interface](#InterfaceND) <br />
	2.2. [Quick Tutorial: Running the DomeExplorer step by step](#RunningND) <br />
	

<div ALIGN="right"  > 
    
[Top](#Top)  </div>

# <a id='Install'></a> 1. Installation  

The two programs developed for the paper *"Assigning probabilities to non-Lipschitz mechanical systems"*,[\[1\]](3_ReferenceList.md#ref_DS1)
can be downloaded from this git repository:
 - **NortonDomeExplorer** An object-oriented program written in Pascal with a simple GUI, which allows you to investigate the discretized version 
 of the dynamics on Malament's mounds. (The discrete dynamics represents a point-mass placed at a chosen distance from the apex of a Malament's mound with a chosen velocity.)
 - **PhaseSpace** A small support program written in Fortran-95 to generate the vector field of the phase space. An additional gnuplot script is provided to combine the results into a single animation.

For both programs, 64-bit Windows executables are available, as well as their source code. 

##  <a id='InstallBin'></a> 1.1. Binaries
The binaries are located in the [bin](../bin/) folder of the repository. To install, just download the zip-file and unzip. The programs should 
run out of the box on a recent Windows system.

##  <a id='InstallSrc'></a> 1.2. Source
For those interested in the inner workings of the programs, the source is available in the [source](../source/) folder. The programs 
can be compiled from source as well.
### 1.2.1. DomeExplorer
The DomeExplorer was originally developed using the [Borland Delphi-compiler](https://www.embarcadero.com/products/delphi). 
Since then, the code was ported to Free Pascal using the free [Lazarus IDE](https://www.lazarus-ide.org/), and the provided source and 
support files should make it easy for compilation with Lazarus. (In theory, the source should still be compatible with the Delphi-compiler 
as we retained the Delphi format-file for the main form.)  
* Download all files in the [source](../source/DomeExplorer/) directory to a folder of your choice.
* Open de *Dome_v1_5_00.lpi*-file using Lazarus.
* In the Lazarus IDE go to **Project** -> **Project Options** and set the **Target platform** options in the 
  **Config and Target** (under **Compiler Options**) to your specific architecture. (If you do not know what to 
  choose, just select **default** and you should be fine.) Save these settings by clicking the **OK** button.
* Compile the program by simply clicking the **Run** button (or F9).

In case you are using the *Delphi*-compiler, you will need to open the *Dome_v1_5_00.dpr*-file instead. As Delphi 
and Lazarus have slightly different definitions with regard to the positioning of components, the layout of the main 
form may need some final tweaking.

### 1.2.2. PhaseSpace
The PhaseSpace support program is written in Fortran-95 and can be compiled with a Fortran compiler.
* Download the [source file](../source/PhaseSpace/PhaseSpace.f95).
* Open in your favourite coding environment such as [Code::Blocks](https://www.codeblocks.org/)
or [Visual Studio Code](https://code.visualstudio.com/) where you have a fortran compiler available.
* Compile and run the program.
For post-processing the results into an animated gif, download the associated 
[gnuplot script](../source/PhaseSpace/plotVector_animate.gpl) and run in with 
your [gnuplot](http://www.gnuplot.info/) installation.

<div ALIGN="right"  > 
    
[Top](#Top)  </div>

# <a id='ManualND'></a> 2. Running the DomeExplorer program

## <a id='InterfaceND'></a> 2.1. Graphical User Interface

![GUI_Layout](../images/NDE_Layout.png)
<p align="center" width=60%>
Different parts of the DomeExplorer GUI.</p>

The DomeExplorer comes with a simple Graphical User interface (GUI), which allows one to setup and run simulations, 
as well as evaluate and store the results. The GUI contains three major parts:
 1. <b> Simulation Settings:</b> In this panel, specific details of the impending simulation are defined (*cf.* [Tutorial](#RunningND) 
 for the specific settings and our [paper](3_ReferenceList.md#ref_DS1) for further details).
 2. <b> Simulation & Processing:</b> This panel contains a set of buttons related to both running the simulation and presenting
 the results.
 3. <b> Plot Area:</b> The results are graphically presented on the screen in this part. A color scale is included, showing the range
 of values presented.
 4. <b> Menu:</b> The picture of the results presented in the *Plot Area* can be saved as an image via **File -> Save Image**, 
 and the program can be terminated either via **File -> Exit Program** or through the close button. The **Help** menu provides access to 
 these online github information pages. 
 5. <b> Information:</b> Depending on the simulation settings, running the simulation may take a while. To provide a visual feedback to the 
 user (showing the program did not get stuck), a progress bar is provided at the bottom of the *Plot Area*. The run time used for the last 
 simulation is presented below, while the total run time for all simulations in the current session is shown at the top of the screen.


## <a id='RunningND'></a> 2.2. Quick Tutorial: Running the DomeExplorer step by step

With the DomeExplorer, the phase space of initial values for the different Malament-mounds can be explored. In [our paper](3_ReferenceList.md#ref_DS1),
we discuss how the *real space* finite difference approach implemented in the DomeExplorer provides insight in the *infinitesimal* phase space 
of our Alpha-theory based model of the dynamics on the mounds. In the short tutorial below, all simulations settings will be discussed. This 
will enable you to run your own simulations, to either verify the results presented in [the paper](3_ReferenceList.md#ref_DS1) or to perform your own
investigation into the specifics of the dynamics on Malament's mounds.

![GUI_RunA](../images/NDE_Controls.png)
<p align="center" width=60%>
Setting up a simulation using the DomeExplorer GUI.</p>


### 2.2.1. Setting up a simulation
All settings of a simulation can be found on the *simulation settings panel*, as indicated in the figure above.
 1. <b> Initial values:</b> The two initial conditions of the initial value problem at hand can be formulated in two ways. Either as the
 position at time *t=0* and the position after a first timestep (option **R0,R1**, or using the notation of the paper: **R<sub>n,0</sub>,R<sub>n,1</sub>**), or 
 as the position and velocity at *t=0* (option **R0,V0**).<br />
 Depending on the selection, the recurrence relation given in [equation 4](3_ReferenceList.md#ref_DS1): 
 R<sub>n</sub>(m) = R<sub>n</sub>(m-1)<sup>a</sup>/n<sup>2</sup> + 2 R<sub>n</sub>(m-1) - R<sub>n</sub>(m-2), is initialised by two 
 initial positions directly, or by an initial position and a velocity, which is transformed into two initial positions. In practice, for both modes the
 same recurrence relation is iterated. However, the graphical representation in the *Plot Area* will either present initial pairs **(R0,R1)** or **(R0,V0)**
 depending on the mode.  
 2. <b> Point 1/2 minimum and maximum values:</b> The DomeExplorer evaluates the recurrence relation for each initial value pair corresponding with a single 
 pixel in the 500x500 pixel *Plot Area* (*i.e.* 250 000 initial value pairs are considered). *Point 1* refers to **R0**, while *Point 2* refers to either **R1** or **V0**.
 For each pixel, the initial value pair is calculated as a linear 
 grid ranging in \[min,max\], as provided by the user. **Note:** As the pair **(R0,R1)=(0,0)** corresponds to the singular solution of the initial value problem, 
 which can be tought of as the only point with an infinite *T* value (or within the context of the DomeExplorer a value of Delta*T*\*(Maximum \# Iterations) ), 
 it is best to exclude it from the chosen intervals. Otherwise it will dominate the color scale, and one ends up with a black *Plot Area* with a single red pixel.
 3. <b> *a* value:</b> The power in the initial value problem of Malament's mound, given by [equation 1](3_ReferenceList.md#ref_DS1). Values are limited to the 
 range \]0,1\[. The special case of Norton's Dome is obtained by setting ***a*=0.5**.
 4. <b> Delta*T*:</b> This is the discrete time step (also *1/n*, *cf.* [paper](3_ReferenceList.md#ref_DS1)) used in the recurrence relation. When modifying this
 variable, it is important to note that there exists a scaling relation between the time step (*1/n*) and the **R<sub>n</sub>** values: *n*<sup>-2/(1-*a*)</sup>. 
 In practice, this means that for Norton's dome (*a*=1/2), if one reduces Delta*T* by a factor of 10 and the maximum **R0,R1** values by a factor of 10 000, 
 the exact same picture is obtained.
 5. <b> Maximum \# Iterations:</b> The maximum number of iterations of the recurrence relation that are being calculated. Higher values provide a more accurate estimate 
 of the *delay time* **T**, corresponding to the time the mass starts sliding off the mound (in the continuous case). 
 
![GUI_RunB](../images/NDE_Simulation.png)
<p align="center" width=60%>
Running the simulation and selecting the results to present using the DomeExplorer GUI.</p>

### 2.2.2. Running the simulation
Once the settings are selected, the simulation can be run and results visualised using the buttons present on the *Simulation and Processing* panel.

  6. <b> Run Simulation:</b> Pressing this button starts the simulation. Progess of the simulation can be tracked via the progressbar.
  7. <b> Draw *T*:</b> Once the simulation has finished, the *Time used* will be shown and the *Plot Area* will turn into a grey square. Then, the results for the  
  *delay time* **T** can be visualised by pressing this button. The *color scale* indicates the largest and smallest values obtained in the entire presented
  phase space.
  8. <b> Draw Flips/Draw Error Code:</b> Support functionality which for each pixel indicates how many times the path starting with these initial conditions 
  crosses the apex (**Flips**) or if any numerical errors were encountered (**Error Code**: 0=No error, 1=Division by zero, 2=Overflow, 
  3=Invalid operation, 4=Endposition >10<sup>60</sup>).
  9. <b>Draw Endval/log(EndVal):</b> Plot the final position (or log thereof) of a path starting with the initial conditions as given by the pixel.
  10. <b> File->Save Image :</b> The image presented in the *Plot Area* can be saved as an image.


