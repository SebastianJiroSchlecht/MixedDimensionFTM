%% Include directories
clear; clc; close all;

%% Room model basics
room.Lx = 6;
room.Ly = 8;

room.c0 = 340;
room.rho = 1.2041;

pickup.x = 9;
pickup.y = 9;

%% FTM Basics
ftm.Mux = 50;                               % number of evs in x-direction
ftm.Muy = 50;                               % number of evs in y-direction

%% Eigenvalues and indexing
index = fct_index(ftm);
[ftm.smu, ftm.lambdaX, ftm.lambdaY] = fct_eigenvalues_room(ftm, index, room);

ftm.Mu = length(ftm.smu);

%% Eigenfunctions
% at observation point pickup = [x y]
[ftm.primKern, ftm.primKern1, ftm.adjKern, ftm.K1, ftm.K2, ftm.K3] = fct_eigenfunctions_room(ftm, room, pickup);

%% Scaling factor
ftm.nmu = fct_nmu_room(ftm, room);



%% Simulation Basics
Fs = 44.1e3;                           % Sampling frequency
T = (1/Fs);                            % Samplig Time
dur = 0.2;
t = 0:T:dur-T;                             % Time vector
len = length(t);                       % Simulation duration

%% Excitation
string = stringParameters();
[s.ftm, s.state] = createModel(string, T, string.pickup);
%% Create exciation functions
[excite_imp, excite_ham,Ks4_xe] = createExcitations(s.ftm, string, len, t, string.excitePosition);
%% SIMULATION - Time domain
xi = linspace(0,string.l,50);
stringC = s.state.Cs(xi, 1:s.ftm.Mu);
[s.ybar,s.y] = simulateTimeDomain(len,s.state.Az,stringC.',excite_ham,T);
        
% Impulse excitation at string.mid
init = ftm.primKern1(string.mid.x,string.mid.y, 1:ftm.Mu);

switch 'diracString'
    case 'dirac'
        % Impulse excitation at string.mid.
        excite(:,1) = init;
        T12 = zeros(ftm.Mu,s.ftm.Mu);
        
    case 'point'
        [excite] = fct_excite(ftm, T, string.mid);
        T12 = zeros(ftm.Mu,s.ftm.Mu);
        
    case 'string'
        T12 = connectModels(string.x, string.y, s.ftm.Ks, s.ftm.nmu, ftm.K1, ftm.K2, s.ftm.Mu, ftm.Mu);
        excite = T12*s.ybar;
        
    case 'diracString'
        T12 = connectPointModel(string.x, string.y, s.ftm.Ks, s.ftm.nmu, ftm.K3, s.ftm.Mu, ftm.Mu);
        excite = T12*s.ybar;
end

%% Analyze T12
[f,fInd] = sort(imag(ftm.smu(1:end/2)),'ascend');

T12_ = T12(1:end/2,1:end/2);
figure(152);
plotMatrix(clip(mag2db(abs(T12_(fInd,:))),[-50 10]));


%% State space model
damping = 1;
ftm.dsmu = ftm.smu - damping; %TODO: what is this? maybe give it a different name?
state.As = diag(ftm.dsmu);
state.Az = diag(exp(ftm.dsmu*T)); % TODO: add damping term
state.C = ( ftm.primKern1(pickup.x, pickup.y, 1:ftm.Mu)./ftm.nmu ).';

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
figure(741);
downsample = 1;
animateSpaceAndTime(x, y, C, ybar.', downsample)






