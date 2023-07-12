% Simulate and create Figure 12a: Comparison of position control with one
% total rotor failure in simulation and flight test.

% Disclamer:
%   SPDX-License-Identifier: GPL-2.0-only
% 
% 	Copyright (C) 2022-2023 Yannic Beyer
%   Copyright (C) 2022 TU Braunschweig, Institute of Flight Guidance
% *************************************************************************

addPathFtc();

init_Minnie_Loiter_FTC;

is_tikz_export_desired = false;

%% Simulate and plot position tracking

% disable stick inputs
block = find_system('QuadcopterSimModel_Loiter_FTC','SearchDepth',1,'Name','Manual Switch');
set_param(block{1}, 'sw', '1');

% single rotor failure after 1 second
failure_time_mot_1      = 1000;
failure_time_mot_2      = -4;
failure_time_mot_3      = 1000;
failure_time_mot_4      = 1000;

stop_time = 25;

out = sim('QuadcopterSimModel_Loiter_FTC','StartTime','-5','StopTime',num2str(stop_time));

plotRotorFailuresPosTracking(out,1,1,0,is_tikz_export_desired)

%% Plot SITL results from log

this_file_path = fileparts(mfilename('fullpath'));

log_file_name = 'sitl_log.BIN';
log_path = [this_file_path,'/../data/',log_file_name];
out = Ardupilog( log_path );

plotRotorFailuresPosTracking(out,0,1,1,is_tikz_export_desired);

%% Plot flight test results from log

log_file_name = 'flight_test_1_log.BIN';
log_path = [this_file_path,'/../data/',log_file_name];
out = Ardupilog( log_path );

plotRotorFailuresPosTracking(out,0,1,0,is_tikz_export_desired);

%% legend

figure(1)
legend('reference','w/o EKF','w/ EKF','flight test')
tikzwidth = '\figurewidth';
tikzheight = '\figureheight';
tikzfontsize = '\tikzstyle{every node}=[font=\tikzfontsize]';
extra_axis_options = {'ylabel style={font=\tikzfontsize}','xlabel style={font=\tikzfontsize}','legend style={at={(0.5,0.5)}, anchor=center}'};

annotation('arrow', [.3 .5], [.15 .15]);

if is_tikz_export_desired
    matlab2tikz('compare_motor_failure_pattern.tex','width',tikzwidth,'height',tikzheight,'extraCode',tikzfontsize,'extraAxisOptions',extra_axis_options);
end
