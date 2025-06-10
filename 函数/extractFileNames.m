

function extractFileNames(folderPath,outputPath)

%   保存.txt格式的文件
%   文件夹路径  folderPath = 'D:\1_matlab-代码文件\背景噪声成像\大创-英山地热\ZZ'; 
%   保存路径  outputPath = 'D:\1_matlab-代码文件\背景噪声成像\大创-英山地热\Disper\ZZ.fildername.txt';

    % 检查输入的文件夹路径是否合法
    if ~isfolder(folderPath)
        error('指定的路径不是一个有效的文件夹！');
    end

    % 获取文件夹中的所有文件和子文件夹信息
    folderInfo = dir(folderPath);
    fileID = fopen(outputPath, 'w');

    for i = 1:length(folderInfo)
        if folderInfo(i).isdir == 0
            fprintf(fileID, '%s\n', folderInfo(i).name);
        end
    end

end