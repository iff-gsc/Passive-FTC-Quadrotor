% Simulate and create Figure 9a: Lateral gust response compared with [20].

% Disclamer:
%   SPDX-License-Identifier: GPL-3.0-only
% 
% 	Copyright (C) 2022-2023 Yannic Beyer
%   Copyright (C) 2022 TU Braunschweig, Institute of Flight Guidance
% *************************************************************************

addPathFtc();

init_Minnie_Loiter_FTC;

is_tikz_export_desired = false;

%% Configure Simulink model

% disable stick inputs
block = find_system('QuadcopterSimModel_Loiter_FTC','SearchDepth',1,'Name','Manual Switch');
set_param(block{1}, 'sw', '0');

% adjust wind configuration
block = find_system('QuadcopterSimModel_Loiter_FTC/Environment','SearchDepth',1,'Name','Step');
set_param(block{1}, 'Time', '0');
set_param(block{1}, 'After', '[0;8.5;0]');
block = find_system('QuadcopterSimModel_Loiter_FTC/Environment','SearchDepth',1,'Name','Gain1');
set_param(block{1}, 'Gain', '1');

% no rotor failures
failure_time_mot_1      = 1000;
failure_time_mot_2      = 1000;
failure_time_mot_3      = 1000;
failure_time_mot_4      = 1000;

Time_end = 4;

di = 4;

%% Simulate wind step response using outer loop INDI from Smeur

fm_loiter.psc.inditype = 2;

out = sim('QuadcopterSimModel_Loiter_FTC','StartTime','-5','StopTime',num2str(Time_end));

idx = find(out.s_g.Time>=0);
Time = out.s_g.Time(idx(1:di:end));
x_g_smeur = squeeze(out.s_g.Data(1,:,idx(1:di:end)));
y_g_smeur = squeeze(out.s_g.Data(2,:,idx(1:di:end)));
z_g_smeur = squeeze(out.s_g.Data(3,:,idx(1:di:end)));

n_z_g_smeur = getNzg( out.Euler_angles.Data );
n_z_g_smeur = n_z_g_smeur(idx(1:di:end));

%% Simulate wind step response using outer loop INDI from this work

fm_loiter.psc.inditype = 1;

out = sim('QuadcopterSimModel_Loiter_FTC','StartTime','-5','StopTime',num2str(Time_end));

x_g = squeeze(out.s_g.Data(1,:,idx(1:di:end)));
y_g = squeeze(out.s_g.Data(2,:,idx(1:di:end)));
z_g = squeeze(out.s_g.Data(3,:,idx(1:di:end)));

n_z_g = getNzg( out.Euler_angles.Data );
n_z_g = n_z_g(idx(1:di:end));

%% Plotting and formatting

line_width = 1;

figure
[hAx,hLine1,hLine2]=plotyy(Time,[sqrt(x_g.^2+y_g.^2),z_g,sqrt(x_g_smeur.^2+y_g_smeur.^2),z_g_smeur],Time,[n_z_g(:),n_z_g_smeur(:)]);
hLine1(3).LineStyle = '--';
hLine1(4).LineStyle = '--';
hLine2(2).LineStyle = '--';
hLine2(1).Color=hLine1(3).Color;
hLine2(2).Color=hLine1(3).Color;
hLine1(3).Color=hLine1(1).Color;
hLine1(4).Color=hLine1(2).Color;
for i = 1:length(hLine1)
    hLine1(i).LineWidth = line_width;
end
for i = 1:length(hLine2)
    hLine2(i).LineWidth = line_width;
end
xlabel('Time, s','interpreter','latex')
hAx(1).XLim = [0,Time_end];
hAx(2).XLim = hAx(1).XLim;
ylabel(hAx(1),'Position, m','interpreter','latex')
legend([hLine1(1),hLine1(2),hLine2(1),hLine2(2)],'$\sqrt{x_g^2+y_g^2}$','$z_g$','$n_{z,g}$','interpreter','latex')
ylabel(hAx(2),'Vertical Lean Vector Component','interpreter','latex')
grid on

%% Export figure to TikZ

if is_tikz_export_desired
    tikzwidth = '\figurewidth';
    tikzheight = '\figureheight';
    tikzfontsize = '\tikzstyle{every node}=[font=\tikzfontsize]';
    extra_axis_options = {'ylabel style={font=\tikzfontsize}','xlabel style={font=\tikzfontsize}','ticklabel style={/pgf/number format/fixed}','legend style={font=\tikzfontsize}'};
    matlab2tikz('gust.tex','width',tikzwidth,'height',tikzheight,'extraCode',tikzfontsize,'extraAxisOptions',extra_axis_options);
end

%% Restore Simulink model configuration

block = find_system('QuadcopterSimModel_Loiter_FTC/Environment','SearchDepth',1,'Name','Step');
set_param(block{1}, 'Time', '3');
set_param(block{1}, 'After', '[0;10;0]');
block = find_system('QuadcopterSimModel_Loiter_FTC/Environment','SearchDepth',1,'Name','Gain1');
set_param(block{1}, 'Gain', '0');

%%

function n_z_g = getNzg( euler_angles )
num_pts = size(euler_angles,3);
n_z_g = zeros(1,num_pts);
for i = 1:num_pts
    M_bg = euler2Dcm(squeeze(euler_angles(:,1,i))) ;
    lean_vector = dcm2LeanVector(M_bg);
    n_z_g(i) = lean_vector(3);
end
end