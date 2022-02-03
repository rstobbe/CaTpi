%====================================================
% (v1a)
%   
%====================================================

function [SCRPTipt,TPIT,err] = CaTpiType_Standard_v1b(SCRPTipt,TPITipt)

Status2('busy','CaTpi Design',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
TPIT.method = TPITipt.Func;   
TPIT.gamfunc = TPITipt.('Gamfunc').Func;
TPIT.p = str2double(TPITipt.('pVal'));
TPIT.coneconstrain = str2double(TPITipt.('ConeConstrainNum'));

%---------------------------------------------
% Get Working Structures from Sub Functions
%---------------------------------------------
GAMipt = TPITipt.('Gamfunc');
if isfield(TPITipt,('Gamfunc_Data'))
    GAMipt.Gamfunc_Data = TPITipt.Gamfunc_Data;
end

%------------------------------------------
% Get Elip Function Info
%------------------------------------------
func = str2func(TPIT.gamfunc);           
[SCRPTipt,GAM,err] = func(SCRPTipt,GAMipt);
if err.flag
    return
end

TPIT.GAM = GAM;

Status2('done','',2);