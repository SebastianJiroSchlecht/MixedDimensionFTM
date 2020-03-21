%% Basic simulation param
clear; clc; close all;

%% Simulation Basics
Fs = 44.1e3;                           % Sampling frequency
T = (1/Fs);                            % Samplig Time
dur = 10;                             % Duration  
t = 0:T:dur-T;                         % Time vector
len = length(t);                       % Simulation duration

%% String Model
string = stringParameters();
[s.ftm, s.state] = createStringModel(string, T);

%% String - Create exciation functions
[excite_imp, excite_ham] = createExcitations(s.ftm, string, len, t, string.excitePosition);
[s.ybar,s.y] = simulateTimeDomain(s.state.Az,s.state.C,excite_ham,T);


% write stuff
disp('End Time Domain Sim');
y1 = real(y(1,:)); 
y1 = y1/max(abs(y1));
% soundsc(y1,Fs);
% audiowrite('./gitec/full_string/sound.wav',y1, Fs);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Save relevant stuff for room excitation 
%
% ftm.kprim: primal eigenfunctions for the pickup position ftm.x
% ftm.nmu: scaling factors nmu (in the room n_nu)
% state.C: Important for the creation of matrices T. For the velocity only
% the first line of C is relevant 
% ybar: Temporal progression of each mode of the string. Very relevant for
% time-domain simulations  
save('./data/string.mat','ftm','state','ybar','Fs')


%% Spatial Animation
figure(742); hold on
downsample = 1;
x = linspace(0,string.l,1000);
deflection = state.Cs(x,1:ftm.Mu);
animateString(deflection.', ybar.', downsample);




