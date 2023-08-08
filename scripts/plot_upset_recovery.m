% Simulate and create Figure 9b: Upset recovery with and without
% deactivated motor.

% Disclamer:
%   SPDX-License-Identifier: GPL-3.0-only
% 
% 	Copyright (C) 2022-2023 Yannic Beyer
%   Copyright (C) 2022 TU Braunschweig, Institute of Flight Guidance
% *************************************************************************

addPathFtc();

init_Minnie_Loiter_FTC;

is_tikz_export_desired = false;

%% Simulate upset recovery without deactivated motor

IC.q_bg = euler2Quat([pi;0;0]);

% disable stick inputs
block = find_system('QuadcopterSimModel_Loiter_FTC','SearchDepth',1,'Name','Manual Switch');
set_param(block{1}, 'sw', '0');

failure_time_mot_1      = 1000;
failure_time_mot_2      = 1000;
failure_time_mot_3      = 1000;
failure_time_mot_4      = 1000;

Time_end = 4;

out = sim('QuadcopterSimModel_Loiter_FTC','StartTime','0','StopTime',num2str(Time_end));

di = 4;

Time = out.s_g.Time(1:di:end);
x_g = squeeze(out.s_g.Data(1,:,1:di:end));
y_g = squeeze(out.s_g.Data(2,:,1:di:end));
z_g = squeeze(out.s_g.Data(3,:,1:di:end));

n_z_g = getNzg( out.Euler_angles.Data, di );

%% Simulate upset recovery with deactived motor

failure_time_mot_2      = 0;

out = sim('QuadcopterSimModel_Loiter_FTC','StartTime','0','StopTime',num2str(Time_end));

Time = out.s_g.Time(1:di:end);
x_g_fail = squeeze(out.s_g.Data(1,:,1:di:end));
y_g_fail = squeeze(out.s_g.Data(2,:,1:di:end));
z_g_fail = squeeze(out.s_g.Data(3,:,1:di:end));

n_z_g_fail = getNzg( out.Euler_angles.Data, di );

%% Plotting and formatting

line_width = 1;

figure
[hAx,hLine1,hLine2]=plotyy(Time,[sqrt(x_g_fail.^2+y_g_fail.^2),z_g_fail,sqrt(x_g.^2+y_g.^2),z_g],Time,[n_z_g_fail(:),n_z_g(:)]);
hLine1(3).LineStyle = '--';
hLine1(4).LineStyle = '--';
hLine2(2).LineStyle = '--';
hLine2(1).Color=hLine1(3).Color;
hLine2(2).Color=hLine1(3).Color;
hLine1(3).Color=hLine1(1).Color;
hLine1(4).Color=hLine1(2).Color;
hLine2(2).Color=hLine2(1).Color;
for i = 1:length(hLine1)
    hLine1(i).LineWidth = line_width;
end
for i = 1:length(hLine2)
    hLine2(i).LineWidth = line_width;
end
xlabel('Time, s','interpreter','latex')
hAx(1).XLim = [0,Time_end];
hAx(2).XLim = hAx(1).XLim;
hAx(1).YLim = [0,4];
hAx(1).YTick=[0,1,2,3,4];
hAx(2).YLim=[-1,1];
hAx(2).YTick=[-1,-0.5,0,0.5,1];
ylabel(hAx(1),'Position, m','interpreter','latex')
legend([hLine1(1),hLine1(2),hLine2(1),hLine2(2)],'$\sqrt{x_g^2+y_g^2}$','$z_g$','$n_{z,g}$','interpreter','latex')
ylabel(hAx(2),'Vectical Lean Vector Component','interpreter','latex')
grid on

%% TikZ export

if is_tikz_export_desired
    tikzwidth = '\figurewidth';
    tikzheight = '\figureheight';
    tikzfontsize = '\tikzstyle{every node}=[font=\tikzfontsize]';
    extra_axis_options = {'ylabel style={font=\tikzfontsize}','xlabel style={font=\tikzfontsize}','legend style={font=\tikzfontsize}'};
    matlab2tikz('upset_recovery.tex','width',tikzwidth,'height',tikzheight,'extraCode',tikzfontsize,'extraAxisOptions',extra_axis_options);
end

%%

function n_z_g = getNzg( euler_angles, di )
num_pts = round(size(euler_angles,3)/di);
n_z_g = zeros(1,num_pts);
for i = 0:num_pts
    M_bg = euler2Dcm(squeeze(euler_angles(:,1,di*i+1)));
    lean_vector = dcm2LeanVector(M_bg);
    n_z_g(i+1) = lean_vector(3);
end
end