function [kprim, kadj, Ks] = fct_eigenfunctions_string(string, ftm,x)

kprim = zeros(4,ftm.Mu);
kadj = zeros(4,ftm.Mu); 

for mu = 1:ftm.Mu
    smu = ftm.smu(mu);
    gm = ftm.gm(mu);
    
    kprim(:,mu) = [smu/gm*sin(gm*x)
                   -gm*sin(gm*x) 
                   cos(gm*x)
                   -gm^2*cos(gm*x)];
end

% First component of kprim
K = @(xi,gm,smu) smu/gm*sin(gm*xi);
Ks = @(xi,mu) K(xi,ftm.gm(mu),ftm.smu(mu));


