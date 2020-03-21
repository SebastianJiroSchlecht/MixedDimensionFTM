function [excite, T12, deflection] = fct_excite_cont(ftm, room, excite_pos, t)


% temporal excitation
scaling = 10;
a = -1;
lam = 2*pi*100;
ft = scaling*exp(a*t).*sin(lam*t);

% spatial exciation
x0 = excite_pos(1,1);
x1 = excite_pos(1,2);
y0 = excite_pos(2,1);
y1 = excite_pos(2,2);

l = norm([x0;y0] - [x1;y1]);

lamb = 1*pi;

% Normal vector 
nx = 1/l*(y1 - y0);
ny = 1/l*(x0 - x1);

% String deflection
XI = linspace(0,1,100);
deflection = sin(lamb * XI.') .* ft;

fun = @(xi,lx, ly) (nx*lx*sin(lx*(x0 + xi*(x1 -x0))).*cos(ly*(y0 + xi*(y1 - y0))) ...
        + ny*ly*cos(lx*(x0 + xi*(x1 -x0))).*sin(ly*(y0 + xi*(y1 - y0)))...
        ).*sin(lamb*xi);

T12 = zeros(ftm.Mu,1);    
for mu = 1:ftm.Mu
    lx = ftm.lambdaX(mu);
    ly = ftm.lambdaY(mu);
    
    foo = integral(@(xi) fun(xi,lx,ly),0, 1);
    
    T12(mu,:) = foo*l*(-4/(room.rho*conj(ftm.smu(mu))));
end

excite = T12 * ft;

