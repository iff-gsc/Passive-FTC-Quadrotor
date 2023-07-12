% Create Figure 12b: Flight test with max. speed 8 m/s.

% Disclamer:
%   SPDX-License-Identifier: GPL-3.0-only
% 
% 	Copyright (C) 2023 Yannic Beyer
%   Copyright (C) 2022 TU Braunschweig, Institute of Flight Guidance
% *************************************************************************

addPathFtc();

is_tikz_export_desired = false;

%% Plot flight test results from log

this_file_path = fileparts(mfilename('fullpath'));

log_file_name = 'flight_test_2_log.BIN';
log_path = [this_file_path,'/../data/',log_file_name];
out = Ardupilog( log_path );

figure
plotRotorFailuresPosTracking2(out,4,1);
plotRotorFailuresPosTracking2(out,3,0);

legend('reference','w/o failure','w/ failure','interpreter','latex')

annotation('arrow', [.27 .5], [.15 .15]);

%% Export TikZ

if is_tikz_export_desired
    tikzwidth = '\figurewidth';
    tikzheight = '\figureheight';
    tikzfontsize = '\tikzstyle{every node}=[font=\tikzfontsize]';
    extra_axis_options = {'ylabel style={font=\tikzfontsize}','xlabel style={font=\tikzfontsize}','legend style={font=\tikzfontsize}','legend style={at={(0.5,0.5)}, anchor=center}'};
    matlab2tikz('flighttest_failure_pattern_2.tex','width',tikzwidth,'height',tikzheight,'extraCode',tikzfontsize,'extraAxisOptions',extra_axis_options);
end
