function [primKern, adjKern, K1, K2] = fct_eigenfunctions_room(ftm, room, pickup) 

primKern = zeros(3,ftm.Mu);
adjKern = zeros(3,ftm.Mu);

x = pickup.x; 
y = pickup.y;

for mu = 1:ftm.Mu

   smu = ftm.smu(mu); 
   lx = ftm.lambdaX(mu);
   ly = ftm.lambdaY(mu);
    
   primKern(:,mu) = [4*cos(lx*x)*cos(ly*y)
                     4*lx/(smu*room.rho)*sin(lx*x)*cos(lx*y)
                     4*ly/(smu*room.rho)*cos(lx*x)*sin(ly*y)];
                 
   adjKern(:,mu) = [-4*lx/(smu*room.rho)*sin(lx*x)*cos(ly*y)
                    -4*ly/(smu*room.rho)*cos(lx*x)*sin(ly*y)
                    4*cos(lx*x)*cos(ly*y)]; 
end

% first two components of adjKern
KX = @(x,y,lx,ly,smu) -4.*lx./(smu.*room.rho).*sin(lx.*x).*cos(ly.*y);
K1 = @(x,y,mu) KX(x,y,ftm.lambdaX(mu), ftm.lambdaY(mu), ftm.smu(mu));

KY = @(x,y,lx,ly,smu) -4.*ly./(smu.*room.rho).*cos(lx.*x).*sin(ly.*y);
K2 = @(x,y,mu) KY(x,y,ftm.lambdaX(mu), ftm.lambdaY(mu), ftm.smu(mu));

