function [primKern, primKern1, adjKern, K1, K2, K3] = fct_eigenfunctions_room(ftm, room, pickup)

primKern_ = @(x,y,lx,ly,smu)[4*cos(lx.*x).*cos(ly.*y)
    4*lx./(smu*room.rho).*sin(lx.*x).*cos(lx.*y)
    4*ly./(smu*room.rho).*cos(lx.*x).*sin(ly.*y)];
primKern = @(x,y,mu) primKern_(x,y,ftm.lambdaX(mu).', ftm.lambdaY(mu).', ftm.smu(mu).');

primKern1_ = @(x,y,lx,ly,smu) 4*cos(lx.*x).*cos(ly.*y);
primKern1 = @(x,y,mu) primKern1_(x,y,ftm.lambdaX(mu).', ftm.lambdaY(mu).', ftm.smu(mu).');


adjKern_ = @(x,y,lx,ly,smu) [-4*lx./(smu.*room.rho).*sin(lx.*x).*cos(ly.*y)
        -4*ly./(smu.*room.rho).*cos(lx.*x).*sin(ly.*y)
        4*cos(lx.*x).*cos(ly.*y)];
adjKern = @(x,y,mu) adjKern_(x,y,ftm.lambdaX(mu).', ftm.lambdaY(mu).', ftm.smu(mu).');    



% fimrst three components of adjKern
KX = @(x,y,lx,ly,smu) -4.*lx./(smu.*room.rho).*sin(lx.*x).*cos(ly.*y);
K1 = @(x,y,mu) KX(x,y,ftm.lambdaX(mu), ftm.lambdaY(mu), ftm.smu(mu));

KY = @(x,y,lx,ly,smu) -4.*ly./(smu.*room.rho).*cos(lx.*x).*sin(ly.*y);
K2 = @(x,y,mu) KY(x,y,ftm.lambdaX(mu), ftm.lambdaY(mu), ftm.smu(mu));

KZ = @(x,y,lx,ly) 4.*cos(lx.*x).*cos(ly.*y);
K3 = @(x,y,mu) KZ(x,y,ftm.lambdaX(mu), ftm.lambdaY(mu));
