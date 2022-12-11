function plotRotorFailuresPosTracking(data,is_sim,is_new_figure)

    if is_sim
        
        idx = find(data.s_g.Time>0)';
        idx2 = find(data.s_g_ref.Time>0)';
    
        % downsample
        idx = idx(1:12:end);
        idx2 = idx2(1:12:end);
        
        Time_pos_ref = data.s_g_ref.Time(idx2);
        x_g_ref = squeeze(data.s_g_ref.Data(1,1,idx2));
        y_g_ref = squeeze(data.s_g_ref.Data(2,1,idx2));
        Time_pos = data.s_g.Time(idx);
        x_g = squeeze(data.s_g.Data(1,:,idx));
        y_g = squeeze(data.s_g.Data(2,:,idx));
        
    else
        
        idx_failure = find(data.RCIN.C9 > 1500);
    
        Time_trigger = data.RCIN.TimeS(idx_failure(1));
        Time_start = Time_trigger-1;
        Time_end = Time_start + 30;
        try
            [ idx_pos, Time_pos ] = logGetIdxTime( data.ML2.TimeS, Time_start, Time_end );
            idx_pos = idx_pos(1:4:end);
            Time_pos = Time_pos(1:4:end) - 6;
            pos_0 = [data.ML2.xgm(idx_pos(1));data.ML2.ygm(idx_pos(1));data.ML2.zgm(idx_pos(1))];
            x_g = data.ML2.xgm(idx_pos)-pos_0(1);
            y_g = data.ML2.ygm(idx_pos)-pos_0(2);
        catch
            [ idx_pos, Time_pos ] = logGetIdxTime( data.XKF1.TimeS, Time_start, Time_end );
            pos_0 = [data.XKF1.PN(idx_pos(1));data.XKF1.PE(idx_pos(1));data.XKF1.PD(idx_pos(1))];
            Time_pos = Time_pos - 6;
            x_g = data.XKF1.PN(idx_pos)-pos_0(1);
            y_g = data.XKF1.PE(idx_pos)-pos_0(2);
        end
        
    end
    
    
    tikzwidth = '\figurewidth';
    tikzheight = '\figureheight';
    tikzfontsize = '\tikzstyle{every node}=[font=\tikzfontsize]';
    extra_axis_options = {'ylabel style={font=\tikzfontsize}','xlabel style={font=\tikzfontsize}','legend style={font=\tikzfontsize}'};

    
    line_width = 1;
    
    if is_new_figure
        figure(1)
    end
    if is_sim
        plot(x_g_ref,y_g_ref,'LineWidth',line_width)
        hold on
    end
    plot(x_g,y_g,'LineWidth',line_width)
    hold on
    grid on
    axis equal
    xlim([-1,6])
    ylim([-1,6])
    xticks([-1:6])
    yticks([-1:6])
    box on
    xlabel('East Position, m','interpreter','latex')
    ylabel('North Position, m','interpreter','latex')
    matlab2tikz('sim_motor_failure_pattern.tex','width',tikzwidth,'height',tikzheight,'extraCode',tikzfontsize,'extraAxisOptions',extra_axis_options);

    if is_new_figure
        figure(2)
    end
    if is_sim
        plot(Time_pos_ref,x_g_ref,'LineWidth',line_width)
        hold on
        plot(Time_pos_ref,y_g_ref,'LineWidth',line_width)
    end
    plot(Time_pos,x_g,'LineWidth',line_width)
    hold on
    plot(Time_pos,y_g,'LineWidth',line_width)
    grid on
    axis equal
    xlim([0,20])
    ylim([-1,6])
    yticks([-1:6])
    box on
    xlabel('East Position, m','interpreter','latex')
    ylabel('North Position, m','interpreter','latex')
    matlab2tikz('sim_motor_failure_pattern.tex','width',tikzwidth,'height',tikzheight,'extraCode',tikzfontsize,'extraAxisOptions',extra_axis_options);

end

function [ idx, Time_idx ] = logGetIdxTime( Time, Time_start, Time_end )

    idx = find(Time - Time_start > 0 & Time < Time_end);
    Time_idx = Time(idx) - Time_start;
    
end
