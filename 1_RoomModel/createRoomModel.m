function [ftm, state] = createRoomModel(ftm,room,T)

%% Eigenvalues and indexing
[ftm.smu, ftm.lambdaX, ftm.lambdaY, ftm.Mu] = fct_eigenvalues_room(ftm, room);
%% Scaling factor
ftm.nmu = fct_nmu_room(ftm, room);
%% Eigenfunctions at observation point pickup = [x y]
[ftm.primKern, ftm.primKern1, ftm.adjKern, ftm.K1, ftm.K2, ftm.K3] = fct_eigenfunctions_room(ftm, room, room.pickup);

%% State space model
damping = 1;
ftm.dsmu = ftm.smu - damping; 
state.As = diag(ftm.dsmu);
state.Az = diag(exp(ftm.dsmu*T)); 
state.C = ( ftm.primKern1(room.pickup.x, room.pickup.y, 1:ftm.Mu)./ftm.nmu ).';