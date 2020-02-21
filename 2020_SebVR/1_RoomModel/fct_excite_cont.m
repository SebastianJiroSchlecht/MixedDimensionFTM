function [excite] = fct_excite_cont(ftm, room, t)

excite = zeros(ftm.Mu,length(t));

% temporal excitation
scaling = 0.01;
a = -1;
lam = 2*pi*100;
ft = scaling*exp(a*t).*sin(lam*t);

% spatial exciation
x0 = 1.3;
x1 = 3.7;
y1 = 3;
y0 = 1;

l = norm([x0;y0] - [x1;y1]);

lamb = 3*pi;

% Sebastian: I corrected to y1 - y0 in the second cos
fun = @(xi,lx, ly) cos(lx*(x0 + xi*(x1 -x0))).*...
    cos(ly*(y0 + xi*(y1 - y0))).*sin(lamb*xi);



for mu = 1:ftm.Mu
    lx = ftm.lambdaX(mu);
    ly = ftm.lambdaY(mu);
    
    foo = integral(@(xi) fun(xi,lx,ly),0, 1);
    
    excite(mu,:) = foo*l*ft;
end
end
