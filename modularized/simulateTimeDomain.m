function [ybar,w] = simulateTimeDomain(duration,Az,Cw,excite,T)

Mu = size(Az,1);

ybar = zeros(Mu,duration + size(excite,2) - 1);
for mu = 1:Mu
    ir = impz(1,[1, -Az(mu,mu)],duration);
    ybar(mu,:) = conv(ir,T*excite(mu,:));
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