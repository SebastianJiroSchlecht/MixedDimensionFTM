% verify T
% Sebastian J. Schlecht, Tuesday, 10 March 2020
%
% first generate room.mat and string.mat
clear; clc; close all;

%% Version 1
s = load('string.mat');
r = load('room.mat');

pos = [r.ftm.x(0), r.ftm.y(0); r.ftm.x(1), r.ftm.y(1)];
[excite,T12] = fct_excite_string(r.ftm, r.room, s, pos);

%% Version 2
T12_ = connectModels(r.ftm.x, r.ftm.y, s.ftm.Ks, s.ftm.nmu, r.ftm.K1, r.ftm.K2, s.ftm.Mu, r.ftm.Mu);


%%
T12(1:3,1:3)
T12_(1:3,1:3)
T12(1:30,1:10) ./ T12_(1:30,1:10)