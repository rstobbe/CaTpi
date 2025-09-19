%=====================================================
% (v1a) 
%    
%=====================================================

function [SCRPTipt,KSMP,err] = kSamp_BwCalcDel_v1a(SCRPTipt,KSMPipt)

Status2('done','Get k-Space Sampling Function Info',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
KSMP.method = KSMPipt.Func;
KSMP.cenpntdrop = str2double(KSMPipt.('ExtraPntDrop'));

Status2('done','',2);
Status2('done','',3);

