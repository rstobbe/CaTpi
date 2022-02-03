%====================================================
%
%====================================================

function [TPIT,err] = CaTpiType_Standard_v1c_Func(TPIT,INPUT)

err.flag = 0;
err.msg = '';

TPIT.tpiin = @CaTpiStandard_v1a;
TPIT.tpiout = @CaTpiStandard_v1a;
TPIT.radevin = @RadEv_v1a;
TPIT.radevout = @RadEv_v1a;

%----------------------------------------------------
% Get Input
%----------------------------------------------------
GAM = TPIT.GAM;
PROJdgn = INPUT.PROJdgn;
clear INPUT;

%----------------------------------------------------
% Get Radial Evolution Design Function
%----------------------------------------------------
Status2('busy','Get Gamma Design Function',3);
func = str2func([GAM.method,'_Func']);
INPUT.p = TPIT.p;
[GAM,err] = func(GAM,INPUT);
if err.flag ~= 0
    return
end
TPIT.RadDesFunc = GAM.GamFunc;

%----------------------------------------------------
% Save Gamma Shape and SDC Shape
%----------------------------------------------------
GAM.p = TPIT.p;
GAM.r = (0:0.0001:1);
GAM.GamShape = GAM.GamFunc(GAM.r,GAM.p);
if length(GAM.GamShape) == 1
    GAM.GamShape = ones(size(GAM.r))*GAM.GamShape;
end

%----------------------------------------------------
% Calculate Sampling Density
%----------------------------------------------------
SDpre = 1./(GAM.r(GAM.r<=GAM.p).^2);
SDpost = GAM.GamShape(GAM.r>GAM.p);
GAM.SampDensNoPos = [SDpre SDpost]*GAM.p;
TPIT.edgeSDnoPos = GAM.SampDensNoPos(end);

%----------------------------------------------------
% Calculate Radial Evolution for Analysis
%----------------------------------------------------
p = TPIT.p;
options = odeset('RelTol',1e-8);                                   
G = @(r) GAM.GamFunc(r,p);
projlen0 = 20;
tau = (0:0.001:projlen0);
[x,r] = ode45('Rad_Sol',tau,p,options,G);
if isempty(r(r > 1))
    error;                                      % increase test projlen0 (above)
end
rout = r(r < 1);
xout = x(r < 1);

tau = (0:-0.00001:-p);
[x,r] = ode45('Rad_Sol',tau,p,options,G);
rin = r(r > 0);
xin = x(r > 0);

TPIT.TpiTau = [0;(xout + p)];
TPIT.TpiRadAtTau = [0;abs(rout)];
TPIT.CaTpiTau = [flip(xin,1);xout(2:end)]-xin(end);
TPIT.CaTpiRadAtTau = [flip(rin,1);rout(2:end)]-rin(end);

TPIT.TpiProjLen = TPIT.TpiTau(end);
TPIT.CaTpiProjLen = TPIT.CaTpiTau(end);

TPIT.Rad = (0:0.0001:1);
TPIT.TpiTimeAtRad = (PROJdgn.tro/TPIT.TpiProjLen)*interp1(TPIT.TpiRadAtTau,TPIT.TpiTau,TPIT.Rad,'pchip','extrap');
TPIT.CaTpiTimeAtRad = (PROJdgn.tro/TPIT.CaTpiProjLen)*interp1(TPIT.CaTpiRadAtTau,TPIT.CaTpiTau,TPIT.Rad,'pchip','extrap');

%----------------------------------------------------
% DifEq Related
%----------------------------------------------------
TPIT.phiconstrain = 100*(TPIT.coneconstrain+1)/(PROJdgn.ncones/2);

%--------------------------------------------
% Name
%--------------------------------------------
sfov = num2str(PROJdgn.fov,'%03.0f');
svox = num2str(10*(PROJdgn.vox^3)/PROJdgn.elip,'%04.0f');
selip = num2str(100*PROJdgn.elip,'%03.0f');
stro = num2str(10*PROJdgn.tro,'%03.0f');
snproj = num2str(PROJdgn.nproj,'%4.0f');
if isfield(GAM,'beta')
    sbeta = num2str(GAM.beta*10,'%2.0f');
    TPIT.name0 = ['DES_F',sfov,'_V',svox,'_E',selip,'_T',stro,'_N',snproj,'_B',sbeta];
elseif isfield(GAM,'N')
    TPIT.name0 = ['DES_F',sfov,'_V',svox,'_E',selip,'_T',stro,'_N',snproj,'_GH'];
else
    TPIT.name0 = ['DES_F',sfov,'_V',svox,'_E',selip,'_T',stro,'_N',snproj];
end
    
%----------------------------------------------------
% Panel Items
%----------------------------------------------------
TPIT.Panel = GAM.Panel;
TPIT.GAM = GAM;

%====================================================
% DiffEq
%====================================================
function dy = CaTpiStandard_v1a(t,y,phi,INPUT)  

deradsolfunc = INPUT.deradsolfunc;
TPIT = INPUT.TPIT;

r = y(1);
dr = 1/(r^2*deradsolfunc(r)*TPIT.RadDesFunc(r,TPIT.p));

phiC = (pi/2)*(TPIT.phiconstrain/100);
if phi < phiC
    phi = phiC - (0.5*(phiC-phi));
elseif phi > (pi-phiC)
    phi = (pi-phiC) + (0.5*(phi-(pi-phiC)));
end
    
w = 1 - exp(-(1.5/TPIT.p)*r);

dtheta = sqrt(w/(r^2*sin(phi)^2));

dy = [dr;dtheta];

%====================================================
% RadEv
%====================================================
function dr = RadEv_v1a(t,r,INPUT)  

deradsolfunc = INPUT.deradsolfunc;
TPIT = INPUT.TPIT;
dr = 1/(r^2*deradsolfunc(r)*TPIT.RadDesFunc(r,TPIT.p));



