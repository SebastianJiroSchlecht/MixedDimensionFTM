function T = connectPointModel(x, y, Ks, nums, K3, MuS, MuR)

gamma = 1e3;

pickup = 1/pi;
xi = 0.5;

muS = 1:MuS;
muR = 1:MuR;
          
T = gamma  .* K3(x(xi),y(xi),muR).' .* Ks(pickup,muS).' ./nums(muS);
T = T/ 1000;


