function [excite] = fct_excite_cont(ftm, room, t)

excite = zeros(ftm.Mu,length(t));

% temporal excitation
a = -1;
lam = 50*pi;
ft = exp(a*t).*sin(lam*t);

% spatial exciation
l = 0.4;
x0 = 0.3;%room.Lx/2 + l/2;
x1 = 0.7;%room.Lx/2 - l/2;
y1 = room.Ly/2;
y0 = room.Ly/2;

lamb = 2*pi;

fun = @(xi,lx, ly) cos(lx*(x0 + xi*(x1 -x0))).*...
    cos(ly*(y0 + xi*(x1 - x0))).*sin(lamb*xi);



for mu = 1:ftm.Mu
    lx = ftm.lambdaX(mu);
    ly = ftm.lambdaY(mu);
    
    foo = integral(@(xi) fun(xi,lx,ly),0, 1);
    
    excite(mu,:) = foo*l*ft;
end
end