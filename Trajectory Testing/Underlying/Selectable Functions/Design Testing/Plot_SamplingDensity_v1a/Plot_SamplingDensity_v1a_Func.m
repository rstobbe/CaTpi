%==================================================
% 
%==================================================

function [PLOT,err] = Plot_SamplingDensity_v1a_Func(PLOT,INPUT)

Status2('busy','Plot Gradient Slew',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
DES = INPUT.DES;
PROJdgn = DES.PROJdgn;
r = DES.TPIT.GAM.r;
GamShape = DES.TPIT.GAM.GamShape;
clear INPUT

%-----------------------------------------------------
% Gradient Slew
%-----------------------------------------------------
hFig = figure(1000); hold on; box on;
plot(r,GamShape,'k-');
title('Gamma Shape');
ylabel('Gamma Value','fontsize',10,'fontweight','bold');
xlabel('Relative Radius','fontsize',10,'fontweight','bold');
xlim([0 1]);
ylim([0 50]);
hFig.Units = 'inches';
hFig.Position = [5 5 2.5 2.1];
hAx = gca;
hAx.XTick = (0:0.2:1);
PLOT.Name = 'GammaShape';
fig = 1;
PLOT.Figure(fig).Name = 'GammaShape';
PLOT.Figure(fig).Type = 'Graph';
PLOT.Figure(fig).hFig = hFig;
PLOT.Figure(fig).hAx = hAx;

Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',PLOT.method,'Output'};
PLOT.Panel = Panel;

