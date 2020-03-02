function [primKern, adjKern] = fct_eigenfunctions_room(ftm, room, pickup) 

primKern = zeros(3,ftm.Mu);
adjKern = zeros(3,ftm.Mu);

x = pickup.x; 
y = pickup.y;

for mu = 1:ftm.Mu
%    mux = ftm.index(mu,1); 
%    muy = ftm.index(mu,2); 
   
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
end