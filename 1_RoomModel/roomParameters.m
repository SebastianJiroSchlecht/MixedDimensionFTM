function [room,ftm] = roomParameters()

%% Room model basics
room.Lx = 4;
room.Ly = 3;

room.c0 = 340;
room.rho = 1.2041;

room.pickup.x = 1;
room.pickup.y = 1;

%% FTM Basics
ftm.Mux = 50;                               % number of evs in x-direction
ftm.Muy = 50;                               % number of evs in y-direction

% ftm.Mu = ftm.Mux*ftm.Muy;                   % number of all evs
