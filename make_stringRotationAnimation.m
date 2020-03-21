% Sebastian J. Schlecht, Friday, 20 March 2020
clear; clc; close all;

%% Simulation Basics
[Fs,T,dur,t,len] = simulationParameters(0.02);

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


% TODO: standardize this
if wantToRecord
    v = VideoWriter(videoName,'MPEG-4');
    open(v);
else
    v = [];
end

stringAngle = linspace(0,2*pi,500);

for it = 1:length(stringAngle)
    fprintf('Frame %d / %d\n', it, length(stringAngle));
    
    subplot('Position',[0.1 0.1 0.8 0.5])
    [stringA,T12] = plotT12(stringAngle(it), string, s,r);
    
    subplot('Position',[0.3 0.7 0.6 0.2])
    plotTF(T12,s,r);
    
    subplot('Position',[0.1 0.75 0.1 0.1])
    plot(stringA.x([0 1]), stringA.y([0 1]),'r','LineWidth', 3);
    xlim([1 3]);
    ylim([2 4]);
    grid on;
    
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
stringOrigin = [2; 3];
string = setStringPosition(string, string.l, stringAngle, stringOrigin);

%% Connect Models
T12 = connectStringModel(string.x, string.y, s.ftm.Ks, s.ftm.nmu, r.ftm.K1, r.ftm.K2, s.ftm.Mu, r.ftm.Mu);

%% Analyze T12
[f,fInd] = sort(s2f(r.ftm.smu(1:end/2)),'ascend');
T12_ = T12(1:end/2,1:end/2);

plotMatrix(clip(mag2db(abs(T12_(fInd,:))),[-50 20]));
xticklabels(round(s2f(s.ftm.smu)));
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

% Transfer Functions
lin2dB = @(x) clip(mag2db(abs(x)),[-100 80]);
plot(s2f(w),lin2dB(stringPickup)); hold on;
plot(s2f(w),lin2dB(roomPickup)); hold off;
xlabel('Frequency [Hz]')
ylabel('Magnitude [dB]')
ylim([-100 60]);
grid on;
% legend({'String Pickup', 'Room Pickup'},'Location','NorthOutside');
end




