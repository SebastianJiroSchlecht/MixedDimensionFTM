%% Make room animation
close all;
% sourceType = 'string';

%% Simulation Basics
[Fs,T,dur,t,len] = simulationParameters(0.01);

%% Room model
[room,r.ftm] = roomParameters();
[r.ftm, r.state] = createRoomModel(r.ftm,room,T);

%% String Model
string = stringParameters();
[s.ftm, s.state] = createStringModel(string, T);
        
switch sourceType
    case 'string'
        T12 = connectStringModel(string.x, string.y, s.ftm.Ks, s.ftm.nmu, r.ftm.K1, r.ftm.K2, s.ftm.Mu, r.ftm.Mu);
    case 'point'
        T12 = connectPointModel(string.x, string.y, s.ftm.Ks, s.ftm.nmu, r.ftm.K3, s.ftm.Mu, r.ftm.Mu);
end

%% Analyze Transfer Function
% plotTransferFunction(T12,s,r,string,false)



%% SIMULATION - Time domain
%% String - Create exciation functions
[excite_imp, excite_ham] = createExcitations(s.ftm, string, len, t, string.excitePosition);
[s.ybar,s.y] = simulateTimeDomain(s.state.Az,s.state.C,excite_ham,T);
excite = T12*s.ybar;

%% Room - Simulation time domain
[r.ybar,r.y] = simulateTimeDomain(r.state.Az,r.state.C,excite,T);

%% Sound
% soundsc(r.y,Fs);

%% Spatial simulation
% String
xi = linspace(0,string.l,50);
stringC = s.state.Cs(xi, 1:s.ftm.Mu).';

% Room
x = linspace(0,room.Lx,200);
y = linspace(0,room.Ly,200);
roomC = r.ftm.primKern1(x, permute(y,[1 3 2]), 1:r.ftm.Mu) ./r.ftm.nmu ;
roomC = permute(roomC, [2,3,1]);


%% Plot Parameters
downsample = 1;
wantToRecord = true;
v = [];

switch sourceType
    case 'string'
        videoName = 'animateStringInRoom';
        animate = @animateStringInRoom;
    case 'point'
        videoName = 'animatePointStringInRoom';
        animate = @animatePointStringInRoom;
end

%% Plot 
figure(742); hold on; set(gcf,'position',[808   546   796   391],'color','w');
timeIndex = 350;        
animate(x, y, roomC, r.ybar(:,timeIndex), string, stringC, s.ybar(:,timeIndex), downsample, false, v)
matlab2tikz_sjs(['./plot/wavePlot_' sourceType '.tikz']);

%% Animation
figure(741); hold on; set(gcf,'position',[808   546   796   391],'color','w');
recordVideo(wantToRecord, videoName, @(w,v) animate(x, y, roomC, r.ybar, string, stringC, s.ybar, downsample, w, v) )






