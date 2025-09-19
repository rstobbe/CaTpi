%====================================================
% 
%====================================================

function [PSMP,err] = ProjSamp_TpiAsymFov_v1d_Func(PSMP,INPUT)

Status2('busy','Define Projection Sampling',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PROJdgn = INPUT.PROJdgn;
testing = INPUT.testing;
TPIT = INPUT.TPIT;
clear INPUT

%----------------------------------------------------
% Constrained Cones
%----------------------------------------------------
if TPIT.coneconstrain == 0
    eproj = 0;
else
    eproj = ones([1,TPIT.coneconstrain]);
end

%---------------------------------------------
% Determine Distribution
%---------------------------------------------
radxy = PROJdgn.rad;
kspcexyrel = 1;
radz = PROJdgn.rad*PROJdgn.elip/(PROJdgn.fov/PSMP.fovz);
kspczrel = (PROJdgn.fov/PSMP.fovz)/PROJdgn.elip;

p = PROJdgn.p;
nproj0 = PROJdgn.nproj;
osamp = 1;
its = 0;
randtwiddle = 0.01;
while true
    phi = (asin((1/osamp)*kspczrel/radxy))/2;
    rad = radxy;
    kspcrel = kspczrel;
    for i = 2:1e6
        rad(i) = sqrt((radxy*cos(phi(i-1))).^2 + (radz*sin(phi(i-1))).^2);
        kspcrel(i) = sqrt((kspczrel*cos(phi(i-1))).^2 + (kspcexyrel*sin(phi(i-1))).^2);
        phi(i) = phi(i-1) + asin((1/osamp)*kspcrel(i)/PROJdgn.rad);
        if phi(i) > pi/2 
            break
        end
    end
    phi(i) = pi/2;
    phi = flip(phi);                           
    ncones = length(phi);                       % to cover half
    nprojcone = zeros(1,ncones);
    nprojcone0 = zeros(1,ncones);
    rad = flip(rad);
    for i = 1:ncones
        if i == 1
            nprojcone(i) = 1;
            continue
        end
        nprojcone0(i) = pi*cos(phi(i))*2*rad(i)*p*osamp;
        nprojcone(i) = ceil(nprojcone0(i));
        if i <= length(eproj)+1 
            for a = 1:length(eproj)
                if i == 1+a
                    nprojcone(i) = nprojcone(i) + eproj(a); 
                end
            end
        else
            if its > 10000
                nprojcone(i) = ceil(nprojcone0(i) + randtwiddle*randn(1));
            end
        end
    end
    nproj = 2*sum(nprojcone);
    if nproj == nproj0
        break
    elseif nproj < nproj0
        osamp = osamp*1.0001;
    elseif nproj > nproj0
        osamp = osamp*0.9999;
    end
    its = its+1;
    if its > 1000000
        randtwiddle = 0.05
    end
end
phi = pi/2 - phi;               % proper angle down from top (I did angle with horizontal above)

n = 1;
for i = 1:ncones
    projindx{i} = (n:n+nprojcone(i)-1);
    n = n+nprojcone(i);
end
flipphi = flip(phi,2);
flipnprojcone = flip(nprojcone);
for i = 1:ncones
    projindx{ncones+i} = (n:n+flipnprojcone(i)-1);
    n = n+flipnprojcone(i);
end

PCD.conephi = [phi pi-flipphi];
PCD.projindx = projindx;
PCD.ncones = ncones*2;
PCD.nprojcone = [nprojcone flipnprojcone];
PCD.projosamp = osamp^2;
PCD.nproj = nproj;                                            

Status2('done','',2);
Status2('done','',3);

%---
figure(4574); hold on;
for n = 1:length(PCD.conephi)
    plot([0 sin(PCD.conephi(n))*PROJdgn.rad],[0 cos(PCD.conephi(n))*PROJdgn.rad*PROJdgn.elip],'r');
end
axis equal;
%---

%----------------------------------------------------
% Projection-Angle Distribution
%---------------------------------------------------- 
if strcmp(testing,'Yes')
    PCD.testncones = PCD.ncones;
    PCD.testnprojcone = 1;
    PCD.testconephi = PCD.conephi;
    PAD.IV(1,1:PCD.testncones) = PCD.testconephi;
    PAD.IV(2,1:PCD.testncones) = 0; 
else
    func = str2func([PSMP.PADfunc,'_Func']);   
    INPUT.PCD = PCD;
    PAD.Rnd = 71;
    [PAD,err] = func(PAD,INPUT);
    if err.flag
        return
    end
    clear INPUT;
end
    
%----------------------------------------------------
% Return
%----------------------------------------------------  
PSMP.IV = PAD.IV;
PSMP.phi = PSMP.IV(1,:);
PSMP.theta = PSMP.IV(2,:);
PSMP.projosamp = PCD.projosamp;
PSMP.nproj = PCD.nproj;
PSMP.ncones = PCD.ncones;
PSMP.PCD = PCD;
PSMP.PAD = PAD;
PSMP.projsampscnr = (1:1:PROJdgn.nproj);

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
Panel(1,:) = {'projosamp',PSMP.projosamp,'Output'};
Panel(2,:) = {'osamp',PCD.projosamp,'Output'};
Panel(3,:) = {'ncones',PCD.ncones,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
PSMP.PanelOutput = PanelOutput;




