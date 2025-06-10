clc;clear;close all;

max_lag = 200;  %坐标轴长度
large = 100;    %放大倍数

filename1 = 'D:\1_matlab-代码文件\背景噪声成像\大创-英山地热\姚老师_学习文件\NoiseCorr-2016Jul-v4.2\dataSAC\G01\2008\G01_Z_010.sac';
filename6 = 'D:\1_matlab-代码文件\背景噪声成像\大创-英山地热\姚老师_学习文件\NoiseCorr-2016Jul-v4.2\dataSAC\G06\2008\G06_Z_010.sac';
filename10 = 'D:\1_matlab-代码文件\背景噪声成像\大创-英山地热\姚老师_学习文件\NoiseCorr-2016Jul-v4.2\dataSAC\G10\2008\G10_Z_010.sac';

respfile1 = 'D:\1_matlab-代码文件\背景噪声成像\大创-英山地热\姚老师_学习文件\NoiseCorr-2016Jul-v4.2\Resp\RESP.ZD.G01..HHZ';
respfile6 = 'D:\1_matlab-代码文件\背景噪声成像\大创-英山地热\姚老师_学习文件\NoiseCorr-2016Jul-v4.2\Resp\RESP.ZD.G06..BHZ';
respfile10 = 'D:\1_matlab-代码文件\背景噪声成像\大创-英山地热\姚老师_学习文件\NoiseCorr-2016Jul-v4.2\Resp\RESP.ZD.G10..BHZ';

[cross_corr1_6,~] = Cross_correlation(filename1,respfile1,filename6,respfile6,max_lag);
[cross_corr1_10,~] = Cross_correlation(filename1,respfile1,filename10,respfile10,max_lag);
[cross_corr6_10,lags1] = Cross_correlation(filename6,respfile6,filename10,respfile10,max_lag);

% filename1 = 'D:\1_matlab-代码文件\背景噪声成像\大创-英山地热\姚老师_学习文件\NoiseCorr-2016Jul-v4.2\dataSAC\G01\2008\G01_Z_011.sac';
% filename6 = 'D:\1_matlab-代码文件\背景噪声成像\大创-英山地热\姚老师_学习文件\NoiseCorr-2016Jul-v4.2\dataSAC\G06\2008\G06_Z_011.sac';
% filename10 = 'D:\1_matlab-代码文件\背景噪声成像\大创-英山地热\姚老师_学习文件\NoiseCorr-2016Jul-v4.2\dataSAC\G10\2008\G10_Z_011.sac';

[cross_corr01_6,~] = Cross_correlation(filename1,respfile1,filename6,respfile6,max_lag);
[cross_corr01_10,~] = Cross_correlation(filename1,respfile1,filename10,respfile10,max_lag);
[cross_corr06_10,lags1] = Cross_correlation(filename6,respfile6,filename10,respfile10,max_lag);

cross_corr1_6 = (cross_corr1_6 + cross_corr01_6) / 2;
cross_corr1_10 = (cross_corr1_10 + cross_corr01_10) / 2;
cross_corr6_10 = (cross_corr6_10 + cross_corr06_10) / 2;

figure(1)
plot(lags1,cross_corr1_6*large+28.167,'k')
hold on

hold on
plot(lags1,cross_corr1_10*large+46.3825,'k')

hold on
plot(lags1,cross_corr6_10*large+18.9238,'k')
ylabel('Distacne(km)')
ylim([0,100])
% 
% 叠加部分

% cross_corr1_6 = reverse(cross_corr1_6); 
% cross_corr1_10 = reverse(cross_corr1_10); 
% cross_corr6_10 = reverse(cross_corr6_10); 

% plotVgroup(cross_corr1_6,28.167,[3 10],[0.5 5])
% plotVgroup(cross_corr1_10,46.3825,[3 10],[0.5 5])
% plotVgroup(cross_corr6_10,18.9238,[3 10],[0.5 5])

% plotVphase(cross_corr1_6,28.167,[3 10],[0.5 5])
% plotVphase(cross_corr1_10,46.3825,[3 10],[0.5 5])
% plotVphase(cross_corr6_10,18.9238,[3 10],[0.5 5])


cross_corr1_6= wdenoise(cross_corr1_6, 7, 'Wavelet','sym4', 'DenoisingMethod','Bayes', 'ThresholdRule','Median');
cross_corr1_10 = wdenoise(cross_corr1_10, 7, 'Wavelet','sym4', 'DenoisingMethod','Bayes', 'ThresholdRule','Median');
cross_corr6_10 = wdenoise(cross_corr6_10, 7, 'Wavelet','sym7', 'DenoisingMethod','Bayes', 'ThresholdRule','Median');
% 
figure(2)
plot(lags1,cross_corr1_6*large+28.167,'k')
hold on

hold on
plot(lags1,cross_corr1_10*large+46.3825,'k')

hold on
plot(lags1,cross_corr6_10*large+18.9238,'k')
ylabel('Distacne(km)')
ylim([0,100])
% 
% cross_corr1_6 = reverse(cross_corr1_6); 
% cross_corr1_10 = reverse(cross_corr1_10); 
% cross_corr6_10 = reverse(cross_corr6_10); 

% plotVgroup(cross_corr1_6,28.167,[3 10],[0.5 5])
% plotVgroup(cross_corr1_10,46.3825,[3 10],[0.5 5])
% plotVgroup(cross_corr6_10,18.9238,[3 10],[0.5 5])

% plotVphase(cross_corr1_6,28.167,[3 10],[0.5 5])
% plotVphase(cross_corr1_10,46.3825,[3 10],[0.5 5])
% plotVphase(cross_corr6_10,18.9238,[3 10],[0.5 5])
                                                                             
% % plotWavelet(cross_corr1_6,28.167)
% plotWavelet(cross_corr1_10,46.3825)
% % plotWavelet(cross_corr6_10,18.9238)
