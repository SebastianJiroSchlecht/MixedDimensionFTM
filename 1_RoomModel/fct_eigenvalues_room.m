function [smu, lambdaX, lambdaY, Mu] = fct_eigenvalues_room(ftm, room)
% First only positive eigenvalues are calculated (see (8))
% The complex conjugated are added at the end

index = fct_index(ftm);

lambdaX = zeros(1,ftm.Mux);
lambdaY = zeros(1,ftm.Muy);
Mu = ftm.Mux*ftm.Muy;
smu = zeros(1,Mu);

mu = 1:Mu;
mux = index(mu,1);
muy = index(mu,2);

lambdaX(mu) = mux.*pi./room.Lx;
lambdaY(mu) = muy.*pi./room.Ly;

smu(mu) = 1j*room.c0*sqrt(lambdaX(mu).^2 + lambdaY(mu).^2);

% Add complex conjugated
smu = [smu (conj(smu))];
lambdaX = [lambdaX lambdaX];
lambdaY = [lambdaY lambdaY];

Mu = length(smu);
