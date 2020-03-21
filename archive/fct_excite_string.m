function [excite, T12] = fct_excite_string(ftm, room, s, pos)


% spatial exciation
x0 = pos(1,1);
x1 = pos(2,1);
y0 = pos(1,2);
y1 = pos(2,2);


% length == string length
l = norm([x0;y0] - [x1;y1]);

% normal vector components
nx = 1/l*(y1 - y0);
ny = 1/l*(x0 - x1);



% Inefficient with 2 for loops, just for testing
% mu: indexing room modes 
% nu: indexing string modes ~= to nu in string model
T12 = zeros(ftm.Mu, s.ftm.Mu); 
gamma = 1e3;


fun = @(xi, lx, ly, gnu) ...
         (nx*lx*sin(lx*(x0 + xi*(x1 -x0))).*cos(ly*(y0 + xi*(y1 - y0))) ...
        + ny*ly*cos(lx*(x0 + xi*(x1 -x0))).*sin(ly*(y0 + xi*(y1 - y0)))...
        ).*sin(gnu*xi);

for mu = 1:ftm.Mu
   vec = zeros(1, s.ftm.Mu);  
   lx = ftm.lambdaX(mu);
   ly = ftm.lambdaY(mu);
   
   for nu = 1:s.ftm.Mu 
        gnu = s.ftm.gm(nu); 
        snu = s.ftm.smu(nu); 
        
        foo = integral(@(xi) fun(xi,lx,ly, gnu),0, 1);
        vec(nu) = gamma*l*(-4/(room.rho*conj(ftm.smu(mu))))*...
            snu/gnu*1/s.ftm.nmu(nu)*foo;
        
   end
   T12(mu,:) = vec; 
end

excite = T12*s.ybar;

end