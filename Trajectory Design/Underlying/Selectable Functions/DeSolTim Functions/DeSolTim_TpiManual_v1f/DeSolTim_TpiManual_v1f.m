%====================================================
% (v1f)
%   - solution timing update for CaTpi
%   - get smaller error for inside solution
%====================================================

function [SCRPTipt,DESOL,err] = DeSolTim_TpiManual_v1f(SCRPTipt,DESOLipt)

Status2('busy','Determine Solution Timing',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
DESOL.method = DESOLipt.Func;
DESOL.fine = str2double(DESOLipt.('Fineness'));
DESOL.shape = str2double(DESOLipt.('Shape'));

Status2('done','',2);
Status2('done','',3);