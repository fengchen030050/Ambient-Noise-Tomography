function  Dispercurve = AutoPickDisper(Period,Velocity,ImageData,searchRadius,DisperStereotype)

TPoint = Period(1):0.05:Period(2);  
VPoint = Velocity(1):0.01:Velocity(2); 

[x,y] = ginput(1);
[~,~,Dispercurve] = AutoSearch(TPoint,VPoint,x,y,ImageData,searchRadius,DisperStereotype);

figure; 
imagesc(TPoint,VPoint,ImageData); 
xlabel('周期(s)');
ylabel('群速度(km/s)');
title('FTAN时频分析图');
xticks(TPoint(1):2:TPoint(end));
yticks(VPoint(1):0.25:VPoint(end));
xlim([TPoint(1) TPoint(end)]);
ylim([VPoint(1) VPoint(end)]);
colorbar;
axis xy;  
hold on; 
plot(Dispercurve(:,1),Dispercurve(:, 2), 'r', 'LineWidth', 2);
hold off;
legend;

end






