% Sebastian J. Schlecht, Monday, 2 March 2020
clear; clc; close all;

s = load('string.mat');
r = load('room.mat');

T12 = connectModels(r.ftm.x, r.ftm.y, s.ftm.Ks, s.ftm.nmu, r.ftm.K1, r.ftm.K1, s.ftm.Mu, r.ftm.Mu);

%%
excite = T12 * s.ybar;

%% Simulation param 
T = (1/r.Fs); 
t = 1:length(s.ybar);
ybar = zeros(r.ftm.Mu,length(t));        % state vector 
w = zeros(1,length(t));               % concentration
time.k = 0:1:length(t)-1;              % time vector 
% fe_t = zeros(r.ftm.Mu, length(t));
% fe_t(:,1) = init;

% reduce state vector (only deflection is simulated)
r.state.Cw = r.state.C(1,:); 

%% Simulation time domain   
 ybar(:,1) = T*excite(:,1);
for n = 2:length(time.k)
    % state equation - Use state.A or state.Ac
%    ybar(:,n) = state.Az*ybar(:,n-1) + T*fe_t(:,n);
     ybar(:,n) = r.state.Az*ybar(:,n-1) + T*excite(:,n);
    
    % output equation
    w(n) = r.state.Cw*ybar(:,n);
end
% return; 

%% Spatial simulation 
X = 120;
Y = 130;

%spatial
deltaX = r.room.Lx/X;
x = 0:deltaX:r.room.Lx;

deltaY = r.room.Ly/Y;
y = 0:deltaY:r.room.Ly;


% Spatial eigenfunctions, only preassure is interesting 
mu = 1:r.ftm.Mu;
xi = 1:length(x);
yi = 1:length(y);
lx = r.ftm.lambdaX(mu).';
ly = r.ftm.lambdaY(mu).';
kern = 4*cos(lx.*x(xi)).*cos(ly.* permute(y(yi),[1 3 2]));

C = kern.* r.ftm.nmu(mu).';

% Animation
figure(741); hold on
downsample = 1;
deflection = 0;
animateSpaceAndTime(x, y, permute(C, [2,3,1]), ybar.', r.excite_pos, deflection, downsample)