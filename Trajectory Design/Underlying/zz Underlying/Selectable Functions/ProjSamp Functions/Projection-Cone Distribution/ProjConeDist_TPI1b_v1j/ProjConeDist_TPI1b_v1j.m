%====================================================
% (TPI1b)
%       - directly specify extra projections on cones (from above)
%       - phithetafrac0 (from above)
% (v1j)
%       - search update
%====================================================

function [SCRPTipt,PCD,err] = ProjConeDist_TPI1b_v1j(SCRPTipt,PCDipt)

Status2('busy','Get Info For Projection Cone Distribution',2);
Status2('done','',3);

err.flag = 0;
err.msg = '';

%---------------------------------------------
% Return Panel Input
%---------------------------------------------
PCD.method = PCDipt.Func;

Status2('done','',2);
Status2('done','',3);