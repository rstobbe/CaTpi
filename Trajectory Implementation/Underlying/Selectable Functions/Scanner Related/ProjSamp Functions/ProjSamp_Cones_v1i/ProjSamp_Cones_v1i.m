%====================================================
% (v1i)
%       - OSampPhi Selector
%====================================================

function [SCRPTipt,PSMP,err] = ProjSamp_Cones_v1i(SCRPTipt,PSMPipt)

Status2('busy','Get Info for Projection Sampling',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
PSMP.method = PSMPipt.Func;
PSMP.OSampPhi = str2double(PSMPipt.('OSampPhi'));

%---------------------------------------------
% Projection Sampling
%---------------------------------------------
PSMP.PCDfunc = 'ProjConeDist_TPI1d_v1j';
PSMP.PADfunc = 'ProjAngleDist_TPI1_v2e';
PSMP.PAD.Rnd = 71;
PSMP.PCD = '';

Status2('done','',2);
Status2('done','',3);

