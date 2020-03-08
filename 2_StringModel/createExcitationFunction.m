function fe = createExcitationFunction(t,Tf)
    w0 = 2*pi/Tf;
    fe = zeros(1,length(t));
    for k = 1:length(t)
        tf = t(k);
        if(tf <= Tf)
            fe(k) = 0.5*(1 - cos(w0*tf));
        else
            fe(k) = 0;
        end
    end
end