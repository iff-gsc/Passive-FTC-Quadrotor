# Incremental Passive Fault-Tolerant Control for Quadrotors Subjected to a Complete Rotor Failure

This repository contains the source code used for the research results in [1].
The publication is about passive fault-tolerant control of quadrotors subjected to a complete rotor failure. 
Passive means that the error does not have to be detected.
The controller presented here is based on the methods of Incremental Nonlinear Dynamic Inversion (INDI) and Control Allocation (CA) with prioritization of roll and pitch attitude over yaw.
This code can be used to reproduce the figures from [1], on the one hand, and to investigate other rotor failures in simulation, on the other.
For further information see [1].

<div align="center">
<h3>Flight Test Video</h3>
  <a href="https://youtu.be/g6vfgj2IRvE">
    <img 
      src="https://img.youtube.com/vi/g6vfgj2IRvE/0.jpg" 
      alt="Flight test" 
      style="width:50%;">
  </a>
</div>


## Reference

[1] Beyer, Y., Steen, M., & Hecker, P. (2022). Incremental Passive Fault-Tolerant Control for Quadrotors Subjected to a Complete Rotor Failure.


## Installation

- **MATLAB:**  
  - You need MATLAB/Simulink 2018b or later (older versions may work but they are not supported).
  - You also need the following MATLAB toolboxes:
    - Curve Fitting Toolbox (purpose: propeller map interpolation; if you don't have it, you can replace the propeller map interpolation with the simple propeller model in Ref. [1])  
    - Simulink Coder, MATLAB Coder (purpose: only for code generation for flight tests; if you don't have it, you can still run the simulations)

- **This repository:**  
  Clone this project including the submodules LADAC and LADAC-Example-Data:
  ```
  git clone --recursive https://github.com/iff-gsc/passive-ftc-quadrotor.git
  ```

- **FlightGear (optional; for visualization):**  
  You should install FlightGear for visualization.
  Tested versions are FlightGear 3.4.0 and FlightGear 2019.1.1 but others should also work.


## Example

1. Open and run [init_Minnie_Loiter_FTC](scripts/init_Minnie_Loiter_FTC.m) located in _scripts_ in MATLAB (if it is not on the MATLAB path already, click _Change Folder_ or _Add to Path_).  
2. The Simulink model [QuadcopterSimModel_Loiter_FTC](models/QuadcopterSimModel_Loiter_FTC.slx) located in _models_ should appear after step 1. Run this model.
3. Run FlightGear visualization by executing [runfg_IRIS.sh](FlightGear/runfg_IRIS.sh) (Linux) or [runfg_IRIS.bat](FlightGear/runfg_IRIS.bat) (Windows) located in the _FlightGear_ folder.

By default the quadrotor will be initialized in hover and start to fly a square after 5 seconds.
The front right motor fails after 6 seconds.

After some time the figures of Ref. [1] will appear.

If you want to visualize the quadrotor, start FlightGear by executing `runfg_IRIS.sh` (Linux) or `runfg_IRIS.bat` which are located in _<passive-ftc-quadrotor>/modules/ladac-examples-data/FlightGear/_.

To do: ArduPilot implementation

## How to use?

- Customize simulation:  
  - You can initialize the simulation (quadrotor model and controller) by running [init_Minnie_Loiter_FTC](scripts/init_Minnie_Loiter_FTC.m) in the _scripts_ folder.
  - You can change the parameters `failure_...` in order to create different failure scenarios.
- You can create the figures from [1] by running the `plot_...` files located in the _scripts_ folder.
- You can implement the Simulink flight controller in ArduPilot in order to perform flight tests.
T
  - Run [init_Arducopter_Minnie_FTC](scripts/init_Arducopter_Minnie_FTC.m) located in the _scripts_ folder.
  This will initialize and open the Simulink model [ArduCopter_MinnieLoiterFtc](models/ArduCopter_MinnieLoiterFtc.slx).
  - Click on the `Build Model` button in the menu of the Simulink model in order to generate C++ code.
  - Continue with the instructions in the Readme located in _modules/ladac/utilities/interfaces_external_programs/ArduPilot_custom_controller_.  
  - After successful implementation of the C++ code in ArduPilot you may want to perform SITL simulations before the flight test.
  Therefore, use the initialization script [init_quadcopter_Minnie_ArduPilot_SITL](scripts/init_quadcopter_Minnie_ArduPilot_SITL.m) and follow the instructions in the Readme located in _modules/ladac/utilities/interfaces_external_programs/ArduPilot_SITL.
  For the quadrotor Minnie you should load the ArduPilot parameters [Minnie.parm](data/Minnie.parm).
