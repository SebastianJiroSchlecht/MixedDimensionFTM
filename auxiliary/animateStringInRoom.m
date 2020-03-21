function  animateStringInRoom(x, y, space, time, string, stringSpace, stringTime, downsample, wantToRecord, v)
% Argument shape
% space = [x,y,modes]
% time = [time, modes]
% 
% Sebastian J. Schlecht, Friday, 21 February 2020

%% Room Plot
h = surf(x, y, zeros(length(y),length(x)),'edgecolor','none');

xlabel('Space [x]');
ylabel('Space [y]');
view([0 90]);
set(gca,'DataAspectRatio',[1 1 1])
shading interp;
colorbar
caxis([-1 1])

%% String plot
svec = [string.x(1) - string.x(0), string.y(1) - string.y(0)] ;
snull = -null(svec);
snum = size(stringSpace,1);
sx = string.x(linspace(0,1,snum)).';
sy = string.y(linspace(0,1,snum)).';
s = plot3(sx,sy,ones(snum,1)*10,'r','LineWidth',1);

%% Animate
len = size(time,2);
visualAmplification = 30;
for k = 1:downsample:len
    fprintf('Frame %d / %d\n', k, len);
    
    t = permute(time(:,k),[3 4 1 2]);
    d = sum(space .* t, 3);
    set(h, 'ZData', real(d).' );

    defl = real(stringSpace * stringTime(:,k)) * visualAmplification;
    set(s, 'XData', sx + snull(1) * defl,...
           'YData', sy + snull(2) * defl);
       
    if wantToRecord
        frame = getframe(gcf);
        writeVideo(v,frame);
    else
        pause(0.1)
    end
end
