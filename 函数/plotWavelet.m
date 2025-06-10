function []=plotWavelet(cross_corr,StaDist)


% 参数设置（根据你的数据调整）
sampleRate = 1;       % 采样率（Hz）
wavelet = 'amor';     % 使用的小波类型

cross_corr = abs(hilbert(cross_corr)); % 希尔伯特变换，求群速度

% 计算连续小波变换
[waveletTransform, frequency] = cwt(cross_corr, wavelet, sampleRate);
scalogram = abs(waveletTransform);

% 生成时间向量（已存在）
t = 1:1:length(cross_corr);

% 计算群速度向量
Vgroup = StaDist./t;  % 单位：m/s
% 计算周期向量
period = 1./frequency; % 单位：秒

% 转置scalogram
scalogram_transposed = scalogram';

for i = 1:size(scalogram_transposed, 2)
    max_amp = max(scalogram_transposed(:,i)); % 计算第 i 列的最大振幅
    scalogram_transposed(:, i) = scalogram_transposed(:, i) / max_amp; % 归一化第 i 列
end

% 假设 period 和 Vgroup 是你的非线性坐标数据
[PeriodGrid, VgroupGrid] = meshgrid(period, Vgroup); % 创建网格
figure;
surf(PeriodGrid, VgroupGrid, scalogram_transposed, 'EdgeColor', 'none'); % 绘制曲面图
view(2); % 将视角设置为二维视图
xlabel('周期 (秒)');
ylabel('群速度 (km/s)');
title('小波变换图像');
xlim([3 10]);
ylim([0.7 1.8]);
colorbar;

% 绘制非线性坐标———可行画图 % %
figure;
h = imagesc(period, 1:length(Vgroup), scalogram_transposed); % 使用线性索引
xlabel('周期 (秒)');
ylabel('群速度 (km/s)');
title('非线性坐标的小波变换图像');
ax = gca;
ax.YTick = 1:1:length(Vgroup); % 设置刻度位置
ax.YTickLabel = Vgroup(ax.YTick); % 设置刻度标签为 Vgroup 的实际值
colorbar;
xlim([3 20]);
ylim([0.5 5]);
% 手动设置 Y 轴刻度和标签


end

