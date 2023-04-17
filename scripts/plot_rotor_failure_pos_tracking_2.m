

log_file_name = '00000179.BIN';
log_path = ['/home/yannic/PowerFolders/Quadcopter_motor_failure/Logs_Minnie/',log_file_name];
out = Ardupilog( log_path );

%%
figure
plotRotorFailuresPosTracking2(out,4,1);
plotRotorFailuresPosTracking2(out,3,0);

legend('reference','w/o failure','w/ failure','interpreter','latex')

annotation('arrow', [.27 .5], [.15 .15]);

%%
tikzwidth = '\figurewidth';
tikzheight = '\figureheight';
tikzfontsize = '\tikzstyle{every node}=[font=\tikzfontsize]';
extra_axis_options = {'ylabel style={font=\tikzfontsize}','xlabel style={font=\tikzfontsize}','legend style={font=\tikzfontsize}','legend style={at={(0.5,0.5)}, anchor=center}'};
matlab2tikz('flighttest_failure_pattern_2.tex','width',tikzwidth,'height',tikzheight,'extraCode',tikzfontsize,'extraAxisOptions',extra_axis_options);
