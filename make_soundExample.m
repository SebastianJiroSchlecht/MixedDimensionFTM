% Sebastian J. Schlecht, Friday, 20 March 2020

%% Include directories
clear; clc; close all;

%% Simulation Basics
[Fs,T,dur,t,len] = simulationParameters(10);

%% Room model
[room,r.ftm] = roomParameters();
[r.ftm, r.state] = createRoomModel(r.ftm,room,T);

%% String Model
string = stringParameters();
[s.ftm, s.state] = createStringModel(string, T);
        
sourceType = 'string';
switch sourceType
    case 'string'
        T12 = connectStringModel(string.x, string.y, s.ftm.Ks, s.ftm.nmu, r.ftm.K1, r.ftm.K2, s.ftm.Mu, r.ftm.Mu);
    case 'point'
        T12 = connectPointModel(string.x, string.y, s.ftm.Ks, s.ftm.nmu, r.ftm.K3, s.ftm.Mu, r.ftm.Mu);
end


%% SIMULATION - Time domain
%% String - Create exciation functions
[excite_imp, excite_ham] = createExcitations(s.ftm, string, len, t, string.excitePosition);
[s.ybar,s.y] = simulateTimeDomain(s.state.Az,s.state.C,excite_ham,T);

%% Room - Simulation time domain
[r.ybar,r.y] = simulateTimeDomainPerMode(r.state.Az,r.state.C,T12,s.ybar,T);

%% Sound
soundsc(r.y,Fs);
% soundsc(s.y(1,:),Fs);

%% Save
audiowrite(['./data/' sourceType 'InRoom.wav'],rescale(r.y,-.99,.99),Fs);
audiowrite(['./data/' 'stringOnly.wav'],rescale(s.y(1,:),-.99,.99),Fs);


