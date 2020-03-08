function  animateString(space, time, downsample)
% Argument shape
% space = [x,modes]
% time = [time, modes]
% 
% Sebastian J. Schlecht, Friday, 21 February 2020

len = size(time,1);

stringPoints = size(space,1);
s = plot(linspace(0,1,stringPoints),zeros(stringPoints,1),'r');
xlabel('String [x]');
ylabel('Deflection [y]');
ylim([-1 1]*0.1);


for k = 1:downsample:len
    
    t = time(k,:);
    d = sum(space .* t, 2);
    set(s, 'YData', real(d));
    %% For ploting
    pause(0.1)
end

