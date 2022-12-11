%  ** Parameter file of quadcopter (Minnie) **

% Disclamer:
%   SPDX-License-Identifier: GPL-2.0-only
% 
%   Copyright (C) 2020-2022 Yannic Beyer
%   Copyright (C) 2022 TU Braunschweig, Institute of Flight Guidance
% *************************************************************************

%% body parameters
% mass of vehicle, in kg
copter.body.m = 0.430;
% inertial matrix of vehicle, in kg.m^2
I_13 = 1.78e-06;
I_12 = 0;
I_23 = 0;
copter.body.I = [0.00108, I_12, I_13; ...
            I_12, 0.000792, I_23; ...
            I_13, I_23, 0.00162];

%% configuration parameters
% center of gravity position in c frame, in m
copter.config.CoG_Pos_c = [ 0; 0; 0 ];
% position of all propellers in c frame, in m
bx = 0.0795;
by = 0.099;
bz = 0.01;
copter.config.propPos_c = [ bx, -by, bz; ...
                            bx, by, bz; ...
                            -bx, by, bz; ...
                            -bx, -by, bz ]';
% direction of all propeller rotations, -1: right, 1 left
copter.config.propDir = [ -1; 1; -1; 1 ];
% orientation of the motors relative to the body
copter.config.M_b_prop1 = euler2Dcm([0,-pi/2,0]);
copter.config.M_b_prop2 = euler2Dcm([0,-pi/2,0]);
copter.config.M_b_prop3 = euler2Dcm([0,-pi/2,0]);
copter.config.M_b_prop4 = euler2Dcm([0,-pi/2,0]);
% TODO
% hit points for ground model
copter.config.hitPoints_c = [ copter.config.propPos_c + [ 0; 0; 0.02 ], ...
                           copter.config.propPos_c + [ 0; 0; -0.02 ] ];

%% propeller parameters
% propeller moment of inertia, kg.m^2
copter.prop.I = 5.2e-6 * 0.5;
% copter.prop.I = copter.prop.I * 9;
% propeller name specifying propeller map (name must be inside database)
copter.prop.name = '5x3E';
% factor to adjust thrust and torque (e.g. due to mounting)
copter.prop.correction_factor = 0.76;

%% motor parameters
% torque constant of the motor (KT=60/(2*pi*KV)), N.m/A
% with KV = 1700 RPM/V
copter.motor.KT = 60/(2*pi*1700);
% motor internal resistance, Ohm
copter.motor.R = 0.320;

%% battery parameters
% battery voltage, V
copter.bat.V = 22.2;

% TODO
%% aerodynamics
% reference surface of multicopter, in m^2
copter.aero.S = 0.018;
% minimum drag coefficient, in 1
copter.aero.C_Dmin = 1.5;
% maximum drag coefficient, in 1
copter.aero.C_Dmax = 2.0;
% maximum lift coefficient (whole vehicle), in 1
copter.aero.C_Lmax = 0.1;
% center of pressure (x_b, y_b direction), in m
copter.aero.CoP_xy = 0.03;
% center of pressure (z_b direction), in m
copter.aero.CoP_z = 0.01;
% damping moment coefficient for rotation, in N/(m^2*rad/s)
copter.aero.rate_damp = 0.65;
