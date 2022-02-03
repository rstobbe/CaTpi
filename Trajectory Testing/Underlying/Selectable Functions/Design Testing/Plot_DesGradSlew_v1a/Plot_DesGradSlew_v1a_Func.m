%==================================================
% 
%==================================================

function [PLOT,err] = Plot_DesGradSlew_v1a_Func(PLOT,INPUT)

Status2('busy','Plot Gradient Slew',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%-----------------------------------------------------
% Get Input
%-----------------------------------------------------
DES = INPUT.DES;
PROJdgn = DES.PROJdgn;
KSA = DES.KSA;
T0 = DES.T0;
TST = DES.TST;
p = PROJdgn.p;
clear INPUT

%-----------------------------------------------------
% Plot
%-----------------------------------------------------
[vel,Tvel0] = CalcVelMulti_v2a(KSA*PROJdgn.kmax,T0);
[acc,Tacc0] = CalcAccMulti_v2a(vel,Tvel0);
[jerk,Tjerk0] = CalcJerkMulti_v2a(acc,Tacc0);
magvel0 = sqrt(vel(:,:,1).^2 + vel(:,:,2).^2 + vel(:,:,3).^2);
magacc0 = sqrt(acc(:,:,1).^2 + acc(:,:,2).^2 + acc(:,:,3).^2);
magjerk0 = sqrt(jerk(:,:,1).^2 + jerk(:,:,2).^2 + jerk(:,:,3).^2);  

rad0 = sqrt(KSA(:,:,1).^2 + KSA(:,:,2).^2 + KSA(:,:,3).^2);
rad0 = squeeze(mean(rad0,1));
rad0 = rad0/max(rad0);

rad = (0.01:0.01:1);
magacc = interp1(rad0,magacc0.',rad);
magjerk = interp1(rad0,magjerk0.',rad);

if strcmp(TST.nuc,'1H')
    gamma = 42.577;
elseif strcmp(TST.nuc,'23Na')
    gamma = 11.26;
end

%-----------------------------------------------------
% Gradient Slew
%-----------------------------------------------------
hFig = figure(1000); hold on; box on;
plot(rad,magacc/gamma,'k-');
if isfield(PROJdgn,'ConstCones')
    if PROJdgn.ConstCones ~= 0
        plot(rad,magacc(:,PROJdgn.ConstCones)/gamma,'b-','linewidth',1);
        plot(rad,magacc(:,PROJdgn.ConstCones(1))/gamma,'r-','linewidth',1);
        plot(rad,magacc(:,PROJdgn.ConstCones(end))/gamma,'g-','linewidth',1);
    end
end
plot([p p],[0 250],'r:');
title('Gradient Slew');
ylabel('Gradient Slew (mT/m/ms)','fontsize',10,'fontweight','bold');
xlabel('Relative Radius','fontsize',10,'fontweight','bold');
xlim([0 1]);
ylim([0 250]);
hFig.Units = 'inches';
hFig.Position = [5 5 2.5 2.1];
hAx = gca;
hAx.XTick = (0:0.2:1);
PLOT.Name = 'GradSlew';
fig = 1;
PLOT.Figure(fig).Name = 'GradSlew';
PLOT.Figure(fig).Type = 'Graph';
PLOT.Figure(fig).hFig = hFig;
PLOT.Figure(fig).hAx = hAx;

%-----------------------------------------------------
% Gradient Acceleration
%-----------------------------------------------------
hFig = figure(1001); hold on; box on;
plot(rad,magjerk/gamma,'k-');
if isfield(PROJdgn,'ConstCones')
    if PROJdgn.ConstCones ~= 0
        plot(rad,magjerk(:,PROJdgn.ConstCones)/gamma,'b-','linewidth',1);
        plot(rad,magjerk(:,PROJdgn.ConstCones(1))/gamma,'r-','linewidth',1);
        plot(rad,magjerk(:,PROJdgn.ConstCones(end))/gamma,'g-','linewidth',1);
    end
end
plot([p p],[0 1e4],'r:');
title('Gradient Acceleration');
ylabel('Gradient Acceleration (mT/m/ms2)','fontsize',10,'fontweight','bold');
xlabel('Relative Radius','fontsize',10,'fontweight','bold');
xlim([0 1]);
ylim([0 1e4]);
hFig.Units = 'inches';
hFig.Position = [5 5 2.6 2.1];
hAx = gca;
hAx.XTick = (0:0.2:1);
PLOT.Name = 'GradSlew';
fig = 2;
PLOT.Figure(fig).Name = 'GradAcceleration';
PLOT.Figure(fig).Type = 'Graph';
PLOT.Figure(fig).hFig = hFig;
PLOT.Figure(fig).hAx = hAx;

Panel(1,:) = {'','','Output'};
Panel(2,:) = {'',PLOT.method,'Output'};
PLOT.Panel = Panel;

