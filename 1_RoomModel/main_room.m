%% Include directories
clear; clc; close all;

%% Simulation Basics
Fs = 44.1e3;                           % Sampling frequency
T = (1/Fs);                            % Samplig Time
dur = 0.2;                             % Duration  
t = 0:T:dur-T;                         % Time vector
len = length(t);                       % Simulation duration

%% Room model
[room,ftm] = roomParameters();
[ftm, state] = createRoomModel(ftm,room,T);

%% String Model
string = stringParameters();
[s.ftm, s.state] = createStringModel(string, T);
        
% Impulse excitation at string.mid
init = ftm.primKern1(string.mid.x,string.mid.y, 1:ftm.Mu);

sourceType = 'diracString';
switch sourceType
%     case 'dirac'
%         % Impulse excitation at string.mid.
%         excite(:,1) = init;
%         T12 = zeros(ftm.Mu,s.ftm.Mu);
%         
%     case 'point'
%         [excite] = fct_excite(ftm, T, string.mid);
%         T12 = zeros(ftm.Mu,s.ftm.Mu);
        
    case 'string'
        T12 = connectModels(string.x, string.y, s.ftm.Ks, s.ftm.nmu, ftm.K1, ftm.K2, s.ftm.Mu, ftm.Mu);
    case 'diracString'
        T12 = connectPointModel(string.x, string.y, s.ftm.Ks, s.ftm.nmu, ftm.K3, s.ftm.Mu, ftm.Mu);
end

%% Analyze T12
[f,fInd] = sort(imag(ftm.smu(1:end/2)),'ascend');

T12_ = T12(1:end/2,1:end/2);
figure(152);
plotMatrix(clip(mag2db(abs(T12_(fInd,:))),[-50 10]));

xticklabels(round(imag(s.ftm.smu)));
yticks((1:100:length(f))+0.5)
yticklabels(round(f(1:100:end)));
xlabel('String Frequency [Hz]')
ylabel('Room Frequency [Hz]')
axis tight

%% Create exciation functions
[excite_imp, excite_ham,Ks4_xe] = createExcitations(s.ftm, string, len, t, string.excitePosition);


%% Analyze Transfer Function
w = 1i*linspace(0,10000,1000);
stringOut = 1./(w - diag(s.state.As)) .* Ks4_xe;
stringPickup = s.state.Cw * stringOut;
roomIn = T12 * stringOut;
roomOut = 1./(w - diag(state.As)) .* roomIn;
roomPickup = state.C * roomOut;

roomTFPoint = state.C * (1./(w - diag(state.As)) .* init);

% Transfer Functions
figure(432); hold on;
lin2dB = @(x) clip(mag2db(abs(x)),[-100 40]);
plot(lin2dB(stringPickup))
plot(lin2dB(roomPickup))
xlabel('Frequency [s]')
ylabel('Magnitude [dB]')
legend({'String Pickup', 'Room Pickup'});

% Relative Transfer Function
figure(433); hold on;
lin2dB = @(x) clip(mag2db(abs(x)),[-100 200]);
plot(lin2dB(roomPickup ./ stringPickup))
plot(lin2dB(roomTFPoint))
xlabel('Frequency [s]')
ylabel('Magnitude [dB]')
legend({'Room - String Relative Transfer Function', 'Room Point Transfer Function'});







%% SIMULATION - Time domain



xi = linspace(0,string.l,50);
stringC = s.state.Cs(xi, 1:s.ftm.Mu);
[s.ybar,s.y] = simulateTimeDomain(len,s.state.Az,stringC.',excite_ham,T);

excite = T12*s.ybar;

%% Simulation time domain
duration = Fs/10;
[ybar,w] = simulateTimeDomain(duration,state.Az,state.C,excite,T);

%% Sound
soundsc(w,Fs);



%% Spatial simulation
X = 100;
Y = 100;

%spatial
x = linspace(0,room.Lx,X);
y = linspace(0,room.Ly,Y);

% Spatial eigenfunctions, only preassure is interesting
C = ftm.primKern1(x, permute(y,[1 3 2]), 1:ftm.Mu) ./ftm.nmu ;
C = permute(C, [2,3,1]);

% Save
% save('./data/room.mat','ftm','state','room','ybar','Fs')

%% Animation
figure(741); hold on;
set(gcf,'position',[808   546   896   391]);
downsample = 1;
wantToRecord = true;


switch sourceType
    case 'string'
        gifName = 'animateSpaceAndTime.gif';
        animate = @animateSpaceAndTime;
    case 'diracString'
        gifName = 'animatePointStringInRoom.gif';
        animate = @animatePointStringInRoom;
end
        
        
if wantToRecord
    gif(gifName,'frame',gcf);
end
animate(x, y, C, ybar.', string, s.y*30, downsample, wantToRecord)




