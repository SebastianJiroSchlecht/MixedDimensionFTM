function [smu, lambdaX, lambdaY] = fct_eigenvalues_room(ftm, index, room)

lambdaX = zeros(1,ftm.Mux); 
lambdaY = zeros(1,ftm.Muy);
smu = zeros(1,ftm.Mu);

for mu = 1:ftm.Mu
    mux = index(mu,1); 
    muy = index(mu,2); 
    
    lambdaX(mu) = ftm.mux(mux)*pi/room.Lx;
    lambdaY(mu) = ftm.muy(muy)*pi/room.Ly;
    
    smu(mu) = 1j*room.c0*sqrt(lambdaX(mu)^2 + lambdaY(mu)^2);
end
end