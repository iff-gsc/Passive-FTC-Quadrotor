% Create Figure 3: Static motor speed as a function of the static throttle
% with and without drag factor d.

% Disclamer:
%   SPDX-License-Identifier: GPL-3.0-only
% 
% 	Copyright (C) 2022-2023 Yannic Beyer
%   Copyright (C) 2022 TU Braunschweig, Institute of Flight Guidance
% *************************************************************************

addPathFtc();

is_tikz_export_desired = false;

[k,d]=propMapFitGetFactors(copter.prop.map_fit);

u = 0:0.01:1;

omega = motorStaticSpeed(copter.motor.KT,copter.motor.R,copter.bat.V,d,u);
omega_d0 = motorStaticSpeed(copter.motor.KT,copter.motor.R,copter.bat.V,0,u);

figure
plot(u,omega,'k-')
hold on
plot(u,omega_d0,'k--')

set(gca,'TickLabelInterpreter','latex');
ylim([0,max(omega_d0)])
xlim([0,1])
xlabel('Static Throttle','interpreter','latex')
ylabel('Motor Angular Velocity','interpreter','latex')
set(gca,'XTick',[0,1], 'YTick', [0,max(omega_d0)])
yticklabels({'0','$\frac{V_\mathrm{bat}}{K_T}$'});

legend('$d>0$','$d=0$','location','northwest','interpreter','latex')

if is_tikz_export_desired
    extra_axis_options = {'ylabel style={font=\tikzfontsize}','xlabel style={font=\tikzfontsize}','legend style={font=\tikzfontsize}'};
    tikzfontsize = '\tikzstyle{every node}=[font=\tikzfontsize]';
    matlab2tikz('motor_speed_static.tex','width','\figurewidth','height','\figureheight','extraCode',tikzfontsize,'extraAxisOptions',extra_axis_options);
end
