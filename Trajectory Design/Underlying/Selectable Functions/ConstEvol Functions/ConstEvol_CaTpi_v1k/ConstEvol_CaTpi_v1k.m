%==================================================
%  (v1k)
%       - naming changes only
%==================================================

function [SCRPTipt,CACC,err] = ConstEvol_CaTpi_v1k(SCRPTipt,CACCMipt)

Status2('done','Get Evolution Constraint info',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Load Panel Input
%---------------------------------------------
CACC.method = CACCMipt.Func;   
CACC.gvelstart = str2double(CACCMipt.('GvelStart'));
CACC.gaccstart = str2double(CACCMipt.('GaccStart'));
CACC.gvelreturn = str2double(CACCMipt.('GvelReturn'));
CACC.returntwk = str2double(CACCMipt.('ReturnTwk1'));
CACC.gacctransition = str2double(CACCMipt.('GaccTransition'));
CACC.fracdecel = str2double(CACCMipt.('pFracDecel'));

Status2('done','',3);