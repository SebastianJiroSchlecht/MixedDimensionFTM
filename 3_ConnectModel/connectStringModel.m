function T = connectStringModel(x, y, Ks, nums, K1, K2, MuS, MuR)

gamma = 1e3; 

stringPosition = [x(1) - x(0), y(1) - y(0)];
l = norm(stringPosition);
n = null(stringPosition);

muS = 1:MuS;
muR = 1:MuR;

T1 = integral(@(xi) Ks(xi,muS).*conj(K1(x(xi),y(xi),muR)), 0, 1, 'ArrayValued',true).';
T2 = integral(@(xi) Ks(xi,muS).*conj(K2(x(xi),y(xi),muR)), 0, 1, 'ArrayValued',true).';

T = gamma .* l ./nums(muS) .* (n(1)*T1 + n(2)*T2);


