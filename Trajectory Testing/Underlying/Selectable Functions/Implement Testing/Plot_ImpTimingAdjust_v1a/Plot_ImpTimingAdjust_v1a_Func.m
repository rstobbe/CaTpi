%==================================================
% 
%==================================================

function [PLOT,err] = Plot_ImpTimingAdjust_v1a_Func(PLOT,INPUT)

Status2('busy','Plot Timing Adjust',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
CACC = INPUT.IMP.CACC;
PROJdgn = INPUT.IMP.PROJdgn;
clear INPUT

%----------------------------------------------------
% Speed
%----------------------------------------------------
hFig = figure(1000); hold on;
plot(CACC.kMagArr/max(CACC.kMagArr),CACC.Vel0,'k-');
plot(CACC.kMagArr/max(CACC.kMagArr),CACC.Vel,'k-');
plot([PROJdgn.p PROJdgn.p],[0 250],'r:');
title('Speed');
xlabel('r','fontsize',10,'fontweight','bold');
ylabel('(1/m/ms)','fontsize',10,'fontweight','bold');
xlim([0 1]);
ylim([0 250]);
hFig.Units = 'inches';
hFig.Position = [5 5 3 2.4];
hAx = gca;
PLOT.Name = 'Speed';
fig = 1;
PLOT.Figure(fig).Name = 'Speed';
PLOT.Figure(fig).Type = 'Graph';
PLOT.Figure(fig).hFig = hFig;
PLOT.Figure(fig).hAx = hAx;

%----------------------------------------------------
% Acceleration
%----------------------------------------------------
hFig = figure(1001); hold on;
plot(CACC.kMagArr/max(CACC.kMagArr),CACC.Acc0,'k-');
plot(CACC.kMagArr/max(CACC.kMagArr),CACC.Acc,'k-');
plot([PROJdgn.p PROJdgn.p],[-2500 2500],'r:');
title('Acceleration');
xlabel('r','fontsize',10,'fontweight','bold');
ylabel('(1/m/ms2)','fontsize',10,'fontweight','bold');
xlim([0 1]);
ylim([-2500 2500]);
hFig.Units = 'inches';
hFig.Position = [5 5 3 2.4];
hAx = gca;
PLOT.Name = 'Acceleration';
fig = 2;
PLOT.Figure(fig).Name = 'Acceleration';
PLOT.Figure(fig).Type = 'Graph';
PLOT.Figure(fig).hFig = hFig;
PLOT.Figure(fig).hAx = hAx;

%----------------------------------------------------
% Jerk
%----------------------------------------------------
hFig = figure(1002); hold on;
plot(CACC.kMagArr/max(CACC.kMagArr),CACC.Jrk0,'k-');
plot(CACC.kMagArr/max(CACC.kMagArr),CACC.Jrk,'k-');
plot([PROJdgn.p PROJdgn.p],[-100000 100000],'r:');
title('Jerk');
xlabel('r','fontsize',10,'fontweight','bold');
ylabel('(1/m/ms)','fontsize',10,'fontweight','bold');
xlim([0 1]);
ylim([-100000 100000]);
hFig.Units = 'inches';
hFig.Position = [5 5 3 2.4];
hAx = gca;
PLOT.Name = 'Jerk';
fig = 1;
PLOT.Figure(fig).Name = 'Jerk';
PLOT.Figure(fig).Type = 'Graph';
PLOT.Figure(fig).hFig = hFig;
PLOT.Figure(fig).hAx = hAx;

Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',PLOT.method,'Output'};
PLOT.Panel = Panel;
