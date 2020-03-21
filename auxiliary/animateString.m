function  animateString(space, time, downsample, wantToRecord, v)
% Argument shape
% space = [modes,x]
% time = [modes,time]
% 
% Sebastian J. Schlecht, Friday, 21 February 2020

len = size(time,2);

stringPoints = size(space,2);
s = plot(linspace(0,1,stringPoints),zeros(stringPoints,1),'r');
xlabel('String [x]');
ylabel('Deflection [y]');
ylim([-1 1]*0.1);

for k = 1:downsample:len
    fprintf('Frame %d / %d\n', k, len);
    
    t = time(:,k);
    d = sum(space .* t, 1);
    set(s, 'YData', real(d));
    
    if wantToRecord
        frame = getframe(gcf);
        writeVideo(v,frame);
    else
        pause(0.1)
    end
end

