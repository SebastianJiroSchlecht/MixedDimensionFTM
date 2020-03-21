function xz = zeropad(x,len, dim)
% Sebastian J. Schlecht, Sunday, 15 March 2020

clen = min(len, size(x,dim));
switch dim
    case 1
        xz = zeros(len,size(x,2));
        xz(1:clen,:) = x(1:clen,:);
    case 2
        xz = zeros(size(x,1),len);
        xz(:,1:clen) = x(:,1:clen);
end


