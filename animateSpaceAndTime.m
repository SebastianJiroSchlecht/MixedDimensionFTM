function  animateSpaceAndTime(x, y, space, time, string, defl, downsample, wantToRecord)
% Argument shape
% space = [x,y,modes]
% time = [time, modes]
% 
% Sebastian J. Schlecht, Friday, 21 February 2020



len = size(time,1);

snum = size(defl,1);
sx = string.x(linspace(0,1,snum)).';
sy = string.y(linspace(0,1,snum)).';

svec = [string.x(1) - string.x(0), string.y(1) - string.y(0)] ;
snull = -null(svec);

h = surf(x, y, zeros(length(y),length(x)),'edgecolor','none');
s = plot3(sx,sy,ones(snum,1)*10,'r','LineWidth',3);
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

    
    set(s, 'XData', sx + snull(1) * defl(:,k),...
           'YData', sy + snull(2) * defl(:,k));
       
    %% For ploting
    pause(0.1)
    if wantToRecord
        gif
    end
end

