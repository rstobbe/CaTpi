%====================================================
% (v1b)
%      - difference PAD
%====================================================

function [SCRPTipt,PSMP,err] = ProjSamp_TpiAsymFov_v1b(SCRPTipt,PSMPipt)

Status2('busy','Get Info for Projection Sampling',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
PSMP.method = PSMPipt.Func;
PSMP.fovz = str2double(PSMPipt.('FoVz'));

%---------------------------------------------
% Projection Sampling
%---------------------------------------------
PSMP.PADfunc = 'ProjAngleDist_TPI1_v3a';
PSMP.PAD.Rnd = 71;
PSMP.PCD = '';

Status2('done','',2);
Status2('done','',3);

