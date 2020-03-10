% verify T
% Sebastian J. Schlecht, Tuesday, 10 March 2020
%
% first generate room.mat and string.mat
clear; clc; close all;

%% Version 1
s = load('string.mat');
r = load('room.mat');
[excite,T12] = fct_excite_string(r.ftm, r.room, s);

%% Version 2
T12_ = connectModels(r.ftm.x, r.ftm.y, s.ftm.Ks, s.ftm.nmu, r.ftm.K1, r.ftm.K1, s.ftm.Mu, r.ftm.Mu);

