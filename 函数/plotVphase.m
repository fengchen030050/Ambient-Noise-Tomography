function [filtered_signals] = plotVphase(cross_corr,StaDist,Period,Velocity)
%  
%   cross_corr是应处理的互相关曲线
%   StaDist 是台站间距离
%   Peirod应输入[起始周期 终止周期]    
%   Velocity应输入[起始速度 终止速度]    
%       
%   本函数用于画相速度频散图
%   问题1：滤波器计算速度需要优化
%   

Fs = 2.4;     %   采样频率
TPoint = Period(1):0.15:Period(2);  % 定义周期点
VPoint = Velocity(1):0.01:Velocity(2); 
N = length(TPoint);     % 计算周期点的数量
filtered_signals = zeros(length(VPoint), N);     %  初始化存储滤波后信号的矩阵
t = 0.05 :0.05: length(cross_corr)*0.05;     
filternum = floor(length(cross_corr)/3-1); % 确定滤波器最大阶数
% TravPtV = StaDist./t;


for i = 1:N  
    f0 = 1 / TPoint(i); % 中心频率
    d = designfilt('bandpassfir', 'FilterOrder', filternum, ...
                   'CutoffFrequency1', f0 - 0.01, 'CutoffFrequency2', f0 + 0.01, ...
                   'SampleRate', Fs);
    filtered_signal = filtfilt(d, cross_corr);      %   零相位滤波
    filtered_signal = filtfilt(d,fliplr(filtered_signal));
    filtered_signal = fliplr(filtered_signal);
    TravPtV = StaDist./(t- TPoint(i)/8);
    TravPtV(isinf(TravPtV)) = StaDist+1-i/1000;
    filtered_signal = interp1(TravPtV, filtered_signal, VPoint, 'spline');
    filtered_signal = filtered_signal ./ max(filtered_signal);   %  归一化振幅
    filtered_signals(:, i) = filtered_signal;   %   存储信号
end

figure;
imagesc(TPoint,VPoint,filtered_signals);
xlabel('周期(s)');
ylabel('相速度(km/s)');
title('FTAN时频分析图');
xticks(1:0.5:5);
yticks(0:0.25:50);
xlim(Period);
ylim(Velocity);
colorbar; 
axis xy; 

end