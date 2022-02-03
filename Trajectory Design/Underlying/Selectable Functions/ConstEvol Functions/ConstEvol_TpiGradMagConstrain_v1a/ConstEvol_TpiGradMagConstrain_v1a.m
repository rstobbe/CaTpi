%==================================================
%  (v1a)
%       - 
%==================================================

function [SCRPTipt,CACCM,err] = ConstEvol_TpiGradMagConstrain_v1a(SCRPTipt,CACCMipt)

Status2('done','Get Evolution Constraint info',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
CACCM.method = CACCMipt.Func; 
CACCM.gaccstart = str2double(CACCMipt.('GaccStart'));
CACCM.gvelstart = str2double(CACCMipt.('GvelStart'));
CACCM.gmaginit = str2double(CACCMipt.('GmagInit'));
CACCM.gacctransition = str2double(CACCMipt.('GaccTransition'));
CACCM.gvelmatch = str2double(CACCMipt.('GvelMatch'));
CACCM.pfracmatchstart = str2double(CACCMipt.('pFracMatchStart'));

Status2('done','',3);