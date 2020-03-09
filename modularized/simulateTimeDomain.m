function [ybar,w] = simulateTimeDomain(duration,Az,Cw,excite,T)

Mu = size(Az,1);

ybar = zeros(Mu,duration + size(excite,2) - 1);
for mu = 1:Mu
    ir = impz(1,[1, -Az(mu,mu)],duration);
    ybar(mu,:) = conv(ir,T*excite(mu,:));
end
w = Cw * ybar;
w = real(w);

% ybar(:,1) = T*excite(:,1);
% w(1) = state.Cw*ybar(:,1);
% for n = 2:length(time.k)
%     % state equation - Use state.A or state.Ac
%     ybar(:,n) = state.Az*ybar(:,n-1) + T*excite(:,n);
%     
%     % output equation
%     w(n) = state.Cw*ybar(:,n);
% end