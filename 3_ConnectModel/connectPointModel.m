function T = connectPointModel(x, y, Ks, nums, K3, MuS, MuR)

% T = zeros(MuR,MuS);

gamma = 1e3; % TODO: to be defined

pickup = 1/pi;
xi = 0.5;


muS = 1:MuS;
muR = 1:MuR;
        
%         foo1 = integral(@(xi) Ks(xi,muS).*K1(x(xi),y(xi),muR), 0, 1);
%         foo2 = integral(@(xi) Ks(xi,muS).*K2(x(xi),y(xi),muR), 0, 1);
    
       T = gamma  .* K3(x(xi),y(xi),muR).' .* Ks(pickup,muS).' ./nums(muS);
        
%         T( muR,muS) = gamma * l ./nums(muS) * (n(1)*foo1 + n(2)*foo2);


