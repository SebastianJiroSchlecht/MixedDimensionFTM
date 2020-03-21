function [ybar,w] = simulateTimeDomainPerMode(Az,Cw,T12, excite,T)
% % Low Memory version of simulateTimeDomain
%
% Sebastian J. Schlecht, Friday, 20 March 2020


ybar = 0;

Mu = size(Az,1);

w = zeros(1,size(excite,2));
for mu = 1:Mu
    w = w + Cw(:,mu) * filter(1,[1, -Az(mu,mu)],T*T12(mu,:) * excite);
end
w = real(w);