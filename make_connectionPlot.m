%% Include directories
close all;
% sourceType = 'stringOrth';

%% Simulation Basics
[Fs,T,dur,t,len] = simulationParameters(0.02);

%% Room model
[room,r.ftm] = roomParameters();
[r.ftm, r.state] = createRoomModel(r.ftm,room,T);

%% String Model
string = stringParameters();
[s.ftm, s.state] = createStringModel(string, T);
        

switch sourceType
    case 'string'
        string = stringParameters();
        [s.ftm, s.state] = createStringModel(string, T);
        T12 = connectStringModel(string.x, string.y, s.ftm.Ks, s.ftm.nmu, r.ftm.K1, r.ftm.K2, s.ftm.Mu, r.ftm.Mu);
    case 'stringOrth'
        string = stringParameters();
        stringAngle = 0.0 * pi;
        stringOrigin = [string.x(0); string.y(0)];
        stringLength = string.l;
        string = setStringPosition(string, stringLength, stringAngle, stringOrigin);

        [s.ftm, s.state] = createStringModel(string, T);
        T12 = connectStringModel(string.x, string.y, s.ftm.Ks, s.ftm.nmu, r.ftm.K1, r.ftm.K2, s.ftm.Mu, r.ftm.Mu);    
    case 'point'
        string = stringParameters();
        [s.ftm, s.state] = createStringModel(string, T);
        T12 = connectPointModel(string.x, string.y, s.ftm.Ks, s.ftm.nmu, r.ftm.K3, s.ftm.Mu, r.ftm.Mu);
end

%% Analyze Transfer Function
shouldSave = true;
plotTransferFunction(T12,s,r,string,shouldSave,sourceType)