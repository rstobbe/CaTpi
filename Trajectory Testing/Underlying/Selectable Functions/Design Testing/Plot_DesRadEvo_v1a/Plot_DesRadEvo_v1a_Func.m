%==================================================
% 
%==================================================

function [PLOT,err] = Plot_DesRadEvo_v1a_Func(PLOT,INPUT)

Status2('busy','Plot Radial Evolution',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
DES = INPUT.DES;
clear INPUT

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
fh = figure(1000); hold on; box on;
plot(DES.TPIT.TpiTau,DES.TPIT.TpiRadAtTau);
plot(DES.TPIT.CaTpiTau,DES.TPIT.CaTpiRadAtTau);
ylim([0 1.05]);
title('Radial Evolution');
xlabel('(tau)','fontsize',10,'fontweight','bold');
ylabel('Relative k-Space Radius','fontsize',10,'fontweight','bold');
fh.Units = 'inches';
fh.Position = [5 5 3 2.4];
hAx = gca;

PLOT.Name = 'RadEvo';
fig = 1;
PLOT.Figure(fig).Name = 'RadEvo';
PLOT.Figure(fig).Type = 'Graph';
PLOT.Figure(fig).hFig = fh;
PLOT.Figure(fig).hAx = hAx;


PLOT.Panel(1,:) = {'','','Output'};
PLOT.Panel(2,:) = {'',PLOT.method,'Output'};