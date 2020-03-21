function [ybar,w] = simulateTimeDomain(Az,Cw,excite,T)

Mu = size(Az,1);

ybar = zeros(Mu,size(excite,2));
for mu = 1:Mu
    ybar(mu,:) = filter(1,[1, -Az(mu,mu)],T*excite(mu,:));
end
w = Cw * ybar;
w = real(w);

% excite_ = [excite zeros(Mu,duration)];
% ybar(:,1) = T*excite(:,1);
% w(1) = Cw*ybar(:,1);
% for n = 2:duration
%     % state equation - Use state.A or state.Ac
%     ybar(:,n) = Az*ybar(:,n-1) + T*excite_(:,n);
%     
%     % output equation
%     w(n) = Cw*ybar(:,n);
% end