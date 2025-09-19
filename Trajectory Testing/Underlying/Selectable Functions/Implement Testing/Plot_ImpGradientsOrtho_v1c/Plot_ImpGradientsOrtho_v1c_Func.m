%==================================================
% 
%==================================================

function [PLOT,err] = Plot_ImpGradientsOrtho_v1c_Func(PLOT,INPUT)

Status2('busy','Plot Gradients (Ortho)',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
N = PLOT.trajnum;
IMP = INPUT.IMP;
PROJimp = IMP.PROJimp;
clear INPUT

%qTscnr = IMP.qTscnr(5:504) - 0.04;
%G = IMP.G(:,5:503,:);
%qTscnr = IMP.qTscnr(5:2004) - 0.04;
%G = IMP.G(:,5:2003,:);
qTscnr = IMP.GQNT.scnrarr;
G = IMP.G;
G0 = IMP.GWFM.GQKSA;

% [G0] = SolveGradQuant_v1b(qTscnr,IMP.GWFM.GQKSA,IMP.PROJimp.gamma);
% G = G0;

TGSR = IMP.KSMP.TGSR;
GSR = IMP.KSMP.GSR;

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
[A,B,C] = size(G);
Gvis = zeros(A,(B-1)*2,C); L = zeros(1,(B-1)*2);
for n = 1:length(qTscnr)-1
    L((n-1)*2+1) = qTscnr(n);
    L(n*2) = qTscnr(n+1);
    Gvis(:,(n-1)*2+1,:) = G(:,n,:);
    Gvis(:,n*2,:) = G(:,n,:);
end
Gmag = (Gvis(1,:,1).^2 + Gvis(1,:,2).^2 + Gvis(1,:,3).^2).^0.5;

hFig = figure(1000); hold on; box on;
plot(L,Gvis(N,:,1),'b-'); plot(L,Gvis(N,:,2),'g-'); plot(L,Gvis(N,:,3),'r-');
%plot([PROJimp.pLocTime PROJimp.pLocTime],[-15 15],'k');
%plot(L,Gmag,'k-');
plot(TGSR,GSR(N,:,1),'b-',TGSR,GSR(N,:,2),'g-',TGSR,GSR(N,:,3),'r-')

% ylim([-2.5 4.5]);
xlim([0 9]);
%ylim([-5 35]);
%xticks([0.03 0.06 0.09 0.12]);
title(['Traj',num2str(N)]);
xlabel('(ms)','fontsize',10,'fontweight','bold');
ylabel('Gradients (mT/m)','fontsize',10,'fontweight','bold');
hFig.Units = 'inches';
hFig.Position = [5 5 3 2.4];
hAx = gca;

%---------------------------------------------
% Return
%---------------------------------------------
PLOT.Name = 'GradOrtho';
fig = 1;
PLOT.Figure(fig).Name = 'GradOrtho';
PLOT.Figure(fig).Type = 'Graph';
PLOT.Figure(fig).hFig = hFig;
PLOT.Figure(fig).hAx = hAx;

Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',PLOT.method,'Output'};
PLOT.Panel = Panel;
