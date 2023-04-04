% init Arducopter Interface for quadcopter Minnie with autopilot Dragonfly

% Disclamer:
%   SPDX-License-Identifier: GPL-2.0-only
% 
% 	Copyright (C) 2022 Yannic Beyer
% 	Copyright (C) 2022 Fabian Guecker
% 	Copyright (C) 2022 Eike Bremers
%   Copyright (C) 2022 TU Braunschweig, Institute of Flight Guidance
% *************************************************************************

%% add to path
clc_clear;
addPathFtc();

%% controller parameters
% load parameters
copter = copterLoadParams( 'copter_params_Minnie_AIAA_JGCD_2022' );
lindi = lindiCopterAutoCreate( copter, 'AgilityAtti', 0.6, 'AgilityPos', 0.2, 'CntrlEffectScaling', 0.9 );

%% control inputs
% fly 5m square after 5s
simin = automatedStickCommands( );

%% initialize the Ardupilot Interface
ardupilotCreateInputBuses();

%% change the main struct from double to float
lindi = structDouble2Single(lindi);
simin = structDouble2Single(simin);
lindi.ts = double(lindi.ts);

%% open Simulink model
open ArduCopter_MinnieLindiCopterFtc.slx