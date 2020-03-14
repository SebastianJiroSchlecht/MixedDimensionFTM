function string = stringParameters()

%% String parameters
stringH.E = 5.4e9;
stringH.p = 1140;       %in kg/m^3
stringH.l = 1;
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
[sx,sy] = pol2cart(stringAngle, string.l);

stringOrigin = [3; 4];

excite_pos = stringOrigin + [0 sx; 0 sy];

% excite_pos = [4 2; 3 4];
string.x = @(xi) excite_pos(1,1) + xi*( excite_pos(1,2) - excite_pos(1,1));
string.y = @(xi) excite_pos(2,1) + xi*( excite_pos(2,2) - excite_pos(2,1));

string.mid.x = string.x(0.5);
string.mid.y = string.y(0.5);
% string.l = norm([string.x(0) - string.x(1); string.y(0) - string.y(1)]);

string.pickup = 1/pi;
string.excitePosition = 1/sqrt(2);
