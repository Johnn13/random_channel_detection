clc
clear all
close all

% 加载数据
c_data_7 = load('../result/c_7.mat').save_rate_c;
n_data_7 = load('../result/n_7.mat').save_rate_n;
c_data_8 = load('../result/c_8.mat').save_rate_c;
n_data_8 = load('../result/n_8.mat').save_rate_n;
n_data_8 = [n_data_8 zeros(1,8)];
c_data_9 = load('../result/c_9.mat').save_rate_c;
n_data_9 = load('../result/n_9.mat').save_rate_n;
n_data_9 = [n_data_9 zeros(1,20)];
c_data_10 = load('../result/c_10.mat').save_rate_c;
n_data_10 = load('../result/n_10.mat').save_rate_n;
n_data_10 = [n_data_10 zeros(1,20)];
c_data_11 = load('../result/c_11.mat').save_rate_c;
n_data_11 = load('../result/n_11.mat').save_rate_n;
c_data_12 = load('../result/c_12.mat').save_rate_c;
% n_data_12 = load('../result/n_12.mat').save_rate_n;
SNR = 5:-1:-40;

% 定义颜色和标记
colors = [
    54, 42, 134;
    54, 61, 172;
    32, 82, 211;
    6, 108, 224;
    15, 120, 218;
    10, 152, 20;
    37, 180, 169;
    112, 190, 128;
    208, 186, 89;
    253, 190, 61;
    253, 174, 97;
    255, 109, 67;
] / 255;
markers = {'o', 's', 'd', '^', '*', '>'};
labels = {'SF7', 'SF7(COTS)',... 
    'SF8', 'SF8(COTS)',...
    'SF9','SF9(COTS)',...
    'SF10', 'SF10(COTS)',...
    'SF11', 'SF11(COTS)',...
    'SF12', 'SF12(COTS)'};

% 设置线条宽度和标记大小
lineWidth = 2.8;
markerSize = 10;

% 创建图形
figure;

% 绘制 n_data 系列到子图 1
subplot(211);
hold on;
plot(SNR, c_data_7, 'Marker', markers{1}, 'Color', colors(1, :), 'LineStyle', '--', ...
    'DisplayName', labels{2}, 'MarkerFaceColor', colors(1, :), 'LineWidth', lineWidth, 'MarkerSize', markerSize);

plot(SNR, c_data_8, 'Marker', markers{2}, 'Color', colors(3, :), 'LineStyle', '--', ...
    'DisplayName', labels{4}, 'MarkerFaceColor', colors(3, :), 'LineWidth', lineWidth, 'MarkerSize', markerSize);

plot(SNR, c_data_10, 'Marker', markers{4}, 'Color', colors(7, :), 'LineStyle', '--', ...
    'DisplayName', labels{8}, 'MarkerFaceColor', colors(7, :), 'LineWidth', lineWidth, 'MarkerSize', markerSize);


% 设置轴标签
xlabel('SNR (dB)', 'FontSize', 20, 'FontWeight', 'bold');
ylabel('PDR', 'FontSize', 20, 'FontWeight', 'bold');

% 设置图例
legend('show', 'Location', 'northeast', 'FontSize', 20);

% 设置轴范围
xlim([-35 5]);
ylim([0 1]);

% 设置坐标轴字体大小
set(gca, 'FontSize', 20);

% 打开网格
grid on;
hold off;

% 绘制 c_data 系列到子图 2
subplot(212);
hold on;


plot(SNR, n_data_7, 'Marker', markers{1}, 'Color', colors(1, :), 'LineStyle', '-', ...
    'DisplayName', labels{1}, 'MarkerFaceColor', colors(1, :), 'LineWidth', lineWidth, 'MarkerSize', markerSize);

plot(SNR, n_data_8, 'Marker', markers{2}, 'Color', colors(3, :), 'LineStyle', '-', ...
    'DisplayName', labels{3}, 'MarkerFaceColor', colors(3, :), 'LineWidth', lineWidth, 'MarkerSize', markerSize);

plot(SNR, n_data_9, 'Marker', markers{4}, 'Color', colors(7, :), 'LineStyle', '-', ...
    'DisplayName', labels{7}, 'MarkerFaceColor', colors(7, :), 'LineWidth', lineWidth, 'MarkerSize', markerSize);

% 设置轴标签
xlabel('SNR (dB)', 'FontSize', 20, 'FontWeight', 'bold');
ylabel('PDR', 'FontSize', 20, 'FontWeight', 'bold');

% 设置图例
legend('show', 'Location', 'northeast', 'FontSize', 20);

% 设置轴范围
xlim([-35 5]);
ylim([0 1.05]);

% 设置坐标轴字体大小
set(gca, 'FontSize', 20);

% 打开网格
grid on;
hold off;

% 设置图形输出大小，以适合论文
fig = gcf;
fig.PaperPositionMode = 'manual';
fig.PaperUnits = 'inches';
fig.PaperPosition = [0, 0, 8, 6]; % 设置输出尺寸 [x, y, width, height]
fig.PaperSize = [8, 6]; % 设置纸张大小

% 输出为 PDF
print('-painters', '-dpdf', '-r600', 'SNR_鲁棒性实验'); % 输出图片格式为 PDF，文件名为 SNR_鲁棒性实验