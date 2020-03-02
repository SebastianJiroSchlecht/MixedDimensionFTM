function nmu = fct_nmu(ftm,string)

nmu = zeros(1,ftm.Mu);

for mu = 1:ftm.Mu
%       Setting Full String
    nmu(mu) = -(string.l/2)*((2*string.p*string.A*ftm.smu(mu) ... 
        + string.d1 + ftm.gm(mu)^2*string.d3)/(string.E*string.I));

%       Setting Wave Equation
%         nmu(mu) = -(string.l/2);
%       Setting Wave Equation -- Dispersion
%           nmu(mu) = -(string.l/2)*((2*string.p*string.A*ftm.smu(mu))/(string.E*string.I));

%     nmu(mu) = -(string.l/2)*((2*string.p*string.A*ftm.smu(mu) ... 
%         + string.d1 + ftm.gm(mu)^2*string.d3));
end
end