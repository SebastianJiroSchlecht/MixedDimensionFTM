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
[ftm.primKern, ftm.adjKern, ftm.K1, ftm.K2, ftm.K3] = fct_eigenfunctions_room(ftm, room, pickup);

%% Scaling factor
ftm.nmu = fct_nmu_room(ftm, room);






%% Simulation Basics
Fs = 44.1e3;                           % Sampling frequency
T = (1/Fs);                            % Samplig Time
dur = 0.2;
t = 0:T:dur-T;                             % Time vector
len = length(t);                       % Simulation duration

%% Excitation
exc.x = 2.5;
exc.y = 1.8;

switch 'diracString'
    case 'dirac'
        % Impulse excitation at exc.
        mu = 1:ftm.Mu;
        lx = ftm.lambdaX(mu);
        ly = ftm.lambdaY(mu);
        init(mu) = cos(lx.*exc.x).*cos(ly.*exc.y);

        excite(:,1) = init;
        
    case 'point'
        [excite] = fct_excite(ftm, T, exc);
        
    case 'string'
        %%
        excite_pos = [4 2; 3 4];
        ftm.x = @(xi) excite_pos(1,1) + xi*( excite_pos(1,2) - excite_pos(1,1));
        ftm.y = @(xi) excite_pos(2,1) + xi*( excite_pos(2,2) - excite_pos(2,1));
        
        s = load('string.mat');
        pos = [ftm.x(0), ftm.y(0); ftm.x(1), ftm.y(1)];
        [excite,T12] = fct_excite_string(ftm, room, s, pos);
        
    case 'string2'
        string = stringParameters();
        stringPickupPosition = 1/pi; % TODO move to stringParameters
        [s.ftm, s.state] = createModel(string, T, stringPickupPosition);
        
        %% Create exciation functions
        len = Fs * dur;
        [excite_imp, excite_ham] = createExcitations(s.ftm, string, len, t, T);
        
        %% SIMULATION - Time domain
        [s.ybar,s.y] = simulateTimeDomain(len,s.state.Az,s.state.C,excite_ham,T);
        
        %% Connect models
        T12 = connectModels(string.x, string.y, s.ftm.Ks, s.ftm.nmu, ftm.K1, ftm.K2, s.ftm.Mu, ftm.Mu);
        excite = T12*s.ybar;
        
    case 'diracString'
        string = stringParameters();
        stringPickupPosition = 1/pi;
        [s.ftm, s.state] = createModel(string, T, stringPickupPosition);
        
        %% Create exciation functions
        len = Fs * dur;
        [excite_imp, excite_ham] = createExcitations(s.ftm, string, len, t, T);
        
        %% SIMULATION - Time domain
        [s.ybar,s.y] = simulateTimeDomain(len,s.state.Az,s.state.C,excite_ham,T);
        
        %% Connect models
        T12 = connectPointModel(string.x, string.y, s.ftm.Ks, s.ftm.nmu, ftm.K3, s.ftm.Mu, ftm.Mu);
        excite = T12*s.ybar;
end

%% Analyze T12
[f,fInd] = sort(imag(ftm.smu(1:end/2)),'ascend');

T12_ = T12(1:end/2,1:end/2);
figure(152);
plotMatrix(clip(mag2db(abs(T12_(fInd,:))),[-50 10]));


%% State space model
ftm.smu = ftm.smu - 1; %TODO: what is this? maybe give it a different name?
state.As = diag(ftm.smu);
state.Az = diag(exp(ftm.smu*T)); % TODO: add damping term
state.C = ftm.primKern./ftm.nmu;
state.Cw = state.C(1,:);

%% Analyze Transfer Function
w = 1i*linspace(0,10000,1000);
stringOut = 1./(w - diag(s.state.As));
stringPickup = s.state.Cw * stringOut;
roomIn = T12 * stringOut;
roomOut = 1./(w - diag(state.As)) .* roomIn; 
roomPickup = state.Cw * roomOut;

% Transfer Functions
figure(432); hold on;
lin2dB = @(x) clip(mag2db(abs(x)),[-100 20]);
plot(lin2dB(stringPickup))
plot(lin2dB(roomPickup))
xlabel('Frequency [s]')
ylabel('Magnitude [dB]')
legend({'String Pickup', 'Room Pickup'});

% Relative Transfer Function
figure(433); hold on; 
lin2dB = @(x) clip(mag2db(abs(x)),[-100 200]);
plot(lin2dB(roomPickup ./ stringPickup))
xlabel('Frequency [s]')
ylabel('Magnitude [dB]')
legend({'Room - String Relative Transfer Function'});

%% Simulation time domain
duration = Fs/10;
[ybar,w] = simulateTimeDomain(duration,state.Az,state.Cw,excite,T);

%% Sound
soundsc(w,Fs);

%% Spatial simulation
X = 100;
Y = 100;

%spatial
x = linspace(0,room.Lx,X);
y = linspace(0,room.Ly,Y);

% Spatial eigenfunctions, only preassure is interesting
mu = 1:ftm.Mu;
lx = ftm.lambdaX(mu).';
ly = ftm.lambdaY(mu).';
kern = 4*cos(lx.*x).*cos(ly.* permute(y,[1 3 2]));

C = kern./ftm.nmu(mu).';

% Save
% save('./data/room.mat','ftm','state','room','ybar','Fs')

%% Animation
figure(741);
downsample = 1;
animateSpaceAndTime(x, y, permute(C, [2,3,1]), ybar.', downsample)
