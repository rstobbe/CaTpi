%====================================================
% (v1h)
%       - ProjConeDist_TPI1c_v1j
%====================================================

function [SCRPTipt,PSMP,err] = ProjSamp_DaprMatch_v1h(SCRPTipt,PSMPipt)

Status2('busy','Get Info for Projection Sampling',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
PSMP.method = PSMPipt.Func;

%---------------------------------------------
% Projection Sampling
%---------------------------------------------
PSMP.PCDfunc = 'ProjConeDist_DaprMatchTPI1c_v1j';
PSMP.PADfunc = 'ProjAngleDist_TPI1_v2e';
PSMP.PAD.Rnd = 71;
PSMP.PCD = '';

Status2('done','',2);
Status2('done','',3);

