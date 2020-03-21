%% Make string animation
clear; clc; close all;

%% Simulation Basics
[Fs,T,dur,t,len] = simulationParameters(0.01);

%% String Model
string = stringParameters();
[s.ftm, s.state] = createStringModel(string, T);

%% String - Create exciation functions
[excite_imp, excite_ham] = createExcitations(s.ftm, string, len, t, string.excitePosition);
[s.ybar,s.y] = simulateTimeDomain(s.state.Az,s.state.C,excite_ham,T);

%% Spatial Animation
figure(742); hold on; grid on; set(gcf,'color','w');
downsample = 1;
x = linspace(0,string.l,1000);
stringC = s.state.Cs(x,1:s.ftm.Mu) * 10;

wantToRecord = false;
videoName = 'string_animation';
recordVideo(wantToRecord, videoName, @(w,v) animateString(stringC, s.ybar , downsample, w, v) )
