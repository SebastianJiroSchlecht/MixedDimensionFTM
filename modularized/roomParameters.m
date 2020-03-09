function [room,ftm] = roomParameters()

%% Room model basics
room.Lx = 6;
room.Ly = 6;

room.c0 = 340;
room.rho = 1.2041;

room.pickup.x = 9;
room.pickup.y = 9;

%% FTM Basics
ftm.Mux = 10;                               % number of evs in x-direction
ftm.Muy = 10;                               % number of evs in y-direction

ftm.Mu = ftm.Mux*ftm.Muy;                   % number of all evs
