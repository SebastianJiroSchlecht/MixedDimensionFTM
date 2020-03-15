function  animatePointStringInRoom(x, y, space, time, string, stringSpace, stringTime, downsample, wantToRecord)
% Argument shape
% space = [x,y,modes]
% time = [time, modes]
% 
% Sebastian J. Schlecht, Friday, 21 February 2020

%% String plot
sp1 = subplot(1,2,1); hold on;
set(sp1,'position', [0.1 0.2 0.1 0.6])

snum = size(stringSpace,1);
s = plot(zeros(snum,1),linspace(0,string.l,snum),'r','LineWidth',3);
plot([-10,10],[1 1]*string.pickup,'--k');
xlabel('Deflection');
ylabel('Space');
xlim([-1 1]*0.3);


%% Room plot
sp2 = subplot(1,2,2); hold on;
set(sp2,'position', [0.3 0.1 0.6 0.8])
h = surf(x, y, zeros(length(y),length(x)),'edgecolor','none');
plot3( string.x(0.5), string.y(0.5), 10, 'rx', 'MarkerSize', 5);
xlabel('Space [x]');
ylabel('Space [y]');
view([0 90]);
set(gca,'DataAspectRatio',[1 1 1])
shading interp;
colorbar
caxis([-1 1])

%% Animate
len = size(time,2);
visualAmplification = 30;
for k = 1:downsample:len
    
    t = permute(time(:,k),[3 4 1 2]);
    d = sum(space .* t, 3);
    set(h, 'ZData', real(d).' );

    defl = stringSpace * stringTime(:,k) * visualAmplification; 
    set(s, 'XData', real(defl));
    %% For ploting
    pause(0.1)
    if wantToRecord
        gif
    end
end

