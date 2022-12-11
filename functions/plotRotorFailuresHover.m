function plotRotorFailuresHover(data,type)

    switch type
        case 'sim'
            is_sim = true;
        case 'sitl'
            is_sim = false;
        case 'flighttest'
            is_sim = false;
        otherwise
            error('type not recognized')
    end
    
    if is_sim
        
        idx = find(data.s_g.Time>0)';
        idx2 = find(data.input.Time>0)';
    
        % downsample
        idx = idx(1:12:end);
        idx2 = idx2(1:4:end);
        
        Time_pos = data.s_g.Time(idx);
        Time_rate = data.omega_Kb.Time(idx);
        Time_esc1 = data.motor_speed.Time(idx);
        Time_esc2 = Time_esc1;
        Time_esc3 = Time_esc1;
        Time_esc4 = Time_esc1;
        Time_u = data.input.Time(idx2);
        
        x_g = squeeze(data.s_g.Data(1,:,idx));
        y_g = squeeze(data.s_g.Data(2,:,idx));
        z_g = squeeze(data.s_g.Data(3,:,idx));
        p = squeeze(data.omega_Kb.Data(1,:,idx));
        q = squeeze(data.omega_Kb.Data(2,:,idx));
        r = squeeze(data.omega_Kb.Data(3,:,idx));
        is_rpm_available=true;
        omega_1 = squeeze(data.motor_speed.Data(idx,1));
        omega_2 = squeeze(data.motor_speed.Data(idx,2));
        omega_3 = squeeze(data.motor_speed.Data(idx,3));
        omega_4 = squeeze(data.motor_speed.Data(idx,4));
        u1 = squeeze(data.input.Data(idx2,1));
        u2 = squeeze(data.input.Data(idx2,2));
        u3 = squeeze(data.input.Data(idx2,3));
        u4 = squeeze(data.input.Data(idx2,4));
    else
        
        idx_failure = find(data.RCIN.C7 > 1500);
    
        Time_trigger = data.RCIN.TimeS(idx_failure(1));
        Time_start = Time_trigger-1;
        Time_end = Time_start + 6;
        try
            [ idx_rate, Time_rate ] = logGetIdxTime( data.ML3.TimeS, Time_start, Time_end );
            idx_rate = idx_rate(1:4:end);
            Time_rate = Time_rate(1:4:end);
            p = data.ML3.p(idx_rate)*pi/180;
            q = data.ML3.q(idx_rate)*pi/180;
            r = data.ML3.r(idx_rate)*pi/180;
        catch
            [ idx_rate, Time_rate ] = logGetIdxTime( data.RATE.TimeS, Time_start, Time_end );
            p = data.RATE.R(idx_rate)*pi/180;
            q = data.RATE.P(idx_rate)*pi/180;
            r = data.RATE.Y(idx_rate)*pi/180;
        end
        try
            [ idx_pos, Time_pos ] = logGetIdxTime( data.ML2.TimeS, Time_start, Time_end );
            idx_pos = idx_pos(1:4:end);
            Time_pos = Time_pos(1:4:end);
            pos_0 = [data.ML2.xgm(idx_pos(1));data.ML2.ygm(idx_pos(1));data.ML2.zgm(idx_pos(1))];
            x_g = data.ML2.xgm(idx_pos)-pos_0(1);
            y_g = data.ML2.ygm(idx_pos)-pos_0(2);
            z_g = data.ML2.zgm(idx_pos)-pos_0(3);
        catch
            [ idx_pos, Time_pos ] = logGetIdxTime( data.XKF1.TimeS, Time_start, Time_end );
            pos_0 = [data.XKF1.PN(idx_pos(1));data.XKF1.PE(idx_pos(1));data.XKF1.PD(idx_pos(1))];
            x_g = data.XKF1.PN(idx_pos)-pos_0(1);
            y_g = data.XKF1.PE(idx_pos)-pos_0(2);
            z_g = data.XKF1.PD(idx_pos)-pos_0(3);
        end
        
        [ idx_u, Time_u ] = logGetIdxTime( data.ML1.TimeS, Time_start, Time_end );
        dsu = 10;
        idx_u = idx_u(1:dsu:end);
        Time_u = Time_u(1:dsu:end);
        u1 = data.ML1.u1(idx_u);
        u2 = data.ML1.u2(idx_u);
        u3 = data.ML1.u3(idx_u);
        u4 = data.ML1.u4(idx_u);
        
        is_rpm_available = true;
        if isprop(data,'ESC_1')
            [ idx_esc1, Time_esc1 ] = logGetIdxTime( data.ESC.TimeS, Time_start, Time_end );
            [ idx_esc2, Time_esc2 ] = logGetIdxTime( data.ESC_1.TimeS, Time_start, Time_end );
            [ idx_esc3, Time_esc3 ] = logGetIdxTime( data.ESC_2.TimeS, Time_start, Time_end );
            [ idx_esc4, Time_esc4 ] = logGetIdxTime( data.ESC_3.TimeS, Time_start, Time_end );
            omega_2 = data.ESC.RPM(idx_esc1)*2*pi/60;
            omega_4 = data.ESC_1.RPM(idx_esc2)*2*pi/60;
            omega_3 = data.ESC_2.RPM(idx_esc3)*2*pi/60;
            omega_1 = data.ESC_3.RPM(idx_esc4)*2*pi/60;
        else
            is_rpm_available = false;
        end

    end
    
    
    tikzwidth = '\figurewidth';
    tikzheight = '\figureheight';
    tikzfontsize = '\tikzstyle{every node}=[font=\tikzfontsize]';
    extra_axis_options = {'ylabel style={font=\tikzfontsize}','xlabel style={font=\tikzfontsize}','legend style={font=\tikzfontsize}'};

    core_name = '_failure_hover_';
    
    line_width = 1;

    figure
    plot(Time_pos,x_g,'LineWidth',line_width)
    hold on
    plot(Time_pos,y_g,'LineWidth',line_width)
    plot(Time_pos,z_g,'LineWidth',line_width)
    grid on
    xlabel('Time, s','interpreter','latex')
    ylabel('Position, m','interpreter','latex')
    legend('$x_g$','$y_g$','$z_g$','interpreter','latex','location','northeast')
    matlab2tikz([type,core_name,'pos.tex'],'width',tikzwidth,'height',tikzheight,'extraCode',tikzfontsize,'extraAxisOptions',extra_axis_options);

    figure
    plot(Time_rate,p,'LineWidth',line_width)
    hold on
    plot(Time_rate,q,'LineWidth',line_width)
    plot(Time_rate,r,'LineWidth',line_width)
    grid on
    xlabel('Time, s','interpreter','latex')
    ylabel('Angular Velocity, rad/s','interpreter','latex')
    legend('$p$','$q$','$r$','interpreter','latex','location','east')
    matlab2tikz([type,core_name,'rates.tex'],'width',tikzwidth,'height',tikzheight,'extraCode',tikzfontsize,'extraAxisOptions',extra_axis_options);

    if is_rpm_available
        figure
        plot(Time_esc1,omega_1,'LineWidth',line_width)
        hold on
        plot(Time_esc2,omega_2,'LineWidth',line_width)
        plot(Time_esc3,omega_3,'LineWidth',line_width)
        plot(Time_esc4,omega_4,'LineWidth',line_width)
        grid on
        xlabel('Time, s','interpreter','latex')
        ylabel('Motor Speed, rad/s','interpreter','latex')
        ylim([0,2.2*omega_1(end)])
        legend('$\omega_1$','$\omega_2$','$\omega_3$','$\omega_4$','interpreter','latex','location','northeast')
        matlab2tikz([type,core_name,'motor_speed.tex'],'width',tikzwidth,'height',tikzheight,'extraCode',tikzfontsize,'extraAxisOptions',extra_axis_options);
    end
    
    figure
    plot(Time_u,u1,'LineWidth',line_width)
    hold on
    plot(Time_u,u2,'LineWidth',line_width)
    plot(Time_u,u3,'LineWidth',line_width)
    plot(Time_u,u4,'LineWidth',line_width)
    grid on
    xlabel('Time, s','interpreter','latex')
    ylabel('Motor Command','interpreter','latex')
    ylim([0,1])
    legend('$u_1$','$u_2$','$u_3$','$u_4$','interpreter','latex','location','northeast')
    matlab2tikz([type,core_name,'input.tex'],'width',tikzwidth,'height',tikzheight,'extraCode',tikzfontsize,'extraAxisOptions',extra_axis_options);

end

function [ idx, Time_idx ] = logGetIdxTime( Time, Time_start, Time_end )

    idx = find(Time - Time_start > 0 & Time < Time_end);
    Time_idx = Time(idx) - Time_start;
    
end
