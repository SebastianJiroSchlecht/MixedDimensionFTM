function  animateSpaceAndTime(x, y, space, time, excite_pos, deflection, downsample)
% Argument shape
% space = [x,y,modes]
% time = [time, modes]
% 
% Sebastian J. Schlecht, Friday, 21 February 2020

len = size(time,1);
time = permute(time,[3 4 2 1]);

exciteN = size(deflection,1);
exciteX = linspace(excite_pos(1,1),excite_pos(1,2),exciteN);
exciteY = linspace(excite_pos(2,1),excite_pos(2,2),exciteN);
exciteAmp = -50;

h = surf(x, y, zeros(length(y),length(x)),'edgecolor','none'); 
s = plot(exciteX,exciteY,'r');
zlim([-1 1]);
xlabel('Space [x]');
ylabel('Space [y]');
view([0 90]);
set(gca,'DataAspectRatio',[1 1 1])
shading interp;

for k = 1:downsample:len
    
    t = time(:,:,:,k);
    d = sum(space .* t, 3);
    set(h, 'ZData', real(d).' );
    set(s, 'XData', exciteX, 'YData', exciteY.' + exciteAmp*deflection(:,k));
    %% For ploting
    pause(0.1)
end

