function [Y1,Y2,SearchPoint] = AutoSearch(TPoint,VPoint,InintiaX,InintiaY,ImageData,searchRadius,DisperStereotype)
% 本函数用于自动搜索最大值点
% 
% InintiaX就是你选择的第一个点，可由ginput函数给出
% ImageData就是基于二维矩阵的图像
% DisperStereotype = 1 代表群速度提取； 2 代表相速度提取
% searchRadius 即搜索半径，一般建议为一个周期T内
% 
% 
% 优化：简化代码，有时间再做
%
%
%
%


    col_index = length(TPoint);

    Y1 = []; 
    Y2 = []; 
    InintiaX = round(InintiaX);
    dT = TPoint(2)-TPoint(1);
    dV = VPoint(2)-VPoint(1);


% %% 群速度提取    
% if DisperStereotype == 1 
%     if InintiaX > 1 && InintiaX < col_index
%         % 向左搜索
%         for j = 1:InintiaX
%             [~, max_row] = max(ImageData(:, j));
%             Y1 = [max_row, j; Y1]; 
%         end
%         % 向右搜索
%         for j = InintiaX:col_index
%             [~, max_row] = max(ImageData(:, j));
%             Y2 = [Y2; max_row, j]; 
%         end
% 
%         
%     SearchPoint = [Y1;Y2]; 
% 
% % 这几行是特殊情况，只要不选点在边界上就没事
% %     elseif InintiaX == 1
% %         % 向右搜索
% %         for i = InintiaX:col_index
% %             [~, max_row] = max(ImageData(:, i));
% %             Y2 = [Y2; max_row, i]; 
% %         end
% %     elseif InintiaX == col_index
% %         % 向左搜索
% %         for i = 1:InintiaX
% %             [~, max_row] = max(ImageData(:, i));
% %             Y1 = [max_row, i; Y1]; 
% %         end
%     end   
% 
% end

%% 群速度提取 
if DisperStereotype == 1 

     if InintiaX > 1 && InintiaX < col_index
        % 向左搜索
        LastPoint = [floor(InintiaX/dT-TPoint(1)/dT), floor(InintiaY/dV-VPoint(1)/dV)];
        for j = LastPoint(1):-1:1
            [~, max_row] = max(ImageData(:, j));
            % 找到所有最大值的行索引
            max_rows = find(ImageData(:, j) == ImageData(max_row, j));
            % 计算与上一个点的距离
            distances = sqrt((j - LastPoint(1))^2 + (max_row - LastPoint(2))^2);
            % 找到距离小于搜索半径的最大值
            valid_indices = distances <= searchRadius;
            if any(valid_indices)
                % 选择距离最小的最大值
                [~, min_idx] = min(distances(valid_indices));
                selected_velocity = max_rows(min_idx);
                % 更新上一个点的坐标
                LastPoint = [j, selected_velocity];
                % 保存结果
                Y1 = [LastPoint;Y1];
            end
        end
        % 向右搜索
        LastPoint = [ceil(InintiaX/dT-TPoint(1)/dT), ceil(InintiaY/dV-VPoint(1)/dV)];
        for j = LastPoint(1):col_index
            [~, max_row] = max(ImageData(:, j));
            % 找到所有最大值的行索引
            max_rows = find(ImageData(:, j) == ImageData(max_row, j));
            % 计算与上一个点的距离
            distances = sqrt((j-LastPoint(1))^2+(max_row-LastPoint(2))^2);
            % 找到距离小于搜索半径的最大值
            valid_indices = distances <= searchRadius;
            if any(valid_indices)
                % 选择距离最小的最大值
                [~, min_idx] = min(distances(valid_indices));
                selected_velocity = max_rows(min_idx);
                % 更新上一个点的坐标
                LastPoint = [j,selected_velocity];
                % 保存结果
                Y2 = [Y2;LastPoint];
            end
        end


% 这几行是特殊情况，只要不选点在边界上就没事
%     elseif InintiaX == 1
%         % 向右搜索
%         for i = InintiaX:col_index
%             [~, max_row] = max(ImageData(:, i));
%             Y2 = [Y2; max_row, i]; 
%         end
%     elseif InintiaX == col_index
%         % 向左搜索
%         for i = 1:InintiaX
%             [~, max_row] = max(ImageData(:, i));
%             Y1 = [max_row, i; Y1]; 
%         end

    end
    
    
    SearchPoint = [Y1;Y2]; 
    SearchPoint(:,1) = TPoint(1)+SearchPoint(:,1).*dT;
    SearchPoint(:,2) = VPoint(1)+SearchPoint(:,2).*dV;
    

end

%% 相速度提取 
if DisperStereotype == 2 

     if InintiaX > 1 && InintiaX < col_index
        % 向左搜索
        LastPoint = [floor(InintiaX/dT-TPoint(1)/dT), floor(InintiaY/dV-VPoint(1)/dV)];
        for j = LastPoint(1):-1:1
            
            range = 10; % 假设范围为 5，可根据需要调整
            lower_bound = max(1, LastPoint(2) - range); % 确保不小于 1
            upper_bound = min(size(ImageData, 1), LastPoint(2) + range); % 确保不大于行数
            % 提取当前列中在范围内的数据
            sub_data = ImageData(lower_bound:upper_bound, j);

            % 检测局部极大值
            TF = islocalmax(sub_data);
            max_row_index = find(TF);
            
            % 如果找到局部极大值
            if ~isempty(max_row_index)
                % 转换回全局索引
                max_row = lower_bound + max_row_index(1) - 1;
                
                % 计算 max_row 与 LastPoint(2) 之间的距离
                distance = sqrt((j-LastPoint(1))^2+(max_row-LastPoint(2))^2);
                
                % 判断距离是否小于 5
                if distance < searchRadius
                    % 更新 LastPoint(2)
                    LastPoint = [j,max_row];
                else
                    break
                end
            else
            end

            
            Y1 = [LastPoint;Y1];
        end
        % 向右搜索
        LastPoint = [ceil(InintiaX/dT-TPoint(1)/dT), ceil(InintiaY/dV-VPoint(1)/dV)];
        for j = LastPoint(1):col_index

            range = 5; % 假设范围为 5，可根据需要调整
            lower_bound = max(1, LastPoint(2) - range); % 确保不小于 1
            upper_bound = min(size(ImageData, 1), LastPoint(2) + range); % 确保不大于行数

            % 提取当前列中在范围内的数据
            sub_data = ImageData(lower_bound:upper_bound, j);
               % 检测局部极大值
            TF = islocalmax(sub_data);
            max_row_index = find(TF);
            
            % 如果找到局部极大值
            if ~isempty(max_row_index)
                % 转换回全局索引
                max_row = lower_bound + max_row_index(1) - 1;
                
                % 计算 max_row 与 LastPoint(2) 之间的距离
                distance = sqrt((j-LastPoint(1))^2+(max_row-LastPoint(2))^2);
                
                % 判断距离是否小于 5
                if distance < searchRadius
                    % 更新 LastPoint(2)
                    LastPoint = [j,max_row];
                else
                    break
                end
            else
            end

 
            Y2 = [Y2;LastPoint];
        end

    end
    
    
    SearchPoint = [Y1;Y2]; 
    SearchPoint(:,1) = TPoint(1)+SearchPoint(:,1).*dT;
    SearchPoint(:,2) = VPoint(1)+SearchPoint(:,2).*dV;
    

end

        
end



