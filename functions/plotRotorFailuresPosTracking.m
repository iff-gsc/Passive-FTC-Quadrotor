function plotRotorFailuresPosTracking(data,is_sim,is_new_figure,is_sitl,is_tikz)

    if nargin < 4
        is_sitl = false;
    end
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
        V_Kg_ref = squeeze(data.V_Kg_ref.Data(idx2,:)');
        V_K_ref = vecnorm(V_Kg_ref,2,1);
        V_Kg = squeeze(data.V_Kg.Data(:,:,idx));
        V_K = vecnorm(V_Kg,2,1);
        
    else
        
        idx_failure = find(data.RCIN.C9 > 1500);
    
        Time_trigger = data.RCIN.TimeS(idx_failure(1));
        Time_start = Time_trigger + 5;
        if is_sitl
            Time_end = Time_start + 30;
        else
            Time_end = Time_start + 20;
        end
        try
            [ idx_pos, Time_pos ] = logGetIdxTime( data.ML2.TimeS, Time_start, Time_end );
            idx_pos = idx_pos(1:4:end);
            Time_pos = Time_pos(1:4:end) - 6;
            pos_ref_0 = [data.ML2.xgr(idx_pos(1));data.ML2.ygr(idx_pos(1));data.ML2.zgr(idx_pos(1))];
            % pos_0 = [data.ML2.xgm(idx_pos(1));data.ML2.ygm(idx_pos(1));data.ML2.zgm(idx_pos(1))];
            x_g = data.ML2.xgm(idx_pos)-pos_ref_0(1);
            y_g = data.ML2.ygm(idx_pos)-pos_ref_0(2);
            V_K = sqrt(data.ML2.ugm(idx_pos).^2+data.ML2.vgm(idx_pos).^2);
        catch
            [ idx_pos, Time_pos ] = logGetIdxTime( data.XKF1.TimeS, Time_start, Time_end );
            pos_0 = [data.XKF1.PN(idx_pos(1));data.XKF1.PE(idx_pos(1));data.XKF1.PD(idx_pos(1))];
            Time_pos = Time_pos - 6;
            x_g = data.XKF1.PN(idx_pos)-pos_0(1);
            y_g = data.XKF1.PE(idx_pos)-pos_0(2);
            V_K = sqrt(data.XKF1.VN(idx_pos).^2+data.XKF1.VE(idx_pos).^2);
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
        plot(y_g_ref,x_g_ref,'LineWidth',line_width)
        hold on
    end
    plot(y_g,x_g,'LineWidth',line_width)
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
    if is_tikz
        matlab2tikz('sim_motor_failure_pattern.tex','width',tikzwidth,'height',tikzheight,'extraCode',tikzfontsize,'extraAxisOptions',extra_axis_options);
    end
    
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
    if is_tikz
        matlab2tikz('sim_motor_failure_pattern.tex','width',tikzwidth,'height',tikzheight,'extraCode',tikzfontsize,'extraAxisOptions',extra_axis_options);
    end
    
    if is_new_figure
        figure(3)
        hold on
    end
    if is_sim
        plot(Time_pos_ref,V_K_ref,'LineWidth',line_width)
    end
    plot(Time_pos,V_K,'LineWidth',line_width)
    grid on
    box on
    xlabel('Time, s','interpreter','latex')
    ylabel('Velocity, m/s','interpreter','latex')
    if is_tikz
        matlab2tikz('sim_motor_failure_pattern_vel.tex','width',tikzwidth,'height',tikzheight,'extraCode',tikzfontsize,'extraAxisOptions',extra_axis_options);
    end
end

function [ idx, Time_idx ] = logGetIdxTime( Time, Time_start, Time_end )

    idx = find(Time - Time_start > 0 & Time < Time_end);
    Time_idx = Time(idx) - Time_start;
    
end
