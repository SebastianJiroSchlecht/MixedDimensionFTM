function [excite_imp, excite_ham] = createExcitations(ftm, string, len, t, x)

%% Exciations
f = -0.05/(string.E*string.I);
fe = zeros(1,len);
fe(1) = f;

excite_imp = zeros(ftm.Mu,len);

xe = string.l * x;

mu = 1:ftm.Mu; 
gm = ftm.gm(mu);
excite_imp(mu,:) = gm .* sin(gm*xe)*fe;


%% 1+cos*hamming 
Tf = 0.07e-3;
delta = 0.0134;
fe = createExcitationFunction(t,Tf);
fe = fe.*-1/(string.E*string.I);
% a1 = 0.54;
% a2 = 0.46;
a1 = 0.5;
a2 = 0.5;

excite_ham = getExcitationFunction3(ftm, len, fe, delta,a1,a2,xe);


end