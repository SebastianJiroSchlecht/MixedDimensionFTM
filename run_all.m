% Sebastian J. Schlecht, Sunday, 8 March 2020
%
% run all experiments

tic

startup

make_stringAnimation
make_stringRotationAnimation

%% sound examples
for position = 1:17
    sourceType = 'string';
    make_soundExample
end

position = 1;
sourceType = 'point';
make_soundExample

%%
sourceType = 'stringOrth';
make_connectionPlot

sourceType = 'string';
make_connectionPlot

sourceType = 'point';
make_connectionPlot

%% wave animation
sourceType = 'string';
make_waveAnimation

sourceType = 'point';
make_waveAnimation

toc
