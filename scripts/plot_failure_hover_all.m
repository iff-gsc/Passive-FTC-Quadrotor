% Simulate and create Figure 10 and 11: Simulation of a total rotor failure
% in hover and Flight test with a total rotor failure in hover.

% Disclamer:
%   SPDX-License-Identifier: GPL-3.0-only
% 
%   Copyright (C) 2023 Yannic Beyer
%   Copyright (C) 2022 TU Braunschweig, Institute of Flight Guidance
% *************************************************************************

addPathFtc();

init_Minnie_Loiter_FTC;

is_tikz_export_desired = false;

%% Simulate and plot rotor failure

% disable stick inputs
block = find_system('QuadcopterSimModel_Loiter_FTC','SearchDepth',1,'Name','Manual Switch');
set_param(block{1}, 'sw', '0');

% single rotor failure after 1 second
failure_time_mot_1      = 1000;
failure_time_mot_2      = 1;
failure_time_mot_3      = 1000;
failure_time_mot_4      = 1000;

stop_time = 6;

out = sim('QuadcopterSimModel_Loiter_FTC','StartTime','-2','StopTime',num2str(stop_time));

plotRotorFailuresHover(out,'sim',is_tikz_export_desired);

%% Plot SITL rotor failure from log file

this_file_path = fileparts(mfilename('fullpath'));

log_file_name = 'sitl_log.BIN';
log_path = [this_file_path,'/../data/',log_file_name];
out = Ardupilog( log_path );

plotRotorFailuresHover(out,'sitl',is_tikz_export_desired);

%% Plot flight test rotor failure from log file

log_file_name = 'flight_test_1_log.BIN';
log_path = [this_file_path,'/../data/',log_file_name];
out = Ardupilog( log_path );

plotRotorFailuresHover(out,'flighttest',is_tikz_export_desired);
