function demo1a
% Masterfile for shallow water problem
% Island in a bay; following H.Ninomiya/K.Onishi
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% flow at coast following Ninomija %%%%
%%% WITHOUT MATLAB PDE TOOLBOX %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% p = (p1;p2;p3) : (X,Y)-Coordinates, water depth
% V = (V1;V2;V3) : V1 = U, V2 = V Velocity;
% V3 = Z         : tidal elevation
% FF1            : geometry data
% FF2        : file of boundary conditions at sea 
% exterior boundary must be ordered counterclockwise
% interior boundary (of island) must be ordered clockwise

clc, clear, format compact
% Example:
disp(' Island in a Bay ')
FF1 = 'bsp01'; FF2 = 'bsp01h';
RDSEA    = 1;     % Segnrn. sea
RDLAND   = 2;     % Segnrn. land
RDISLAND = 3;     % Segnrn. island

REFINE = 0; DT = 80; % refinements, DT time step
%REFINE = 1; DT = 10; % refinements
% -- parameters ----------------
PERIODE = 12*3600;       % cycle [sec] of inlet
A      = 1;              % Amplitude of inlet
g      = 9.81  ;         % gravitational acceleration
nu = 23;              % eddy viscosity/rho = 23 [m^2/s], see Ninomija, p. 168
nu = 0;
Parmeter = [A,PERIODE,g,nu];
MAXITER  = 3600/DT; % one hour total
% -----------------------------
disp(' one start and 11 restarts ')
Start = 100; 
%while ~ismember(Start,[0,1])
%   Start = input(' New start or Restart ? (1/0) ');
%end
for KK = 1:9  % 1:6 then 7:12
    if KK == 1, Start = 1;
    else Start = 0; end
if Start == 1
   [p,e,t,waterdepth] = start4shallow(FF1,REFINE); 
   p = [p;waterdepth]; hours = 1; N = size(p,2);
   save daten1a p e t  
   %bild00(p,e,t), pause
   V = zeros(3,N); VN = V; T = 0;
else
   load daten1a p e t 
   load daten1b V hours, VN = V; 
   T = hours*3600;
   hours = hours + 1; N = size(p,2); 
   if hours > 12, return, end 
end
SCLAND   = tang_norm(p,e,RDLAND);
SCISLAND = tang_norm(p,e,RDISLAND);
% Simulation start ------------------------------------
for ITER = 1:MAXITER
   VN = flow(p,t,V,VN,DT/2,Parmeter);
   T   = T + DT/2;
   RDZ = feval(FF2,e,T,Parmeter);
   VN(3,RDZ(1,:)) = RDZ(2,:);
   VN(1:2,:) = vnomal(e,VN(1:2,:),SCLAND,SCISLAND);
   SHALLOW   = find(p(3,:) + VN(3,:) <= 0); % shallow water
   VN(1:2,SHALLOW) = 0;
   % ------------------------------
   VN = flow(p,t,V,VN,DT,Parmeter);
   T = T + DT/2;
   RDZ = feval(FF2,e,T,Parmeter);
   VN(3,RDZ(1,:)) = RDZ(2,:);
   VN(1:2,:) = vnomal(e,VN(1:2,:),SCLAND,SCISLAND);
   SHALLOW   = find(p(3,:) + VN(3,:) <= 0); % shallow water
   VN(1:2,SHALLOW) = 0;
   DIFF = max(abs(VN(3,:) - V(3,:)));
   I_DIFFZ = [ITER,DIFF]
   V = VN;
end
save daten1b V hours SHALLOW
hours
switch hours
   case  1, save daten1b_1  V SHALLOW
   case  2, save daten1b_2  V SHALLOW
   case  3, save daten1b_3  V SHALLOW
   case  4, save daten1b_4  V SHALLOW
   case  5, save daten1b_5  V SHALLOW
   case  6, save daten1b_6  V SHALLOW
   case  7, save daten1b_7  V SHALLOW
   case  8, save daten1b_8  V SHALLOW
   case  9, save daten1b_9  V SHALLOW
   case 10, save daten1b_10 V SHALLOW
   case 11, save daten1b_11 V SHALLOW
   case 12, save daten1b_12 V SHALLOW
end
end
disp(' Call bild01a or bild01b ! ')
