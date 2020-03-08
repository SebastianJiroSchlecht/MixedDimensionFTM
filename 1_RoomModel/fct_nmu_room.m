function nmu = fct_nmu_room(ftm, room) 

nmu = zeros(1,ftm.Mu); 


for mu = 1:ftm.Mu 
   smu = ftm.smu(mu); 
   lx = ftm.lambdaX(mu);
   ly = ftm.lambdaY(mu);
   
   i1 = -8*lx^2/(room.rho*smu^2)*room.Lx*room.Ly;
   i2 = -8*ly^2/(room.rho*smu^2)*room.Lx*room.Ly;
   i3 = 8/(room.rho*room.c0^2)*room.Lx*room.Ly;
   
   nmu(mu) = inv(i1+i2+i3);
end
end