function T = connectModels(x, y, Ks, nums, K1, K2, MuS, MuR)

T = zeros(MuR,MuS);

gamma = 1e3; % TODO: to be defined

stringPosition = [x(1) - x(0), y(1) - y(0)];
l = norm(stringPosition);
n = null(stringPosition);

for muS = 1:MuS
    for muR = 1:MuR
        
        foo1 = integral(@(xi) Ks(xi,muS).*K1(x(xi),y(xi),muR)', 0, 1);
        foo2 = integral(@(xi) Ks(xi,muS).*K2(x(xi),y(xi),muR)', 0, 1);
        
        T(muR,muS) = gamma * l ./nums(muS) * (n(1)*foo1 + n(2)*foo2);

    end
end

