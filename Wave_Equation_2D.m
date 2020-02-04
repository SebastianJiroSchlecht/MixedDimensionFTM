clc; clear all; close all;

%2D WAVE EQUATION utt = c^2(uxx+uyy) 
%with initial condition  u(x,y,0) = sin(p*pi*x)*sin(q*pi*y), 0<x<1 0<y<1
% and boundary conditions u(0,y,t) = u(1,y,t)= u(x,0,t)= u(x,1,t) = 0 t>0


c = 1;  
dx = 0.005;
dy = dx;
sigma = 1/sqrt(2); gamma = 1/sqrt(2); %Courant-Friedrich Stability Condition
dt = sigma*(dx/c);
t = 0:dt:0.5; x = 0:dx:1; y = 0:dy:1; 
u = zeros(length(x),length(y),length(t));
p = 2; q = 1;

% u(:,:,1) = transpose(sin(p.*pi.*x))*sin(q.*pi.*y); %u(x,y,0) = sin(p*pi*x)*sin(q*pi*y)
source = sin(t*50)*0.1;
modeSize = 40;
modeShape = sin( linspace(0,1,modeSize) * pi * 5);
sx = 100;
sy = 80 + (1:modeSize);


%u(x,y,dt)
u(sx,sy,1)= u(sx,sy,1) + source(1) .* modeShape; 
for i=2:length(x)-1 
    for j=2:length(y)-1
     u(i,j,2)= (sigma^2)*(u(i+1,j,1)-2*u(i,j,1)+u(i-1,j,1))...
         +(gamma^2)*(u(i,j+1,1)-2*u(i,j,1)+u(i,j-1,1))+2*u(i,j,1) - u(i,j,1); 
    end
end

for n=2:length(t)-1
    u(sx,sy,n)= u(sx,sy,n) + source(n) .* modeShape;
       
    for i=2:length(x)-1
        for j=2:length(y)-1
            u(i,j,n+1)= (sigma^2)*(u(i+1,j,n)-2*u(i,j,n)+u(i-1,j,n))...
                +(gamma^2)*(u(i,j+1,n)-2*u(i,j,n)+u(i,j-1,n)) + 2*u(i,j,n) - u(i,j,n-1);
        end
    end

end


%Analytic solution
SOL = zeros(length(x),length(y),length(t)); 
S = transpose(sin(p.*pi.*x))*sin(q.*pi.*y);

for i=1:length(t)
    SOL(:,:,i) = S*cos(c.*pi.*(sqrt(p^2+q^2).*t(i)));
end

%Absolute error
E = abs(SOL-u);

[X,Y] = meshgrid(x,y);
max_e = max(max(max(E)));

for j=1:length(t)
%        subplot(2,1,1)
       colormap(cool);
       p1 = surf(X,Y,u(:,:,j)); 
       title(sprintf('2D wave equation at t = %1.2f, con sigma = %1.2f y gamma = %1.2f',t(j),sigma, gamma),'Fontsize',11);
       xlabel('x','Fontsize',11); ylabel('y','Fontsize',11);
       zlabel(sprintf('u(x,y,t = %1.2f)',t(j)),'Fontsize',11);
       axis ([0 1 0 1 -1 1]);
       
%        subplot(2,1,2)
%        p2 = surf(X,Y,E(:,:,j)); 
%        title(sprintf('Absolute error at t = %1.2f',t(j)),'Fontsize',11);
%        xlabel('x','Fontsize',11); ylabel('y','Fontsize',11);
%        zlabel(sprintf('E(x,y,t = %1.2f)',t(j)),'Fontsize',11);
%        axis ([0 1 0 1 0 max_e]);
       pause(0.001);
       hold on; 
       
       if(j~=length(t))
       delete(p1);
%        delete(p2);
       end
end
