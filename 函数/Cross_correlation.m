function [cross_corr,lags] = Cross_correlation(filename1,respfile1,filename2,respfile2,max_lag)

%   filename1-2是不同台站的数据文件
%   max_lag是最大时延，乘2为互相关曲线数据长度
%   
%   本函数用于计算互相关曲线
%   利用preprocess预处理函数
%


S1 = readsac(filename1);    %   读取结构体
data1 = S1.DATA1;           %   读取数据点
data1 = preprocess(data1,respfile1);    %   使用预处理函数

S2 = readsac(filename2);
data2 = S2.DATA1;
data2 = preprocess(data2,respfile2);

[cross_corr,lags] = xcorr(data1,data2,max_lag,'coeff');     %cross_corr是互相关曲线，lags是横坐标轴

end