function PhaseVImg(cross_corr,StaDist,SampleFrequency)
    % FFT 相位法处理主函数
    % 输入参数：
    %   WinWave: 时间域信号
    %   StaDist: 站距
    %   SampleFrequency: 采样频率
    %   fftNumPt: FFT 点数
    %   cross: 结构体，包含 .StartT 和 .EndT
    %   VPoint: 速度点数组
    %   TPoint: 时间点数组
    %   VImgPt: 速度图像点数
    %   crossNumCtrT: 交叉数
    

    % FFT 转换
    EGFcnfft = fft(cross_corr);
   
    df = fdata(2);
    
    % 相位提取
    phaseEGF = angle(EGFcnfft);
    
    TPoint = 3:0.5:50; 


    % 确定频率范围
    nl = floor(1 / cross.EndT / df) + 1;
    nh = ceil(1 / cross.StartT / df) + 1;
    nfpt = nh - nl + 1;
    
    % 初始化相位图像矩阵
    fvImage = zeros(VImgPt, nfpt);
    
    % 计算相位信息
    for i = nl:nh
        n = i - nl + 1;
        kr = 2 * pi * fdata(i) * StaDist / VPoint;
        
        % far field phase approximation
        phaseGF = angle(complex(cos(kr + pi/4), -sin(kr + pi/4)));
        
        % 计算相位差异并填充到矩阵
        fvImage(:, n) = cos(phaseGF - phaseEGF(i));
    end
    
    % 网格生成和插值
    [X, Y] = meshgrid(1 ./ fdata(nl:nh), VPoint);
    [XI, YI] = meshgrid(TPoint, VPoint);
    PhaseVImg = interp2(X, Y, fvImage, XI, YI, 'cubic');
    
    % 归一化处理
    for i = 1:crossNumCtrT
        PhaseVImg(:, i) = PhaseVImg(:, i) / max(PhaseVImg(:, i));
    end
end