clc;clear;close all

%这里改成你的txt文本路径
outputPath = 'D:\1_matlab-代码文件\背景噪声成像\大创-英山地热\Disper\ZZ.fildername.txt';
%这里改成英山数据的文件夹路径
basePath = 'D:\1_matlab-代码文件\背景噪声成像\大创-英山地热\ZZ\';
fileID = fopen(outputPath,'r');
i = 0;   % 这里不变，ZZ.fildername是所有台站信息，韩，你提第1行到第220行。我提221行到第434行
Period = [1 5];
Velocity = [2.5 3.5];
Fs = 2.2;

startline = 280;  %当中断后可以记住到哪行了，下次从startline行开始提取，方便中断后继续提取

while ~feof(fileID)
        line = fgetl(fileID);
        fprintf('第 %d 行: %s\n', i+1, line);
        i = i + 1;

        %去除前面几道容易截错的
        %会跳过台站距小于一个波长的数据
        if i >= startline
        fildername = [basePath,line];
        Struct = readsac(fildername);
        cross_corr = Struct.DATA1;
        cross_corr = reverse(cross_corr);
        StaDist = Struct.DIST;


        if StaDist < 4
            continue;
        end

%         下面是去噪函数代码，第一批不运行，第二批为了对比再运行，如果这里使用了保存路径记得更换一下
        cross_corr = wdenoise(cross_corr, 8, ...
        'Wavelet', 'sym4', ...
        'DenoisingMethod', 'bayes', ...
        'ThresholdRule', 'Soft', ...
        'NoiseEstimate', 'LevelDependent');
        filternum = floor(length(cross_corr)/3-1); % 确定滤波器最大阶数
        d = designfilt('bandpassfir', 'FilterOrder', filternum, ...
               'CutoffFrequency1', 0.2, 'CutoffFrequency2', 1, ...
               'SampleRate', Fs);
        cross_corr = filtfilt(d, cross_corr);  % 双向滤波

        %提取相速度
        [filtered_signals] = plotVphase(cross_corr,StaDist,Period,Velocity);
        choice = questdlg('是否提取频散曲线？','提频散', '是', '否', '是');
        if strcmp(choice, '是')
        Dispercurve = GrapDisper;
        filename = sprintf('D:\\1_matlab-代码文件\\背景噪声成像\\大创-英山地热\\去噪后频散曲线数据\\data_phase%d.mat', i);
        save(filename, 'Dispercurve');
        elseif strcmp(choice, '否')   
        end
        end
    
end

