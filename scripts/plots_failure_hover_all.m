% create single rotor failure plots

% Disclamer:
%   SPDX-License-Identifier: GPL-2.0-only
% 
%   Copyright (C) 2022 Yannic Beyer
%   Copyright (C) 2022 TU Braunschweig, Institute of Flight Guidance
% *************************************************************************

addPathFtc();

init_Minnie_Loiter_FTC;

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

plotRotorFailuresHover(out,'sim')

%% SITL

log_file_name = '00000338.BIN';
log_path = ['/home/yannic/PowerFolders/Quadcopter_motor_failure/Logs_SITL/',log_file_name];
out = Ardupilog( log_path );

plotRotorFailuresHover(out,'sitl');

%% flight test

log_file_name = '00000171.BIN';
log_path = ['/home/yannic/PowerFolders/Quadcopter_motor_failure/Logs_Minnie/',log_file_name];
out = Ardupilog( log_path );

plotRotorFailuresHover(out,'flighttest');
