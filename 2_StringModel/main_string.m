%% Basic simulation param
clear; clc; close all;

Fs = 48000; 
T = 1/Fs;
dur = 2;
len = Fs * dur;
t = 0:T:dur-T;

%% String parameters
stringH.E = 5.4e9;
stringH.p = 1140;       %in kg/m^3
stringH.l = 0.65;
stringH.A = 0.5188e-6;  %in m^2
stringH.I = 0.171e-12;
stringH.d1 = 8 * 10^-5;
stringH.d3 = 1.4 * 10^-5;
stringH.Ts = 60.97;     % in N

% stringE2.E = 5.4e9;
% stringE2.p = 1140;       
% stringE2.l       = 0.65;
% stringE2.A = pi*(0.5035e-3)^2;        
% stringE2.I = 0.171e-12;     
% stringE2.d1 = 8 * 10^-5;     
% stringE2.d3 = 1.4 * 10^-5;    
% stringE2.Ts  = 13.35; 
% 
% stringE.E = 220e9;
% stringE.p = 7850;
% stringE.length = 0.648;
% stringE.A = 5.0671e-8;
% stringE.I = 2.0432e-16;
% stringE.Ts = 72.2016;
% stringE.d1 = 8 * 10^-6;
% stringE.d3 = 1.4 * 10^-6;

%% Assign to general variable
string = stringH;

%% further parameters
string.a1 = string.d1/(string.E*string.I);
string.a2 = - string.Ts/(string.E*string.I);
string.c1 = - (string.p*string.A)/(string.E*string.I);
string.c2 = string.d3/(string.E*string.I);

%% Create string Model
pickup = 1/pi;   % pickup position, relevant for the eigenfunctions in K 
[ftm, state] = createModel(string, T, pickup);

%% Create exciation functions
[excite_imp, excite_ham] = createExciations(ftm, string, len, t, T);

%% SIMULATION - Time domain
ybar = zeros(ftm.Mu,len);
y = zeros(4,len);

ybar(:,1) = T*excite_imp(:,1);
for k = 2:len
   ybar(:,k) = state.Az*ybar(:,k-1) + T*excite_imp(:,k);
   y(:,k) = state.C*ybar(:,k);
end

% write stuff
disp('End Time Domain Sim');
y1 = real(y(1,:)); 
y1 = y1/max(abs(y1));
% soundsc(y1,Fs);
% audiowrite('./gitec/full_string/sound.wav',y1, Fs);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Spatial Animation
downsample = 1;
x = linspace(0,1,1000);
deflection = state.Cs(x,1:ftm.Mu);
animateString(deflection.', ybar.', downsample);

%% Save relevant stuff for room excitation 
%
% ftm.kprim: primal eigenfunctions for the pickup position ftm.x
% ftm.nmu: scaling factors nmu (in the room n_nu)
% state.C: Important for the creation of matrices T. For the velocity only
% the first line of C is relevant 
% ybar: Temporal progression of each mode of the string. Very relevant for
% time-domain simulations  

save('./data/string.mat','ftm','ybar','Fs')


