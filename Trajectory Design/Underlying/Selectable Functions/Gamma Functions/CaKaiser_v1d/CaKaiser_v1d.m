%====================================================
% (v1d)
%       - start Kaiser_v1d
%====================================================

function [SCRPTipt,GAMFUNC,err] = CaKaiser_v1d(SCRPTipt,GAMFUNCipt)

Status2('busy','Get Info for Kaiser Design Function',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Input
%---------------------------------------------
GAMFUNC.method = GAMFUNCipt.Func;
GAMFUNC.beta = str2double(GAMFUNCipt.('Beta'));
GAMFUNC.slope = str2double(GAMFUNCipt.('Slope'));
GAMFUNC.shift = str2double(GAMFUNCipt.('Shift'));
GAMFUNC.scale = str2double(GAMFUNCipt.('Scale'));

Status2('done','',2);
Status2('done','',3);
