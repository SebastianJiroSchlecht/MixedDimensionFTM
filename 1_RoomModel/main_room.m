%% Include directories
clear; clc; close all;

%% Simulation Basics
Fs = 44.1e3;                           % Sampling frequency
T = (1/Fs);                            % Samplig Time
t = 0:T:2-T;                             % Time vector
len = length(t);                       % Simulation duration

%% Room model basics
room.Lx = 6;
room.Ly = 6;

room.c0 = 340;
room.rho = 1.2041;

pickup.x = 9;
pickup.y = 9;

%% FTM Basics
ftm.Mux = 10;                               % number of evs in x-direction
ftm.Muy = 10;                               % number of evs in y-direction

ftm.Mu = ftm.Mux*ftm.Muy;                   % number of all evs

%necessary due to the matlab indexing starts at 1
ftm.mux = 1:1:ftm.Mux;
ftm.muy = 1:1:ftm.Muy;

%% Eigenvalues and indexing

% First only positive eigenvalues are calculated (see (8))
% The complex conjugated are added separately
index = fct_index(ftm);
[smu, lambdaX, lambdaY] = fct_eigenvalues_room(ftm, index, room);

% Add complex conjugated
ftm.smu = [smu (conj(smu))];
ftm.lambdaX = [lambdaX lambdaX];
ftm.lambdaY = [lambdaY lambdaY];

ftm.Mu = length(ftm.smu);

%% Eigenfunctions
% at observation point pickup = [x y]
[ftm.primKern, ftm.adjKern, ftm.K1, ftm.K2] = fct_eigenfunctions_room(ftm, room, pickup);

%% Scaling factor
ftm.nmu = fct_nmu_room(ftm, room);


%% State space model
ftm.smu = ftm.smu - 1; %TODO: what is this? maybe give it a different name?
state.As = diag(ftm.smu);
state.Az = diag(exp(ftm.smu*T));

state.C = ftm.primKern./ftm.nmu;

%% Excitation - DEBUG
init = zeros(1,ftm.Mu);
exc.x = 2.5;
exc.y = 1.8;

% Impulse excitation at exc.
mu = 1:ftm.Mu;
lx = ftm.lambdaX(mu);
ly = ftm.lambdaY(mu);
init(mu) = cos(lx.*exc.x).*cos(ly.*exc.y);

% Not finished yet --> Will be extended to:
% - non impulsive exctiation
% - time/space dependent excitation
% - constant sine excitation on a line (preparation for string)
switch 'string'
    case 'point'
        [excite] = fct_excite(ftm, t, exc);
    case 'string'
        excite_pos = [4 2; 3 4];
        ftm.x = @(xi) excite_pos(1,1) + xi*( excite_pos(1,2) - excite_pos(1,1));
        ftm.y = @(xi) excite_pos(2,1) + xi*( excite_pos(2,2) - excite_pos(2,1));
        
%         [excite, deflection] = fct_excite_cont(ftm, room, excite_pos, t);
        [excite,T12] = fct_excite_string(ftm, room);
end
%% Simulation param
ybar = zeros(ftm.Mu,length(t));        % state vector
w = zeros(1,length(t));               % concentration
time.k = 0:1:length(t)-1;              % time vector
fe_t = zeros(ftm.Mu, length(t));
fe_t(:,1) = init;

% reduce state vector (only deflection is simulated)
state.Cw = state.C(1,:);

%% Simulation time domain
ybar(:,1) = T*excite(:,1);
w(1) = state.Cw*ybar(:,1);
for n = 2:length(time.k)
    % state equation - Use state.A or state.Ac
    %    ybar(:,n) = state.Az*ybar(:,n-1) + T*fe_t(:,n);
    ybar(:,n) = state.Az*ybar(:,n-1) + T*excite(:,n);
    
    % output equation
    w(n) = state.Cw*ybar(:,n);
end
w = real(w); 
out = w/max(w); 
sound(w,Fs); 

%% Spatial simulation
X = 200;
Y = 200;

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
save('./data/room.mat','ftm','state','room','ybar','Fs')

%% Animation
figure(741); hold on
downsample = 1;
animateSpaceAndTime(x, y, permute(C, [2,3,1]), ybar.', downsample)
