function [filtered_signals] = plotVgroup(cross_corr,StaDist,Period,Velocity)
%  
%   cross_corr 是一条互相关曲线
%   StaDist 是台站间距离
%   Period = [3 50]想要周期
%   本函数用于画群速度频散图
%   问题1：滤波器计算速度需要优化
%   
%

Fs = 3;   
TPoint = Period(1):0.05:Period(2);  
VPoint = Velocity(1):0.01:Velocity(2); 
N = length(TPoint);     
filtered_signals = zeros(length(VPoint), N);     %  初始化存储滤波后信号的矩阵
t = 0.05 :0.05: length(cross_corr)*0.05;   
TravPtV = StaDist./t;
filternum = floor(length(cross_corr)/3-1); % 确定滤波器最大阶数

for i = 1:N
    f0 = 1 / TPoint(i); % 中心频率
    d = designfilt('bandpassfir', 'FilterOrder', filternum, ...
                   'CutoffFrequency1', f0 - 0.01, 'CutoffFrequency2', f0 + 0.01, ...
                   'SampleRate', Fs);   
    filtered_signal = filtfilt(d, cross_corr);     %   窄带滤波器
%     TravPtV(isinf(TravPtV)) = StaDist+1-i/1000;
    analytic_signal = hilbert(filtered_signal);     %希尔伯特变换
    filtered_signal = abs(analytic_signal);    %计算包络
    filtered_signal = interp1(TravPtV, filtered_signal, VPoint, 'makima');
    filtered_signal = filtered_signal ./ max(filtered_signal);
    filtered_signals(:, i) = filtered_signal;      %存储信号
end

figure;
imagesc(TPoint,VPoint,filtered_signals);
xlabel('周期(s)');
ylabel('群速度(km/s)');
title('FTAN时频分析图');
xticks(TPoint(1):2:TPoint(end));
yticks(VPoint(1):0.25:VPoint(end));
xlim(Period);
ylim(Velocity);
colorbar;
axis xy;  


end