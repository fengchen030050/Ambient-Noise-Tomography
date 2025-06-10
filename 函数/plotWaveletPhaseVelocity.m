function plotWaveletPhaseVelocity(cross_corr, StaDist, sampleRate)
    %
    %   cross_corr 是互相关曲线
    %   StaDist 是台站间距离 (单位：米)
    %   sampleRate 是采样率 (Hz)
    %
    %   本函数用于通过小波变换绘制相速度时频分析图
    %
    % 参数设置
    wavelet = 'amor';     % 使用的 Morlet 小波类型

    % 数据预处理
    cross_corr = reverse(cross_corr);   % 对称叠加
    cross_corr = abs(hilbert(cross_corr)); % 希尔伯特变换，求群速度

    % 计算连续小波变换
    [waveletTransform, frequency] = cwt(cross_corr, wavelet, sampleRate);
    scalogram = abs(waveletTransform);

    % 生成时间向量
    t = 1:1:length(cross_corr);

    % 计算群速度向量
    Vgroup = StaDist ./ t;  % 单位：m/s
    period = 1 ./ frequency; % 单位：秒

    % 转置scalogram
    scalogram_transposed = scalogram';

    % 归一化 scalogram_transposed 的每一列
    for i = 1:size(scalogram_transposed, 2)
        max_amp = max(scalogram_transposed(:, i)); % 计算第 i 列的最大振幅
        scalogram_transposed(:, i) = scalogram_transposed(:, i) / max_amp; % 归一化第 i 列
    end

    % 使用 imagesc 函数绘制时频分析图
    figure;
    imagesc(period, Vgroup, scalogram_transposed);
    set(gca, 'YDir', 'normal');
    xlabel('周期 (秒)');
    ylabel('群速度 (km/s)');
    title('小波变换时频分析图');
    colorbar;

    % 绘制曲面图
    figure;
    [PeriodGrid, VgroupGrid] = meshgrid(period, Vgroup); % 创建网格
    surf(PeriodGrid, VgroupGrid, scalogram_transposed, 'EdgeColor', 'none');
    view(2); % 将视角设置为二维视图
    xlabel('周期 (秒)');
    ylabel('群速度 (km/s)');
    title('小波变换曲面图');
    colorbar;
end