% Initialize simulation of quadcopter Minnie with fault-tolerant loiter
% controller

% Disclamer:
%   SPDX-License-Identifier: GPL-3.0-only
% 
%   Copyright (C) 2020-2023 Yannic Beyer
%   Copyright (C) 2022 TU Braunschweig, Institute of Flight Guidance
% *************************************************************************

%% add to path
addPathFtc();
clc_clear;

%% rotor failure parameters
failure_time_mot_1      = 1000;
failure_time_mot_2      = 1;
failure_time_mot_3      = 1000;
failure_time_mot_4      = 1000;

%% control inputs
% fly 5m square after 5s
simin = automatedStickCommands( );

%% load physical copter parameters
copter = copterLoadParams( 'copter_params_Minnie_AIAA_JGCD_2022' );

%% environment parameters
envir = envirLoadParams('params_envir','envir',0);

%% controller parameters
% load parameters
fm_loiter = lindiCopterAutoCreate( copter, 'AgilityAtti', 0.5, ...
    'AgilityPos',0.2,'FilterStrength', 0, 'CntrlEffectScaling', 1 );
fm_loiter.psc.inditype = 1;

%% initial conditions (IC)
% initial angular velocity omega_Kb, in rad/s
IC.omega_Kb = [ 0; 0; 0 ];
% initial orientation in quaternions q_bg
IC.q_bg = euler2Quat( [ 0; 0; 0 ] );
% initial velocity V_Kb, in m/s
IC.V_Kb = [ 0; 0; 0 ];
% initial position s_Kg, in m
IC.s_Kg = [ 0; 0; 0 ];
% initial motor angular velocity, in rad/s
IC.omega_mot = [ 1; 1; 1; 1 ] * 843;

%% load ground parameters (grnd)
grnd = groundLoadParams( 'params_ground_default' );

%% reference position lat, lon, alt
% initial latitude, in deg
pos_ref.lat = 37.6117;
% initial longitude, in deg
pos_ref.lon = -122.37822;
% initial altitude, in m
pos_ref.alt = 15;

%% Flight Gear settings for UDP connection
% Flight Gear URL
fg.remoteURL = '127.0.0.1';
% fdm receive port of Flight Gear
fg.remotePort = 5502;

%% Open Simulink model
open_model('QuadcopterSimModel_Loiter_FTC')