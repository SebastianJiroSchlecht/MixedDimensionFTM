function string = stringParameters()

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

%% Position
stringAngle = 0.1 * pi;
stringOrigin = [2.5; 2];
stringLength = string.l;
string = setStringPosition(string, stringLength, stringAngle, stringOrigin);


string.pickup = 1/pi;
string.excitePosition = 1/sqrt(2);
