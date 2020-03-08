function [excite] = fct_excite(ftm, t, exc)

% First create temporal exciation
Tf = 1e-3; % Width of the temporal exciation
w0 = 2*pi/Tf;
fet = zeros(1,length(t));
for k = 1:length(t)
    tf = t(k);
    if(tf <= Tf)
        fet(k) = 0.5*(1 - cos(w0*tf));
    else
        fet(k) = 0;
    end
end

% Create spatial exciation
x0 = 0.3;
y0 = 0.3;
k0x = 2*pi/x0;
k0y = 2*pi/y0;
init = zeros(1,ftm.Mu); 
funx = @(x,k0x,xe,lx) cos(lx*x).*0.5.*(1 + ...
    cos(k0x*(x - xe)));
funy = @(y,k0,ye,ly) cos(ly*y).*0.5.*(1 + ...
    cos(k0y*(y - ye)));

for mu = 1:ftm.Mu 
    lx = ftm.lambdaX(mu);
    ly = ftm.lambdaY(mu);
    
    
    %init(mu) = cos(lx*excite.x)*cos(ly*excite.y);
    initx = integral(@(x) funx(x,k0x,exc.x,lx),exc.x-x0/2, exc.x+x0/2);
    inity = integral(@(y) funy(y,k0y,exc.y,ly),exc.y-y0/2, exc.y+y0/2);
    
    init(mu) = initx*inity;
    
end

% construct 
excite = init.'.*fet;
