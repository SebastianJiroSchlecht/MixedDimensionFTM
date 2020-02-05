clc; clear all; close all;
%Sebastian J. Schlecht, Wednesday, 5. February 2020
%2D WAVE EQUATION utt = c^2(uxx+uyy) 
%with line source
%and boundary conditions u(0,y,t) = u(1,y,t)= u(x,0,t)= u(x,1,t) = 0 t>0

%% Meta Init
wantToRecord = false;

%% Plate init
c = 1;  
dx = 0.005;
dy = dx;
sigma = 1/sqrt(2); gamma = 1/sqrt(2); %Courant-Friedrich Stability Condition
dt = sigma*(dx/c);
t = 0:dt:1.5; x = 0:dx:1; y = 0:dy:1; 
u = zeros(length(x),length(y),length(t));
p = 2; q = 1;

%% String Source
modeNumber = 2;
source = sin(t*50)*0.1;
modeSize = 40;
modeShape = sin( linspace(0,1,modeSize) * pi * modeNumber);
sx = 100;
sy = 80 + (1:modeSize);

%% FDTD time steps
%u(x,y,dt)
u(sx,sy,1)= u(sx,sy,1) + source(1) .* modeShape; 
u(sx-1,sy,1)= u(sx-1,sy,1) - source(1) .* modeShape; 
for i=2:length(x)-1 
    for j=2:length(y)-1
     u(i,j,2)= (sigma^2)*(u(i+1,j,1)-2*u(i,j,1)+u(i-1,j,1))...
         +(gamma^2)*(u(i,j+1,1)-2*u(i,j,1)+u(i,j-1,1))+2*u(i,j,1) - u(i,j,1); 
    end
end

for n=2:length(t)-1
    u(sx,sy,n)= u(sx,sy,n) + source(n) .* modeShape;
    u(sx-1,sy,n)= u(sx-1,sy,n) - source(n) .* modeShape; 
    for i=2:length(x)-1
        for j=2:length(y)-1
            u(i,j,n+1)= (sigma^2)*(u(i+1,j,n)-2*u(i,j,n)+u(i-1,j,n))...
                +(gamma^2)*(u(i,j+1,n)-2*u(i,j,n)+u(i,j-1,n)) + 2*u(i,j,n) - u(i,j,n-1);
        end
    end

end

%% Plot
[X,Y] = meshgrid(x,y);

if wantToRecord
    gif('filename.gif')
end

plotOffset = 1;
for j=1:length(t)
       colormap(cool);
       p1 = surf(X,Y,u(:,:,j)); hold on;
       s1 = plot3(X(sx,sy), Y(sx,sy)+ u(sx,sy,j), sy*0 + plotOffset,'r');
       
       title(sprintf('2D wave equation at t = %1.2f, con sigma = %1.2f y gamma = %1.2f',t(j),sigma, gamma),'Fontsize',11);
       xlabel('x','Fontsize',11); ylabel('y','Fontsize',11);
       zlabel(sprintf('u(x,y,t = %1.2f)',t(j)),'Fontsize',11);
       axis ([0 1 0 1 -1 1]);
       shading interp
       view([0 90]);
       
       
       pause(0.001);
       if wantToRecord
        gif
       end
       hold on; 
       
       if(j~=length(t))
           delete(p1);
           delete(s1);
       end
end
