%====================================================
% 
%====================================================

function [PCD,err] = ProjConeDist_TpiAsymFov_v1a_Func(PCD,INPUT)

Status2('busy','Determine Projection Cone Distribution',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PROJdgn = INPUT.PROJdgn;
eproj = INPUT.eproj;
phithetafrac = INPUT.PhiThetaFrac;
TST = INPUT.TST;
clear INPUT

%---------------------------------------------
% Determine Distribution
%---------------------------------------------
rad1 = PROJdgn.rad;
rad2 = PROJdgn.rad*PROJdgn.elip;
p = PROJdgn.p;
nproj0 = PROJdgn.nproj;

while true
    phi = (pi/(2*ceil((pi*rad1*osamp)/2)-1))/2;
    rad = rad1;
    for i = 2:1e6
        rad(i) = sqrt((rad1*cos(phi(i-1))).^2 + (rad2*sin(phi(i-1))).^2);
        phi(i) = phi(i-1) + pi/(2*ceil((pi*rad(i)*osamp)/2)-1);
        if phi(i) > pi/2 
            break
        end
    end
    phi(i+1) = pi/2;
    phi = flip(phi);                            % not sure needed
    ncones = length(phi);                       % to cover half
    nprojcone = zeros(1,ncones);
    nprojconecrit = zeros(1,ncones);
    for i = 1:ncones
        if i == 1
            nprojcone(i) = 1;
        end
        for a = 1:length(eproj)
            if i == 1+a
                nprojcone(i) = ceil(pi*sin(phi(i))*2*rad(i)*p*osamp)+eproj(a); 
            end
        end
        if i > length(eproj) 
            nprojcone(i) = ceil(pi*sin(phi(i))*2*rad(i)*p*osamp);
        end
        nprojconecrit(i) = pi*sin(phi(i))*2*rad(i)*p; 
    end
    nproj = 2*sum(nprojcone);
    if nproj == nproj0
        break
    elseif nproj > nproj0
        osamp = osamp*1.05;
    elseif nproj < nproj0
        osamp = osamp*0.99;
    end
end






n = 1;
for i = 1:ncones
    projindx{i} = (n:n+nprojcone(i)-1);
    projconeosamp(n:n+nprojcone(i)-1) = coneosamp(i);
    n = n+nprojcone(i);
end
for i = 1:ncones
    projindx{ncones+i} = (n:n+nprojcone(i)-1);
    projconeosamp(n:n+nprojcone(i)-1) = coneosamp(i);
    n = n+nprojcone(i);
end

if not(isfield(TST,'figshift'))
    TST.figshift = 0;
end

fh = figure(23465234);
plot(coneosamp);
fh.Name = 'ConeOverSampling';
fh.NumberTitle = 'off';
fh.Position = [900+TST.figshift 700 500 400];
xlabel(['Cone Number (OsampPhi = ',num2str(osamp_phi),')']);
ylabel('Relative Sampling');
PCD.Figure(1).Name = 'ConeSampling';
PCD.Figure(1).Type = 'Graph';
PCD.Figure(1).hFig = fh;
PCD.Figure(1).hAx = gca;

PCD.conephi = [phi pi-phi];
PCD.projindx = projindx;
PCD.ncones = ncones*2;
PCD.nprojcone = [nprojcone nprojcone];
PCD.phithetafrac = phithetafrac;
PCD.osamp_phi = osamp_phi;
PCD.osamp_theta = osamp_theta;
PCD.projosamp = osamp_phi*osamp_theta;                  % projection oversample (spherical case)   
PCD.nproj = nproj;                                            
PCD.coneosamp = coneosamp;
PCD.projconeosamp = projconeosamp;

Status2('done','',2);
Status2('done','',3);


