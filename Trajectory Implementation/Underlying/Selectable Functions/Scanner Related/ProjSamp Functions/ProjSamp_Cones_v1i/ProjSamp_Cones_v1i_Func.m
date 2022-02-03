%====================================================
% 
%====================================================

function [PSMP,err] = ProjSamp_Cones_v1i_Func(PSMP,INPUT)

Status2('busy','Define Projection Sampling',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Get Input
%---------------------------------------------
PROJdgn = INPUT.PROJdgn;
testing = INPUT.testing;
TST = INPUT.TST;
TPIT = INPUT.TPIT;
clear INPUT

%---------------------------------------------
% Get Working Structures / Variables
%---------------------------------------------
PCD = PSMP.PCD;
PAD = PSMP.PAD;

%----------------------------------------------------
% Constrained Cones
%----------------------------------------------------
if TPIT.coneconstrain == 0
    eproj = 0;
else
    eproj = ones([1,TPIT.coneconstrain]);
end

%----------------------------------------------------
% Projection-Cone Distribution
%----------------------------------------------------  
func = str2func([PSMP.PCDfunc,'_Func']);
INPUT.PROJdgn = PROJdgn;
INPUT.OSampPhi = PSMP.OSampPhi;
INPUT.eproj = eproj;
INPUT.TST = TST;
[PCD,err] = func(PCD,INPUT);
if err.flag
    return
end
clear INPUT

if isfield(PCD,'Figure')
    PSMP.Figure = PCD.Figure;
    PCD = rmfield(PCD,'Figure');
end

%----------------------------------------------------
% Test
%---------------------------------------------------- 
% if strcmp(PSMP.ignoreusamp,'No')
%     if PCD.osamp_phi < 1 || PCD.osamp_theta < 1
%         err.flag = 1;
%         err.msg = 'increase #projs';
%         return
%     end
% end

%----------------------------------------------------
% Projection-Angle Distribution
%---------------------------------------------------- 
if strcmp(testing,'Yes')
    PCD.testncones = PCD.ncones/2;
    PCD.testnprojcone = 1;
    PCD.testconephi = flip((0:(pi/(PCD.ncones-1)):pi/2),2);
    %PCD.testconephi = (pi/2:(pi/(PCD.ncones-1)):pi);                        % in case want to test negative
    PAD.IV(1,1:PCD.testncones) = PCD.testconephi;
    PAD.IV(2,1:PCD.testncones) = 0; 
else
    func = str2func([PSMP.PADfunc,'_Func']);   
    INPUT.PCD = PCD;
    [PAD,err] = func(PAD,INPUT);
    if err.flag
        return
    end
    clear INPUT;
end
    
%----------------------------------------------------
% Return
%----------------------------------------------------  
PSMP.IV = PAD.IV;
PSMP.phi = PSMP.IV(1,:);
PSMP.theta = PSMP.IV(2,:);
PSMP.projosamp = PCD.projosamp;
PSMP.osamp_phi = PCD.osamp_phi;
PSMP.osamp_theta = PCD.osamp_theta;
PSMP.nproj = PCD.nproj;
PSMP.ncones = PCD.ncones;
PSMP.PCD = PCD;
PSMP.PAD = PAD;
PSMP.projsampscnr = (1:1:PROJdgn.nproj);

%---------------------------------------------
% Panel Output
%--------------------------------------------- 
Panel(1,:) = {'projosamp',PSMP.projosamp,'Output'};
Panel(2,:) = {'osamp_phi',PCD.osamp_phi,'Output'};
Panel(3,:) = {'osamp_theta',PCD.osamp_theta,'Output'};
Panel(4,:) = {'ncones',PCD.ncones,'Output'};
PanelOutput = cell2struct(Panel,{'label','value','type'},2);
PSMP.PanelOutput = PanelOutput;




