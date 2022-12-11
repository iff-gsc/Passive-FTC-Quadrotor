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
addPathFtc();

%% controller parameters
% load parameters
copter = copterLoadParams( 'copter_params_Minnie_AIAA_JGCD_2022' );
fm_loiter = lindiCopterAutoCreate( copter, 'AgilityAtti', 0.7, ...
    'AgilityPos', 0.18, 'FilterStrength', 0, 'CntrlEffectScaling', 1 );
fm_loiter.psc.inditype = 1;

%% control inputs
% fly 5m square after 5s
simin = automatedStickCommands( );

%% initialize the Ardupilot Interface
ardupilotCreateInputBuses();

%% change the main struct from double to float
fm_loiter = structDouble2Single(fm_loiter);
simin = structDouble2Single(simin);

%% open Simulink model
open ArduCopter_MinnieLoiterFtc.slx