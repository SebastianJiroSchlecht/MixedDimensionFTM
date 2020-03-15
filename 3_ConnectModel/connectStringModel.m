function T = connectStringModel(x, y, Ks, nums, K1, K2, MuS, MuR)

gamma = 1e3; % TODO: to be defined

stringPosition = [x(1) - x(0), y(1) - y(0)];
l = norm(stringPosition);
n = null(stringPosition);

muS = 1:MuS;
muR = 1:MuR;

foo1 = integral(@(xi) Ks(xi,muS).*conj(K1(x(xi),y(xi),muR)), 0, 1, 'ArrayValued',true).';
foo2 = integral(@(xi) Ks(xi,muS).*conj(K2(x(xi),y(xi),muR)), 0, 1, 'ArrayValued',true).';

T = gamma .* l ./nums(muS) .* (n(1)*foo1 + n(2)*foo2);


