function excite = getExcitationFunction3(model, len, fe, delta,a1,a2,xe)

% Here simplified. Excitation is only at x = xe at in space and k = 0 in time
% So a single impuls at the start of the simulation. 
% So fe is the amplitude of the impulse

num = length(model.smu);

excite = zeros(num,len);
Fe = zeros(4,len);
Fe(4,:) = fe;

for n = 1:num
  %  excite(n,:) = adjKern.kxe(:,n)'*Fe;
    gamma = model.gm(n);
    alpha = pi/delta;
    beta = (pi/delta)*(xe - delta);
    
    m1 = gamma - alpha;
    m2 = gamma + alpha;
    
    excite(n,:) = 2*fe*a1*sin(gamma*xe)*sin(gamma*delta) - ...
        a2*gamma*fe*cos(beta)*((1/m1)*sin(m1*xe)*sin(m1*delta) + ...
        (1/m2)*sin(m2*xe)*sin(m2*delta)) - ...
        a2*gamma*fe*sin(beta)*0.5*(1/m1)*(sin(m1*xe + m1*delta) - ...
        sin(m1*xe - m1*delta)) + ...
        a2*gamma*fe*sin(beta)*0.5*(1/m2)*(sin(m2*xe + m2*delta) - ...
        sin(m2*xe - m2*delta));
end
end