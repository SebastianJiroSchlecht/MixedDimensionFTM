% Sebastian J. Schlecht, Friday, 20 March 2020
clear; clc; close all;

%% Simulation Basics
Fs = 44.1e3;                           % Sampling frequency
T = (1/Fs);                            % Samplig Time
dur = 0.02;                             % Duration
t = 0:T:dur-T;                         % Time vector
len = length(t);                       % Simulation duration

%% Room model
[room,r.ftm] = roomParameters();
[r.ftm, r.state] = createRoomModel(r.ftm,room,T);

%% String Model
string = stringParameters();
[s.ftm, s.state] = createStringModel(string, T);


%% Animation
figure(741); set(gcf,'position',[808   546   800   800],'color','w');
downsample = 1;
wantToRecord = true;
videoName = 'animateStringInRoom_rotation';

if wantToRecord
    v = VideoWriter(videoName,'MPEG-4');
    open(v);
else
    v = [];
end

stringAngle = linspace(0,2*pi,500);

for it = 1:length(stringAngle)
    it
    
    
    subplot('Position',[0.1 0.1 0.8 0.5])
    [stringA,T12] = plotT12(stringAngle(it), string, s,r);
    
    subplot('Position',[0.3 0.7 0.6 0.2])
    plotTF(T12,s,r);
    
    subplot('Position',[0.1 0.75 0.1 0.1])
    plot(stringA.x([0 1]), stringA.y([0 1]),'r','LineWidth', 3);
    xlim([1 3]);
    ylim([2 4]);
    
    
    
    if wantToRecord
        frame = getframe(gcf);
        writeVideo(v,frame);
    else
        pause(0.1)
    end
end

if wantToRecord
    close(v);
end



function [string, T12] = plotT12(stringAngle, string, s,r)
%% Position
% stringAngle = 0.1 * pi;
[sx,sy] = pol2cart(stringAngle, string.l);

stringOrigin = [2; 3];

excite_pos = stringOrigin + [0 sx; 0 sy];

string.x = @(xi) excite_pos(1,1) + xi*( excite_pos(1,2) - excite_pos(1,1));
string.y = @(xi) excite_pos(2,1) + xi*( excite_pos(2,2) - excite_pos(2,1));

string.mid.x = string.x(0.5);
string.mid.y = string.y(0.5);
string.l = norm([string.x(0) - string.x(1); string.y(0) - string.y(1)]);

%% Connect Models
T12 = connectStringModel(string.x, string.y, s.ftm.Ks, s.ftm.nmu, r.ftm.K1, r.ftm.K2, s.ftm.Mu, r.ftm.Mu);

%% Analyze T12
[f,fInd] = sort(imag(r.ftm.smu(1:end/2)),'ascend');
T12_ = T12(1:end/2,1:end/2);

% figure(152);
plotMatrix(clip(mag2db(abs(T12_(fInd,:))),[-50 20]));
xticklabels(round(imag(s.ftm.smu)));
yticks((1:100:length(f))+0.5)
yticklabels(round(f(1:100:end)));
% title(['String Rotation: ' num2str(stringAngle/pi)])
xlabel('String Frequency [Hz]')
ylabel('Room Frequency [Hz]')
axis tight
colorbar
caxis([-50 20])
end


function plotTF(T12,s,r)

%% Plot Transfer Function
w = 1i*linspace(0,10000,1000);
stringOut = 1./(w - diag(s.state.As)) .* s.state.Ks4_xe;
stringPickup = s.state.Cw * stringOut;
roomIn = T12 * stringOut;
roomOut = 1./(w - diag(r.state.As)) .* roomIn;
roomPickup = r.state.C * roomOut;

% Impulse excitation at string.mid
% init = r.ftm.primKern1(string.mid.x,string.mid.y, 1:r.ftm.Mu);
% roomTFPoint = r.state.C * (1./(w - diag(r.state.As)) .* init);

% Transfer Functions
% figure(432); hold on;
lin2dB = @(x) clip(mag2db(abs(x)),[-100 80]);
plot(imag(w),lin2dB(stringPickup)); hold on;
plot(imag(w),lin2dB(roomPickup)); hold off;
xlabel('Frequency [Hz]')
ylabel('Magnitude [dB]')
ylim([-100 60]);
% legend({'String Pickup', 'Room Pickup'},'Location','NorthOutside');
end




