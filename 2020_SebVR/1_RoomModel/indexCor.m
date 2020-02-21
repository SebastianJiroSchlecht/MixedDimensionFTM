function ind = indexCor(k, len)

% vectorized
ind = k;

wrapInd = k <= 0;
ind(wrapInd) = len - abs(k(wrapInd));

% non-vectorized
% if (k <= 0)
%     ind = len - abs(k);
% else
%     ind = k; 
% end