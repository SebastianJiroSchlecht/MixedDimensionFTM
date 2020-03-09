%% Include directories
clear; clc; close all;

%% Room model basics
room.Lx = 6;
room.Ly = 6;

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
[ftm.primKern, ftm.adjKern, ftm.K1, ftm.K2] = fct_eigenfunctions_room(ftm, room, pickup);

%% Scaling factor
ftm.nmu = fct_nmu_room(ftm, room);





%% SIMULATION

%% Simulation Basics
Fs = 44.1e3;                           % Sampling frequency
T = (1/Fs);                            % Samplig Time
t = 0:T:0.1-T;                             % Time vector
len = length(t);                       % Simulation duration

%% Excitation
exc.x = 2.5;
exc.y = 1.8;
        
switch 'point'
    case 'dirac'
        % Impulse excitation at exc.
        mu = 1:ftm.Mu;
        lx = ftm.lambdaX(mu);
        ly = ftm.lambdaY(mu);
        init(mu) = cos(lx.*exc.x).*cos(ly.*exc.y);
        
%         excite = zeros(ftm.Mu, length(t));
        excite(:,1) = init;

    case 'point'
        [excite] = fct_excite(ftm, T, exc);
        
    case 'string'
        excite_pos = [4 2; 3 4];
        ftm.x = @(xi) excite_pos(1,1) + xi*( excite_pos(1,2) - excite_pos(1,1));
        ftm.y = @(xi) excite_pos(2,1) + xi*( excite_pos(2,2) - excite_pos(2,1));
        
        
        [excite, deflection] = fct_excite_cont(ftm, room, excite_pos, t);
%         [excite,T12] = fct_excite_string(ftm, room);
end





%% State space model
ftm.smu = ftm.smu - 1; %TODO: what is this? maybe give it a different name?
state.As = diag(ftm.smu);
state.Az = diag(exp(ftm.smu*T));
state.C = ftm.primKern./ftm.nmu;
state.Cw = state.C(1,:);

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
figure(741); hold on
downsample = 1;
animateSpaceAndTime(x, y, permute(C, [2,3,1]), ybar.', downsample)
