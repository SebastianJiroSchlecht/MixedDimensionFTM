function  plotAnimate(x, y, data, len,sample)
figure,hold on

yData = real(data);
% [PHI, R] = meshgrid(phi, r);
% maxZ = max(yData(:));
% figure('units','normalized','outerposition',[0 0 1 1]);
% hold on;
figure;
for k = 2:sample:len
 %  plot(xData,yData(:,k)/max(yData(:,k)),'LineWidth',2);
%    plot(x,y(:,k),'LineWidth',2); 
   %surf(x,y,data(:,:,k)); xlabel('space x'); ylabel('Space y'); zlabel('c(x,t)');
   %
%    xlim([0 0.65]);
%    grid on;
    
   
    
        
%         color = 'Konzentration';
%         colormap('jet')
        surf(x, y, squeeze(real(yData(k,:,:))),'edgecolor','none');
%         light, lighting phong
        zlim([-1 1]);
%         axis tight equal off
        xlabel('Space [x]');
        ylabel('Space [y]');
%         title('u = 2');
        view([0 90]);
%         c = colorbar;
%         c.Label.String = 'Concentration';
%         caxis([0 1])
%    
% Save single png's
%    fig = gcf;
%    fig.PaperUnits = 'centimeters';
%    fig.PaperPosition = [0 0 24 12];
%    print(sprintf('./Video/img%03d.png',(k - 2)/2 ),'-dpng','-r0');
%    
   %% For ploting 
    pause(0.1)
   clf
end
end
 