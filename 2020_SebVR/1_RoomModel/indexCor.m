function ind = indexCor(k, len)

if (k <= 0)
    ind = len - abs(k);
else
    ind = k; 
end