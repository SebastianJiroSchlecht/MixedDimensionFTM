function T = connectModels()

% String deflection
XI = linspace(0,1,100);
deflection = sin(lamb * XI.') .* ft;

fun = @(xi,lx, ly) (nx*lx*sin(lx*(x0 + xi*(x1 -x0))).*cos(ly*(y0 + xi*(y1 - y0))) ...
        + ny*ly*cos(lx*(x0 + xi*(x1 -x0))).*sin(ly*(y0 + xi*(y1 - y0)))...
        ).*sin(lamb*xi);

for mu = 1:ftm.Mu
    lx = ftm.lambdaX(mu);
    ly = ftm.lambdaY(mu);
    
    foo = integral(@(xi) fun(xi,lx,ly),0, 1);
    
    excite(mu,:) = foo*l*ft*(-4/(room.rho*conj(ftm.smu(mu))));
end
end
