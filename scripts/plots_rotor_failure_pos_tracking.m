% create single rotor failure plots

% Disclamer:
%   SPDX-License-Identifier: GPL-2.0-only
% 
%   Copyright (C) 2022 Yannic Beyer
%   Copyright (C) 2022 TU Braunschweig, Institute of Flight Guidance
% *************************************************************************

init_Minnie_Loiter_FTC;

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

plotRotorFailuresPosTracking(out,1,1)

%% SITL

log_file_name = '00000338.BIN';
log_path = ['/home/yannic/PowerFolders/Quadcopter_motor_failure/Logs_SITL/',log_file_name];
out = Ardupilog( log_path );

plotRotorFailuresPosTracking(out,0,1,1);

%% flight test

log_file_name = '00000171.BIN';
log_path = ['/home/yannic/PowerFolders/Quadcopter_motor_failure/Logs_Minnie/',log_file_name];
out = Ardupilog( log_path );

plotRotorFailuresPosTracking(out,0,1);

%% legend

figure(1)
legend('reference','w/o EKF','w/ EKF','flight test')
tikzwidth = '\figurewidth';
tikzheight = '\figureheight';
tikzfontsize = '\tikzstyle{every node}=[font=\tikzfontsize]';
extra_axis_options = {'ylabel style={font=\tikzfontsize}','xlabel style={font=\tikzfontsize}','legend style={at={(0.5,0.5)}, anchor=center}'};

annotation('arrow', [.3 .5], [.15 .15]);

matlab2tikz('compare_motor_failure_pattern.tex','width',tikzwidth,'height',tikzheight,'extraCode',tikzfontsize,'extraAxisOptions',extra_axis_options);

% figure(2)
% legend('x reference','y reference','x w/o EKF','y w/o EKF','x w/ EKF','y w/ EKF','x flight test','y flight test')
% tikzwidth = '\figurewidth';
% tikzheight = '\figureheight';
% tikzfontsize = '\tikzstyle{every node}=[font=\tikzfontsize]';
% extra_axis_options = {'ylabel style={font=\tikzfontsize}','xlabel style={font=\tikzfontsize}','legend style={at={(0.5,0.5)}, anchor=center}'};
% matlab2tikz('compare_motor_failure_pattern.tex','width',tikzwidth,'height',tikzheight,'extraCode',tikzfontsize,'extraAxisOptions',extra_axis_options);
