# Incremental Passive Fault-Tolerant Control for Quadrotors Subjected to a Complete Rotor Failure

This repository contains the source code used for the research results in Ref. [1].
The publication is about passive fault-tolerant control of quadrotors subjected to a complete rotor failure. 
Passive means that the error does not have to be detected.
The controller presented here is based on the methods of Incremental Nonlinear Dynamic Inversion (INDI) and Control Allocation (CA) with prioritization of roll and pitch attitude over yaw.
This code can be used to reproduce the figures from Ref. [1], on the one hand, and to investigate other rotor failures in simulation, on the other.
For further information see Ref. [1].

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
    - Aerospace Blockset, Aerospace Toolbox (purpose: receive ground altitude from FlightGear visualization; if you don't have it, you can comment out the Simulink block _Environment/From FlightGear_)  
    - Simulink Coder, MATLAB Coder (purpose: only for code generation for flight tests; if you don't have it, you can still run the simulations)

- **This repository:**  
  Clone this project including the submodules LADAC and LADAC-Example-Data:
  ```
  git clone --recursive https://github.com/iff-gsc/passive-ftc-quadrotor.git
  ```

- **FlightGear (optional; for visualization):** 
  - You should install FlightGear for visualization.
  Tested versions are FlightGear 3.4.0 and FlightGear 2019.1.1 but others should also work.
  - On Windows you have to copy and paste the folder _<quadrotor>/modules/ladac-examples-data/FlightGear/<models>_ into _$FG_HOME/Aircraft/_


## Example

Open and run `paper_plots` in _<passive-ftc-quadrotor>/scripts/_ in MATLAB (if it is not on the MATLAB path already, click _Change Folder_ or _Add to Path_).
After some time the figures of Ref. [1] will appear.

If you want to visualize the quadrotor, start FlightGear by executing `runfg_IRIS.sh` (Linux) or `runfg_IRIS.bat` which are located in _<passive-ftc-quadrotor>/modules/ladac-examples-data/FlightGear/_.

To do: ArduPilot implementation

## How to use?

- Customize simulation:  
  - You can initialize the simulation (quadrotor model and controller) by running `init_Minnie_Loiter_FTC` in _<passive-ftc-quadrotor>/scripts/_.
  - You can change the parameters `failure_...` in order to create different failure scenarios.

- To do: ArduPilot implementation
