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
        Time_esc = data.motor_speed.Time(idx);
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
        euler_angles = squeeze(data.Euler_angles.Data(:,:,idx));
        nzg = getNzg( euler_angles );
        Time_atti = Time_pos;
    else
        
        idx_failure = find(data.RCIN.C7 > 1500);
    
        Time_trigger = data.RCIN.TimeS(idx_failure(1));
        Time_start = Time_trigger-1;
        Time_end = Time_start + 6;
        omega_0 = 75;
        d = 1;
        pt2 = tf([1],[1/omega_0^2,2*d/omega_0,1]);
        pt2d = c2d(pt2,1/400);
        try
            [ idx_rate, Time_rate ] = logGetIdxTime( data.ML3.TimeS, Time_start, Time_end );
            idx_rate = idx_rate(1:4:end);
            Time_rate = Time_rate(1:4:end);
            pf = filter(pt2d.Numerator{:},pt2d.Denominator{:},data.ML3.p);
            qf = filter(pt2d.Numerator{:},pt2d.Denominator{:},data.ML3.q);
            rf = filter(pt2d.Numerator{:},pt2d.Denominator{:},data.ML3.r);
            p = pf(idx_rate);
            q = qf(idx_rate);
            r = rf(idx_rate);
%             p = data.ML3.p(idx_rate);
%             q = data.ML3.q(idx_rate);
%             r = data.ML3.r(idx_rate);
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
        try
            [ idx_atti, Time_atti ] = logGetIdxTime( data.ML4.TimeS, Time_start, Time_end );
            idx_atti = idx_atti(1:4:end);
            Time_atti = Time_atti(1:4:end);
            q0 = data.ML4.q1(idx_atti);
            q1 = data.ML4.q2(idx_atti);
            q2 = data.ML4.q3(idx_atti);
            q3 = data.ML4.q4(idx_atti);
            quat = [q0';q1';q2';q3'];
            nzg = quat2nzg(quat);
        catch
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
        %  if isprop(data,'ML3')
        if sum(data.ML3.w1 == -1) < 1000
            [ idx_esc, Time_esc ] = logGetIdxTime( data.ML3.TimeS, Time_start, Time_end );
            idx_esc = idx_esc(1:dsu:end);
            Time_esc = Time_esc(1:dsu:end);
            omega_4 = data.ML3.w2(idx_esc);
            omega_3 = data.ML3.w4(idx_esc);
            omega_1 = data.ML3.w3(idx_esc);
            omega_2 = data.ML3.w1(idx_esc);
        else
            is_rpm_available = false;
        end

    end
    
    
    tikzwidth = '\figurewidth';
    tikzheight = '\figureheight';
    tikzfontsize = '\tikzstyle{every node}=[font=\tikzfontsize]';
    extra_axis_options = {'ylabel style={font=\tikzfontsize}','xlabel style={font=\tikzfontsize}','legend style={font=\tikzfontsize}'};
    extra_axis_options2 = [extra_axis_options,{'legend columns=2'}];
    extra_axis_options3 = [extra_axis_options,{'every y tick label/.'}];

    core_name = '_failure_hover_';
    
    line_width = 1;

    figure
    % plot second y axis twice so that 2nd y axis is black and the plot is
    % converted correctly by matlab2tikz (hAx(2).YColor = 'k' does not
    % work)
    [hAx,hLine1,hLine2]=plotyy(Time_pos,[x_g,y_g,z_g],Time_atti,[nzg(:),nzg(:)]);
    hold on    
    y_lim = [-1,4];
    xlabel('Time, s','interpreter','latex')
    hLine1(1).LineWidth = line_width;
    hLine1(2).LineWidth = line_width;
    hLine1(3).LineWidth = line_width;
    hLine2(1).LineWidth = line_width;
    hLine2(2).LineWidth = line_width;
    hLine2(2).Color = hLine2(1).Color;
    plot([1,1],y_lim,'k--');
    hAx(1).YLim = y_lim;
    hAx(1).YTick=[-1,0,1,2,3,4];
    hAx(2).YLim = [-1,1.5];
    hAx(2).YTick=[-1,-0.5,0,0.5,1];
    ylabel(hAx(1),'Position, m','interpreter','latex')
    ylabel(hAx(2),'Vertical Lean Vector Component','interpreter','latex')
    legend([hLine1(1),hLine1(2),hLine1(3),hLine2(1)],'$x_g$','$y_g$','$z_g$','$n_{z,g}$','interpreter','latex')
    grid on
    
    matlab2tikz([type,core_name,'pos.tex'],'width',tikzwidth,'height',tikzheight,'extraCode',tikzfontsize,'extraAxisOptions',extra_axis_options);

    
% [hAx,hLine1,hLine2]=plotyy(Time,[sqrt(x_g_fail.^2+y_g_fail.^2),z_g_fail,sqrt(x_g.^2+y_g.^2),z_g],Time,[n_z_g_fail(:),n_z_g(:)]);
% hLine1(3).LineStyle = '--';
% hLine1(4).LineStyle = '--';
% hLine2(2).LineStyle = '--';
% hLine2(1).Color=hLine1(3).Color;
% hLine2(2).Color=hLine1(3).Color;
% hLine1(3).Color=hLine1(1).Color;
% hLine1(4).Color=hLine1(2).Color;
% hLine2(2).Color=hLine2(1).Color;
% 
% xlabel('Time, s','interpreter','latex')
% hAx(1).XLim = [0,Time_end];
% hAx(2).XLim = hAx(1).XLim;
% hAx(1).YLim = [0,4];
% hAx(1).YTick=[0,1,2,3,4];
% hAx(2).YLim=[-1,1];
% hAx(2).YTick=[-1,-0.5,0,0.5,1];
% ylabel(hAx(1),'Position, m','interpreter','latex')
% legend([hLine1(1),hLine1(2),hLine2(1),hLine2(2)],'$\sqrt{x_g^2+y_g^2}$','$z_g$','$n_{z,g}$','interpreter','latex')
% ylabel(hAx(2),'Vectical Lean Vector Component','interpreter','latex')
% grid on
    
    
    figure
    plot(Time_rate,p,'LineWidth',line_width)
    hold on
    plot(Time_rate,q,'LineWidth',line_width)
    plot(Time_rate,r,'LineWidth',line_width)
    y_lim = [-25,10];
    plot([1,1],y_lim,'k--','LineWidth',line_width)
    grid on
    xlabel('Time, s','interpreter','latex')
    ylabel('Angular Velocity, rad/s','interpreter','latex')
    ylim(y_lim)
    legend('$p$','$q$','$r$','interpreter','latex','location','northeast','Orientation','horizontal')
    matlab2tikz([type,core_name,'rates.tex'],'width',tikzwidth,'height',tikzheight,'extraCode',tikzfontsize,'extraAxisOptions',extra_axis_options);

    if is_rpm_available
        figure
        plot(Time_esc,omega_1,'LineWidth',line_width)
        hold on
        plot(Time_esc,omega_2,'LineWidth',line_width)
        plot(Time_esc,omega_3,'LineWidth',line_width)
        plot(Time_esc,omega_4,'LineWidth',line_width)
        y_lim = [0,3000];
        plot([1,1],y_lim,'k--','LineWidth',line_width)
        grid on
        xlabel('Time, s','interpreter','latex')
        ylabel('Motor Speed, rad/s','interpreter','latex')
        ylim(y_lim)
        legend('$\omega_1$','$\omega_2$','$\omega_3$','$\omega_4$','interpreter','latex','location','northeast','NumColumns',2)
        matlab2tikz([type,core_name,'motor_speed.tex'],'width',tikzwidth,'height',tikzheight,'extraCode',tikzfontsize,'extraAxisOptions',extra_axis_options2);
    end
    
    figure
    plot(Time_u,u1,'LineWidth',line_width)
    hold on
    plot(Time_u,u2,'LineWidth',line_width)
    plot(Time_u,u3,'LineWidth',line_width)
    plot(Time_u,u4,'LineWidth',line_width)
    y_lim = [0,1];
    plot([1,1],y_lim,'k--','LineWidth',line_width)
    grid on
    xlabel('Time, s','interpreter','latex')
    ylabel('Motor Command','interpreter','latex')
    ylim(y_lim)
    legend('$u_1$','$u_2$','$u_3$','$u_4$','interpreter','latex','location','east','NumColumns',2)
    matlab2tikz([type,core_name,'input.tex'],'width',tikzwidth,'height',tikzheight,'extraCode',tikzfontsize,'extraAxisOptions',extra_axis_options2);

end

function [ idx, Time_idx ] = logGetIdxTime( Time, Time_start, Time_end )

    idx = find(Time - Time_start > 0 & Time < Time_end);
    Time_idx = Time(idx) - Time_start;
    
end

function nzg = quat2nzg(quat)

    nzg = zeros(1,size(quat,2));
    for i = 1:size(quat,2)
        M_bg = quat2Dcm(quat(:,i));
        lean_vector = dcm2LeanVector(M_bg);
        nzg(i) = lean_vector(3);
    end

end

function n_z_g = getNzg( euler_angles )
num_pts = size(euler_angles,2);
n_z_g = zeros(1,num_pts);
for i = 1:num_pts
    M_bg = euler2Dcm(euler_angles(:,i));
    lean_vector = dcm2LeanVector(M_bg);
    n_z_g(i) = lean_vector(3);
end
end
