function [excite] = fct_excite_cont(ftm, room, t)

excite = zeros(ftm.Mu,length(t));

% temporal excitation
scaling = 0.01;
a = -1;
lam = 2*pi*100;
ft = scaling*exp(a*t).*sin(lam*t);

% spatial exciation
x0 = 4;
x1 = 2;
y1 = 3;
y0 = 3;

l = norm([x0;y0] - [x1;y1]);

lamb = 3*pi;

% Normal vector 
nx = 1/l*(y1 - y0);
ny = 1/l*(x0 - x1);

% Sebastian: I corrected to y1 - y0 in the second cos
% fun = @(xi,lx, ly) cos(lx*(x0 + xi*(x1 -x0))).*...
%     cos(ly*(y0 + xi*(y1 - y0))).*sin(lamb*xi);

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