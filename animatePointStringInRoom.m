function  animatePointStringInRoom(x, y, space, time, pos, defl, downsample)
% Argument shape
% space = [x,y,modes]
% time = [time, modes]
% 
% Sebastian J. Schlecht, Friday, 21 February 2020

% TODO: add gif

len = size(time,1);

h = surf(x, y, zeros(length(y),length(x)),'edgecolor','none'); 
xlabel('Space [x]');
ylabel('Space [y]');
view([0 90]);
set(gca,'DataAspectRatio',[1 1 1])
shading interp;
colorbar
caxis([-1 1])

for k = 1:downsample:len
    
    t = permute(time(k,:),[3 4 2 1]);
    d = sum(space .* t, 3);
    set(h, 'ZData', real(d).' );

    %% For ploting
    pause(0.1)
end
