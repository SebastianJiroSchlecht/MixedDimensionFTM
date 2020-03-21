function [Fs,T,dur,t,len] = simulationParameters(dur)

Fs = 44.1e3;                           % Sampling frequency
T = (1/Fs);                            % Samplig Time
% dur = 0.01;                            % Duration  
t = 0:T:dur-T;                         % Time vector
len = length(t);                       % Simulation duration


