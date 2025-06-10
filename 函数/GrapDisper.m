function Dispercurve=GrapDisper()

% 初始化点数组
x = [];
y = [];

% 使用 ginput 获取点
while true
    % 获取一个点
    [xi, yi, button] = ginput(1);
    
    % 检查是否按下右键键（button == 0）
    if button == 3
        break;
    end
    
    % 将点添加到数组中
    x = [x, xi];
    y = [y, yi];
    
    hold on
    % 立即绘制点
    plot(xi, yi, 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
end


% 确定点的最大值和最小值
x_min = min(x);
x_max = max(x);

% 使用插值函数
x_new = linspace(x_min, x_max, 50);  % 在 x_min 和 x_max 之间生成 100 个点
y_new = interp1(x, y, x_new, 'spline');  % 使用 spline 插值方法
% 创建矩阵 A，每行是一个 (x_new, y_new) 对
Dispercurve = [x_new', y_new'];


% 绘制结果
figure;
plot(x, y, 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'r');  % 绘制原始点
hold on;
plot(x_new, y_new, 'b-');  % 绘制插值曲线
title('Interpolated Curve');
xlabel('X');
ylabel('Y');
legend('Original Points', 'Interpolated Curve');
hold off;