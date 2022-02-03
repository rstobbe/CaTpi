%====================================================
% 
%====================================================

function [GAMFUNC,err] = CaKaiser_v1d_Func(GAMFUNC,INPUT)

Status2('busy','Define Gamma Design Function',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
beta = GAMFUNC.beta;
slope = GAMFUNC.slope;
shift = GAMFUNC.shift;
scale = GAMFUNC.scale;
p = INPUT.p;

%---------------------------------------------
% Define Function
%---------------------------------------------
FiltFunc = @(r) besseli(0,beta * sqrt(1 - r.^2));
AccFunc = @(r,p) scale ./ (1 + exp(-slope*(r-(shift*p))));
TotalFunc = @(r,p) FiltFunc(r) + AccFunc(r,p);
GamFunc = @(r,p) (1/p^2)*TotalFunc(r,p)/TotalFunc(p,p);

r = 0:0.01:1;
figure(234632);
plot(r,GamFunc(r,p));

%----------------------------------------------------
% Panel Items
%----------------------------------------------------
Panel(1,:) = {'Beta',beta,'Output'};
Panel(2,:) = {'Slope',slope,'Output'};
Panel(3,:) = {'Shift',shift,'Output'};
Panel(4,:) = {'Scale',scale,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
GAMFUNC.PanelOutput = PanelOutput;
GAMFUNC.Panel = Panel;

GAMFUNC.GamFunc = GamFunc;


