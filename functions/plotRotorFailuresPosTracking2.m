function plotRotorFailuresPosTracking2(data,switch_number,is_ref_plot)

if nargin<2
    switch_number = 1;
end
        
is_rc9 = data.RCIN.C9 > 1500;

is_rc9_switched = [false;diff(is_rc9)>0.5];

idx_rc9_switched = find(is_rc9_switched>0.5);

Time_trigger = data.RCIN.TimeS(idx_rc9_switched(switch_number));
Time_start = Time_trigger+4;
Time_end = Time_start + 25;%36;


[ idx_pos, ~ ] = logGetIdxTime( data.ML2.TimeS, Time_start, Time_end );
idx_pos = idx_pos(1:4:end);
pos_ref_0 = [data.ML2.xgr(idx_pos(1));data.ML2.ygr(idx_pos(1));data.ML2.zgr(idx_pos(1))];
x_g = data.ML2.xgm(idx_pos)-pos_ref_0(1);
y_g = data.ML2.ygm(idx_pos)-pos_ref_0(2);
x_g_ref = data.ML2.xgr(idx_pos)-pos_ref_0(1);
y_g_ref = data.ML2.ygr(idx_pos)-pos_ref_0(2);
V_K = sqrt(data.ML2.xd1(idx_pos).^2+data.ML2.yd1(idx_pos).^2);

line_width = 1;

if is_ref_plot
    plot(y_g_ref,x_g_ref,'LineWidth',line_width)
    hold on
end
plot(y_g,x_g,'LineWidth',line_width)
hold on
grid on
axis equal
xlim([-2.5,22.5])
ylim([-2.5,22.5])
xticks([0:5:20])
yticks([0:5:20])
box on
xlabel('East Position, m','interpreter','latex')
ylabel('North Position, m','interpreter','latex')

end

function [ idx, Time_idx ] = logGetIdxTime( Time, Time_start, Time_end )

    idx = find(Time - Time_start > 0 & Time < Time_end);
    Time_idx = Time(idx) - Time_start;
    
end
