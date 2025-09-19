%==================================================
% 
%==================================================

function [PLOT,err] = Plot_ImpRadialGradient_v1a_Func(PLOT,INPUT)

Status2('busy','Plot Gradients (Ortho)',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
N = PLOT.trajnum;
IMP = INPUT.IMP;
PROJdgn = IMP.PROJdgn;
clear INPUT

%qTscnr = IMP.qTscnr(5:504) - 0.04;
%G = IMP.G(:,5:503,:);
%qTscnr = IMP.qTscnr(5:2004) - 0.04;
%G = IMP.G(:,5:2003,:);
Kmat = IMP.Kmat;
Samp = IMP.samp;

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
Kmag = sqrt(Kmat(N,:,1).^2 + Kmat(N,:,2).^2 + Kmat(N,:,3).^2);
T = [0 Samp];
Rad = [0 Kmag];
m = 2:length(T);
TStep = T(m)-T(m-1);
G = ((Rad(m)-Rad(m-1))./TStep)/11.26;

Tatp = interp1(Rad,T,PROJdgn.p*PROJdgn.kmax);

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
hFig = figure(999); hold on; box on;
plot(T,[0 G]);
plot([Tatp Tatp],[-10 22]);
%ylim([-10 22]);
% xlim([0 10]);
title('RadialGradient');
xlabel('(ms)','fontsize',10,'fontweight','bold');
ylabel('Gradients (mT/m)','fontsize',10,'fontweight','bold');
hFig.Units = 'inches';
hFig.Position = [5 5 3 2.4];
hAx = gca;

fig = 1;
PLOT.Figure(fig).Name = 'GradRad';
PLOT.Figure(fig).Type = 'Graph';
PLOT.Figure(fig).hFig = hFig;
PLOT.Figure(fig).hAx = hAx;

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
Rad = Rad/PROJdgn.kmax;
StdRad = (0.3/3.9)*10;

Tauatp = 0.3*Tatp/StdRad

TotTau = Tauatp + 3.6;
Tau = TotTau*T/10;

fh = figure(1000); hold on; box on;
plot(Tau,Rad);
ylim([0 1.05]);
title('Radial Evolution');
xlabel('(tau)','fontsize',10,'fontweight','bold');
ylabel('Relative k-Space Radius','fontsize',10,'fontweight','bold');
fh.Units = 'inches';
fh.Position = [5 5 3 2.4];
hAx = gca;

fig = 2;
PLOT.Figure(fig).Name = 'RadEvo';
PLOT.Figure(fig).Type = 'Graph';
PLOT.Figure(fig).hFig = fh;
PLOT.Figure(fig).hAx = hAx;

%---------------------------------------------
% Return
%---------------------------------------------
PLOT.Name = 'RadialGradient';

Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',PLOT.method,'Output'};
PLOT.Panel = Panel;