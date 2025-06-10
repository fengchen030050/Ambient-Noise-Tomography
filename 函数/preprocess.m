function data = preprocess(data,respfile)


% 降采样
data= decimate(data,5);
% data = resample(data,1,5);
N = length(data); 

% 去趋势
data = detrend(data,'linear');
Fs = 1;
% 去除仪器响应
[Amp, Zeros, Poles] = Rd_InstruRespFile(respfile);
% 创建传递函数的分子和分母多项式
poly_num = Amp * poly(Zeros); % 多项式分子（与零点相关）
poly_den = poly(Poles);       % 多项式分母（与极点相关）
% 计算频率对应的角频率向量
f = Fs*(1:N)/N;
w = 2 * pi * f; 
% 计算仪器响应
h = freqs(poly_num, poly_den, w);
% 归一化仪器响应
h = h / max(abs(h));
h = h';
% 计算信号的傅里叶变换 
Y_fft = fft(data); 
Y_fft = Y_fft./h; 
data = real(ifft(Y_fft));


% 带通滤波: 40s-4s频带
nyquist = Fs / 2;  % 奈奎斯特频率

% 归一化频率
low_stop = 0.01 / nyquist;  % 低阻带频率归一化
low_cutoff = 0.1 / nyquist;  % 低截止频率归一化
high_cutoff = 0.33 / nyquist;  % 高截止频率归一化
high_stop = 0.4 / nyquist;  % 高阻带频率归一化

% 设计 Butterworth 带通滤波器
% Rp = 3; % 通带最大衰减（dB）
% Rs = 40; % 阻带最小衰减（dB）
Rp = 1; % 通带最大衰减（dB）
Rs = 20; % 阻带最小衰减（dB）

[n, Wn] = buttord([low_cutoff high_cutoff], [low_stop high_stop], Rp, Rs);  % 计算最优滤波器阶数和归一化截止频率
[b, a] = butter(n, Wn, 'bandpass');  % 设计带通滤波器

% 应用滤波器
data = filter(b, a, data);

% smooth平滑窗口
data_smooth = smoothdata(abs(data),'movmean','SmoothingFactor',0.25);
epsilon = 1e-6;
data = data.*(1./(abs(data_smooth)+epsilon));

% %小波去噪
% data = wavelet_denoised(data);


% 谱白化
Y_fft = fft(data); 
Y_fft2 = smoothdata(abs(Y_fft),'movmean','SmoothingFactor',0.25);
% % 信号频谱除以平滑频谱
Y_fft = Y_fft./abs(Y_fft2);
data = real(ifft(Y_fft));


nyquist = Fs / 2;  % 奈奎斯特频率

% 归一化频率
low_stop = 0.01 / nyquist;  % 低阻带频率归一化
low_cutoff = 0.1/ nyquist;  % 低截止频率归一化
high_cutoff = 0.33 / nyquist;  % 高截止频率归一化
high_stop = 0.4 / nyquist;  % 高阻带频率归一化

% 设计 Butterworth 带通滤波器
% Rp = 3; % 通带最大衰减（dB）
% Rs = 40; % 阻带最小衰减（dB）
Rp = 1; % 通带最大衰减（dB）
Rs = 20; % 阻带最小衰减（dB）

[n, Wn] = buttord([low_cutoff high_cutoff], [low_stop high_stop], Rp, Rs);  % 计算最优滤波器阶数和归一化截止频率
[b, a] = butter(n, Wn, 'bandpass');  % 设计带通滤波器
data = filter(b, a, data);



end


