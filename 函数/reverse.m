function  [cross_corr] = reverse(cross_corr)

num1 = length(cross_corr); 
num2 = round(num1/2);   %   长度截一半
x = fliplr(cross_corr(1:num2)');   %   倒转数据，找到零时刻起算点
y = cross_corr(num2:num1)';   
cross_corr = (x + y)./2;     %   对称叠加

end