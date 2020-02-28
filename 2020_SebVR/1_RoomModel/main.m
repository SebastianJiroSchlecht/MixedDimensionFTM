%% Include directories 
clear; clc; close all;

%% Simulation Basics 
Fs = 44.1e3;                              % Sampling frequency 
T = (1/Fs);                            % Samplig Time  
t = 0:T:1;                             % Time vector
len = length(t);                       % Simulation duration
%% Room model basics
room.Lx = 5;
room.Ly = 7;

room.c0 = 340;
room.rho = 1.2041;

pickup.x = 9; 
pickup.y = 9; 

%% FTM Basics 
ftm.Mux = 12;                               % number of evs in x-direction
ftm.Muy = 12;                               % number of evs in y-direction

ftm.Mu = ftm.Mux*ftm.Muy;                   % number of all evs

%necessary due to the matlab indexing starts at 1
ftm.mux = 1:1:ftm.Mux;
ftm.muy = 1:1:ftm.Muy;
%% Eigenvalues and indexing 

% First only positive eigenvalues are calculated (see (8)) 
% The complex conjugated are added separately 
index = fct_index(ftm);
[smu, lambdaX, lambdaY] = fct_eigenvalues(ftm, index,room);

% Add complex conjugated 
ftm.smu = [smu (conj(smu))];
ftm.lambdaX = [lambdaX lambdaX];
ftm.lambdaY = [lambdaY lambdaY];

ftm.Mu = length(ftm.smu);

%% Eigenfunctions
% at observation point pickup = [x y]
[ftm.primKern, ftm.adjKern] = fct_eigenfunctions(ftm, room, pickup);

%% Scaling factor 
ftm.nmu = fct_nmu(ftm, room);


%% State space model
ftm.smu = ftm.smu - 1;
state.As = diag(ftm.smu);
state.Az = diag(exp(ftm.smu*T));

state.C = ftm.primKern.*ftm.nmu;

%% Excitation - DEBUG 
init = zeros(1,ftm.Mu); 
exc.x = 2.5; 
exc.y = 1.8;
% 
% 
% Impulse excitation at exc. 
mu = 1:ftm.Mu;
lx = ftm.lambdaX(mu);
ly = ftm.lambdaY(mu);
init(mu) = cos(lx.*exc.x).*cos(ly.*exc.y);

% Not finished yet --> Will be extended to:
% - non impulsive exctiation 
% - time/space dependent excitation 
% - constant sine excitation on a line (preparation for string)
% [excite] = fct_excite(ftm, t, exc);
excite_pos = [4 2; 3 3];

[excite, deflection] = fct_excite_cont(ftm, room, excite_pos, t);

%% Simulation param 
ybar = zeros(ftm.Mu,length(t));        % state vector 
w = zeros(1,length(t));               % concentration
time.k = 0:1:length(t)-1;              % time vector 
fe_t = zeros(ftm.Mu, length(t));
fe_t(:,1) = init;

% reduce state vector (only deflection is simulated)
state.Cw = state.C(1,:); 

%% Simulation time domain    
for n = 1:length(time.k)
    % state equation - Use state.A or state.Ac
%    ybar(:,n) = state.Az*ybar(:,indexCor(n-1,len)) + T*fe_t(:,n);
     ybar(:,n) = state.Az*ybar(:,indexCor(n-1,len)) + T*excite(:,n);
    
    % output equation
    w(n) = state.Cw*ybar(:,n);
end
% return; 

%% Spatial simulation 
X = 120;
Y = 130;

%spatial
deltaX = room.Lx/X;
x = 0:deltaX:room.Lx;

deltaY = room.Ly/Y;
y = 0:deltaY:room.Ly;


% Spatial eigenfunctions, only preassure is interesting 
mu = 1:ftm.Mu;
xi = 1:length(x);
yi = 1:length(y);
lx = ftm.lambdaX(mu).';
ly = ftm.lambdaY(mu).';
kern = 4*cos(lx.*x(xi)).*cos(ly.* permute(y(yi),[1 3 2]));

C = kern.* ftm.nmu(mu).';

% Animation
figure(741); hold on
downsample = 10;
animateSpaceAndTime(x, y, permute(C, [2,3,1]), ybar.', excite_pos, deflection, downsample)
