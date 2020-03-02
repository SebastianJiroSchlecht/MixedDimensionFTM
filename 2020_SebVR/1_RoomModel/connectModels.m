function T = connectModels(x, y, Ks, nums, K1, K2, MuS, MuR)

T = zeros(MuR,MuS);

for muS = 1:MuS
    for muR = 1:MuR
        
        foo1 = integral(@(xi) Ks(xi,muS)./nums(muS).*K1(x(xi),y(xi),muR), 0, 1);
        foo2 = integral(@(xi) Ks(xi,muS)./nums(muS).*K2(x(xi),y(xi),muR), 0, 1);
        
        T(muR,muS) = foo1 + foo2;
    end
end

