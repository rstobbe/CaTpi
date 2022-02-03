%====================================================
% 
%====================================================

function [GAM] = TPI_SampTim_v1b(GAM,PROJdgn)

pdr = GAM.r;
p = GAM.p;
Tro = PROJdgn.tro;
gamfunc = GAM.GamFunc;
projlen = GAM.projlen0;

options = odeset('RelTol',1e-7);                                   

G = @(r) gamfunc(r,p);

tau = (0:0.001:projlen*1.01);
[x,r] = ode45('Rad_Sol',tau,p,options,G);
if isempty(r(r > 1))
    error;                                      % increase test projlen (above)
end
rout = r(r < 1);
xout = x(r < 1);

tau = (0:-0.001:-p);
[x,r] = ode45('Rad_Sol',tau,p,options,G);
rin = r(r > 0);
xin = x(r > 0);

GAM.TpiTau = [0;(xout + p)];
GAM.TpiRadAtTau = [0;abs(rout)];
GAM.CaTpiTau = [flip(xin,1);xout(2:end)]-xin(end);
GAM.CaRadAtTau = [flip(rin,1);rout(2:end)];

GAM.TpiProjLen = GAM.TpiTau(end);
GAM.CaTpiProjLen = GAM.CaTpiTau(end);

GAM.TpiTimeAtRad = (Tro/GAM.TpiProjLen)*interp1(GAM.TpiRadAtTau,GAM.TpiTau,pdr,'pchip','extrap');



