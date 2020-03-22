% Sebastian J. Schlecht, Friday, 20 March 2020
close all;
% sourceType = 'string';
% position = 1;

%% Simulation Basics
[Fs,T,dur,t,len] = simulationParameters(10);

%% Room model
[room,r.ftm] = roomParameters();

%% String Model
string = stringParameters();
    

switch position
    case 1
        room.pickup.x = 1;
        room.pickup.y = 1;
        stringAngle = 0.1 * pi;
    case 2
        room.pickup.x = 1;
        room.pickup.y = 1;
        stringAngle = 0.3 * pi;        
    case 3
        room.pickup.x = 1;
        room.pickup.y = 1;
        stringAngle = 0.5 * pi;   
    case 4
        room.pickup.x = 1;
        room.pickup.y = 1;
        stringAngle = 0.7 * pi;   
    case 5
        room.pickup.x = 1;
        room.pickup.y = 1;
        stringAngle = 0.9 * pi;   
    case 6
        room.pickup.x = 1;
        room.pickup.y = 1;
        stringAngle = 1.1 * pi;   
    case 7 
        room.pickup.x = 1;
        room.pickup.y = 1;
        stringAngle = 1.3 * pi;   
    case 8
        room.pickup.x = 1;
        room.pickup.y = 1;
        stringAngle = 1.5 * pi;   
    case 9
        room.pickup.x = 1;
        room.pickup.y = 1;
        stringAngle = 1.7 * pi;   
    case 10
        room.pickup.x = 1;
        room.pickup.y = 1;
        stringAngle = 1.9 * pi;   
    case 11
        room.pickup.x = 1;
        room.pickup.y = 2;
        stringAngle = 0 * pi;  
    case 12
        room.pickup.x = 1;
        room.pickup.y = 3;
        stringAngle = 0 * pi;  
    case 13
        room.pickup.x = 1;
        room.pickup.y = 4;
        stringAngle = 0 * pi;  
    case 14
        room.pickup.x = 2;
        room.pickup.y = 1;
        stringAngle = 0 * pi;   
    case 15
        room.pickup.x = 2;
        room.pickup.y = 2;
        stringAngle = 0 * pi;    
    case 16
        room.pickup.x = 2;
        room.pickup.y = 3;
        stringAngle = 0 * pi;  
    case 17
        room.pickup.x = 2;
        room.pickup.y = 4;
        stringAngle = 0 * pi;  
    otherwise
        error('Not defined');
end

string = setStringPosition(string, string.l, stringAngle, string.origin);
[s.ftm, s.state] = createStringModel(string, T);
[r.ftm, r.state] = createRoomModel(r.ftm,room,T);

switch sourceType
    case 'string'
        T12 = connectStringModel(string.x, string.y, s.ftm.Ks, s.ftm.nmu, r.ftm.K1, r.ftm.K2, s.ftm.Mu, r.ftm.Mu);
    case 'point'
        T12 = connectPointModel(string.x, string.y, s.ftm.Ks, s.ftm.nmu, r.ftm.K3, s.ftm.Mu, r.ftm.Mu);
end

%% Plot Room
figure(1); hold on; grid on;
rectangle('Position',[0,0,room.Lx,room.Ly]);
plot(string.x(0:1) ,string.y(0:1),'r');
plot(room.pickup.x,room.pickup.y,'xb')
xlabel('Space x [m]')
ylabel('Space y [m]')
xlim([-1 room.Lx+1])
ylim([-1 room.Ly+1])
axis equal

matlab2tikz_sjs(['./plot/soundPlot_' sourceType '_' num2str(position) '.tikz']);


%% SIMULATION - Time domain
%% String - Create exciation functions
[excite_imp, excite_ham] = createExcitations(s.ftm, string, len, t, string.excitePosition);
[s.ybar,s.y] = simulateTimeDomain(s.state.Az,s.state.C,excite_ham,T);

%% Room - Simulation time domain
[r.ybar,r.y] = simulateTimeDomainPerMode(r.state.Az,r.state.C,T12,s.ybar,T);

%% Sound
% soundsc(r.y,Fs);
% soundsc(s.y(1,:),Fs);

%% Save
audiowrite(['./data/' sourceType 'InRoom_' num2str(position) '.wav'],rescale(r.y,-.9,.9),Fs);
audiowrite(['./data/' 'stringOnly.wav'],rescale(s.y(1,:),-.9,.9),Fs);


