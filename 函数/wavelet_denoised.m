function noiseSignal = wavelet_denoised(signal)
    % removeSignalKeepNoise: 保留噪声，去除信号
    % 输入:
    %   signal - 输入信号（含信号和噪声）
    % 输出:
    %   noiseSignal - 去除信号后的噪声信号

    % 小波分解
    waveletName = 'sym8'; % 使用 Daubechies 小波
    level = 5; % 分解层次
    [coeffs, lengths] = wavedec(signal, level, waveletName);

    % 计算99%分位数作为阈值
    threshold = prctile(abs(coeffs), 99); % 选择99%分位数作为阈值

    % 对低频系数（近似系数）应用软阈值处理
    approximationCoeffs = coeffs(1:lengths(1)); % 提取低频系数
    approximationCoeffs = wthresh(approximationCoeffs, 's', threshold); % 软阈值处理

    % 将处理后的低频系数放回系数向量
    coeffs(1:lengths(1)) = approximationCoeffs;

    % 重构信号
    noiseSignal = waverec(coeffs, lengths, waveletName);
end