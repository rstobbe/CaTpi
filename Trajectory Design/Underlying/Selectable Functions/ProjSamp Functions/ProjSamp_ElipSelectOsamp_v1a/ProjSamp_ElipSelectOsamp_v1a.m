%====================================================
% (v1a)
%       
%====================================================

function [SCRPTipt,PSMP,err] = ProjSamp_ElipSelectOsamp_v1a(SCRPTipt,PSMPipt)

Status2('busy','Get Info for Projection Sampling',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
PSMP.method = PSMPipt.Func;

Status2('done','',2);
Status2('done','',3);

