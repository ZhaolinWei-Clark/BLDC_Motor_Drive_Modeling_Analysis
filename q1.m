% 打开系统并设置仿真参数
open_system('q1model.slx');
solver = 'ode23tb';
set_param('q1model', 'StopTime', '8');
set_param('q1model', 'Solver', solver);
set_param('q1model', 'Maxstep', '1e-3');
set_param('q1model', 'Abstol', '1e-4');
set_param('q1model', 'Reltol', '1e-4');
out = sim('q1model.slx');

% 创建图形窗口
hFig = figure('Position', [100, 100, 900, 600]);
tiledlayout(5, 1, 'Padding', 'compact', 'TileSpacing', 'compact'); % 使用tiledlayout优化布局

% 绘制 v_a_s vs Time
nexttile;
plot(out.vas.Time, out.vas.Data, 'LineWidth', 1.2);
xlabel('Time (s)', 'FontSize', 10, 'FontWeight', 'bold');
ylabel('v_a_s (V)', 'FontSize', 10, 'FontWeight', 'bold');
title('\bfv_a_s vs Time', 'FontSize', 12);
ylim([min(out.vas.Data) - 0.2*abs(min(out.vas.Data)), max(out.vas.Data) + 0.2*abs(max(out.vas.Data))]); % 调整y轴范围
grid on;

% 绘制 i_a_s vs Time
nexttile;
plot(out.ias.Time, out.ias.Data, 'LineWidth', 1.2);
xlabel('Time (s)', 'FontSize', 10, 'FontWeight', 'bold');
ylabel('i_a_s (A)', 'FontSize', 10, 'FontWeight', 'bold');
title('\bfi_a_s vs Time', 'FontSize', 12);
ylim([min(out.ias.Data) - 0.2*abs(min(out.ias.Data)), max(out.ias.Data) + 0.2*abs(max(out.ias.Data))]); % 调整y轴范围
grid on;

% 绘制 i_d_c vs Time
nexttile;
plot(out.idc.Time, out.idc.Data, 'LineWidth', 1.2);
xlabel('Time (s)', 'FontSize', 10, 'FontWeight', 'bold');
ylabel('i_d_c (A)', 'FontSize', 10, 'FontWeight', 'bold');
title('\bfi_d_c vs Time', 'FontSize', 12);
ylim([min(out.idc.Data) - 0.2*abs(min(out.idc.Data)), max(out.idc.Data) + 0.2*abs(max(out.idc.Data))]); % 调整y轴范围
grid on;

% 绘制 T_e vs Time
nexttile;
plot(out.Te.Time, out.Te.Data, 'LineWidth', 1.2);
xlabel('Time (s)', 'FontSize', 10, 'FontWeight', 'bold');
ylabel('T_e (N·m)', 'FontSize', 10, 'FontWeight', 'bold');
title('\bfT_e vs Time', 'FontSize', 12);
ylim([min(out.Te.Data) - 0.2*abs(min(out.Te.Data)), max(out.Te.Data) + 0.2*abs(max(out.Te.Data))]); % 调整y轴范围
grid on;

% 绘制 \omega_r_m vs Time
nexttile;
plot(out.wrm.Time, out.wrm.Data, 'LineWidth', 1.2);
xlabel('Time (s)', 'FontSize', 10, 'FontWeight', 'bold');
ylabel('\omega_r_m (r/s)', 'FontSize', 10, 'FontWeight', 'bold');
title('\bf\omega_r_m vs Time', 'FontSize', 12);
ylim([min(out.wrm.Data) - 0.2*abs(min(out.wrm.Data)), max(out.wrm.Data) + 0.2*abs(max(out.wrm.Data))]); % 调整y轴范围
grid on;

% 添加总标题
sgtitle('Simulation Results', 'FontSize', 14, 'FontWeight', 'bold');
